-- =======================================================================================
-- LAYER 1: DATA STAGING & UNIFICATION
-- Purpose: Clean, translate, and unify 4 distinct WooCommerce sources into analytical views.
-- Target DB: foundation_v1
-- =======================================================================================

-- 1. Product Master (Normalization & Niche Tagging)
CREATE OR REPLACE VIEW view_stg_product_master AS
WITH dedup_products AS (
    SELECT 
        product_id, 
        MAX(store_code) as store_code, 
        MAX(store_key) as store_key,
        MAX(product_name) as product_name,
        MAX(sku) as sku,
        MAX(regular_price) as regular_price,
        MAX(sale_price) as sale_price
    FROM dim_product
    GROUP BY product_id
),
dedup_terms AS (
    SELECT 
        product_id, 
        MAX(club_term) as club_term, 
        MAX(product_type_cat) as product_type_cat 
    FROM dim_product_terms
    GROUP BY product_id
)
SELECT 
    p.product_id,
    p.store_code,
    s.store_name,
    p.product_name,
    p.sku,
    
    -- Niche / Interest Dimension (Attribute-based mapping)
    CASE 
        WHEN p.store_code = 'PA' THEN 'Oriente Petrolero'
        WHEN t.club_term = 'Serie' THEN 'TV Series'
        WHEN t.club_term = 'Película' THEN 'Movies'
        WHEN t.club_term IN ('Fútbol', 'Futbol') THEN 'Football'
        WHEN t.club_term = 'Ropa' THEN 'Apparel'
        WHEN t.club_term = 'Regalos' THEN 'Gifts'
        WHEN t.club_term = '' OR t.club_term IS NULL THEN 'Other Trends'
        ELSE t.club_term 
    END AS niche_term,

    -- Standardizing Product Categories
    CASE 
        WHEN t.product_type_cat = 'Adulto' THEN 'Adult'
        WHEN t.product_type_cat IN ('Mujer', 'Mujeres') THEN 'Women'
        WHEN t.product_type_cat = 'Niño' THEN 'Kids'
        WHEN t.product_type_cat = 'Gorras' THEN 'Caps'
        WHEN t.product_type_cat = 'Música' THEN 'Music'
        WHEN t.product_type_cat LIKE '%Peliculas%' OR t.product_type_cat LIKE '%Series%' THEN 'TV & Movies'
        WHEN t.product_type_cat = 'Aeroespacial' THEN 'Aerospace'
        WHEN t.product_type_cat = '' OR t.product_type_cat IS NULL THEN 'Uncategorized'
        ELSE t.product_type_cat 
    END AS product_category,
    
    p.regular_price,
    p.sale_price,
    
    CASE 
        WHEN p.regular_price > p.sale_price THEN (p.regular_price - p.sale_price) 
        ELSE 0 
    END as discount_amount,
    
    CASE 
        WHEN p.regular_price > 0 THEN ROUND(((p.regular_price - p.sale_price) / p.regular_price) * 100, 2)
        ELSE 0 
    END as discount_percentage

FROM dedup_products p
LEFT JOIN dedup_terms t ON p.product_id = t.product_id
JOIN dim_store s ON p.store_key = s.store_key;


-- 2. Sales Events & Channel Classification
CREATE OR REPLACE VIEW view_stg_sales_events AS
SELECT 
    o.order_id,
    o.order_created_utc as order_date,
    o.store_code,
    o.net_revenue,
    
    -- Omnichannel Segmentation
    COALESCE(sig.created_via, 'unknown') as raw_channel,
    CASE 
        WHEN sig.created_via = 'pos' THEN 'Point of Sale'
        WHEN sig.created_via = 'admin' THEN 'Chat / Assisted Sales'
        WHEN sig.created_via = 'checkout' THEN 'Web Checkout'
        ELSE 'Other Channels'
    END as channel_name,

    CASE 
        WHEN MONTH(o.order_created_utc) = 11 AND DAY(o.order_created_utc) >= 20 THEN 'Black Friday Season'
        WHEN MONTH(o.order_created_utc) = 12 THEN 'Holiday Season'
        ELSE 'Regular Period'
    END as season_type
FROM fact_orders o
LEFT JOIN stg_order_signals sig ON o.order_id = sig.order_id AND o.store_code = sig.store_code;


-- 3. Master Sales (The "Truth Table" with strict Data Quality rules)
CREATE OR REPLACE VIEW view_stg_master_sales AS
SELECT 
    f.order_id,
    -- PII Governance: Resolving identity using hashed fields if customer_key is missing
    COALESCE(NULLIF(f.customer_key, ''), NULLIF(f.email_hash, ''), NULLIF(f.phone_hash, ''), 'Anonymous') AS customer_key,
    f.order_created_utc AS order_date,
    ev.channel_name,
    pm.niche_term,
    i.line_total,
    i.quantity
FROM fact_orders f
JOIN fact_order_items i ON f.order_id = i.order_id
LEFT JOIN view_stg_product_master pm ON i.product_id = pm.product_id
LEFT JOIN view_stg_sales_events ev ON f.order_id = ev.order_id
WHERE f.status_canonical = 'paid' -- CRITICAL: Filter out failed/cancelled orders
  AND COALESCE(NULLIF(f.customer_key, ''), NULLIF(f.email_hash, ''), NULLIF(f.phone_hash, '')) IS NOT NULL; -- Filter "Ghost Champions" (fully anonymous POS)
