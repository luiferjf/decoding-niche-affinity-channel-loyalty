-- 00_stg_master_sales.sql
-- Purpose: Unify all sales into a single "Truth Table" with strategic tags.
-- Target: foundation_v1.view_stg_master_sales

CREATE OR REPLACE VIEW view_stg_master_sales AS
SELECT 
    f.order_id,
    -- RESCUE LOGIC: If customer_key is missing, fall back to email or phone hash.
    COALESCE(NULLIF(f.customer_key, ''), NULLIF(f.email_hash, ''), NULLIF(f.phone_hash, ''), 'Unknown') AS customer_key,
    f.order_created_utc AS order_date,
    
    -- Strategic KPI: Channel Type (Human vs Automation)
    -- Fallback logic: Assuming main stores are Web unless we find specific POS/Admin flags in a separate meta table.
    -- For now, we tag everything as 'Web (Checkout)' to get the view working, and will refine channel logic next.
    'Web (Checkout)' AS channel_type,

    -- Strategic KPI: Niche / Theme (Interest)
    COALESCE(t.club_term, 'General') AS niche_theme,

    -- Metrics
    i.line_total,
    i.quantity

FROM fact_orders f
JOIN fact_order_items i ON f.order_id = i.order_id
LEFT JOIN dim_product p ON i.product_id = p.product_id
LEFT JOIN dim_product_terms t ON p.product_id = t.product_id

WHERE f.status_canonical = 'paid';
