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
    
    -- Niche / Interest Dimension (Improved Mapping & Translations)
    CASE 
        WHEN p.store_code = 'PA' THEN 'Oriente Petrolero'
        WHEN t.club_term = 'Serie' THEN 'TV Series'
        WHEN t.club_term = 'Película' THEN 'Movies'
        WHEN t.club_term = 'Fútbol' OR t.club_term = 'Futbol' THEN 'Football'
        WHEN t.club_term = 'Ropa' THEN 'Apparel'
        WHEN t.club_term = 'Regalos' THEN 'Gifts'
        WHEN t.club_term = '' OR t.club_term IS NULL THEN 'Other Trends'
        ELSE t.club_term 
    END AS niche_term,

    -- Standardizing Product Categories (Spanish to English)
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
    
    -- Price & Value
    p.regular_price,
    p.sale_price,
    
    -- Pricing Strategy Metrics
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
