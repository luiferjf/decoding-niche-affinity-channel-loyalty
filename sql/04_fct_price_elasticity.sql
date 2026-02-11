CREATE OR REPLACE VIEW view_fct_price_elasticity AS
SELECT 
    pm.product_id,
    pm.product_name,
    pm.niche_term,
    pm.product_category,
    ev.channel_name,
    
    -- Discount Brackets in English
    CASE 
        WHEN pm.discount_percentage = 0 THEN 'Full Price'
        WHEN pm.discount_percentage BETWEEN 0 AND 10 THEN '0-10% Discount'
        WHEN pm.discount_percentage BETWEEN 10 AND 20 THEN '10-20% Discount'
        WHEN pm.discount_percentage BETWEEN 20 AND 30 THEN '20-30% Discount'
        WHEN pm.discount_percentage > 30 THEN 'Deep Discount (>30%)'
        ELSE 'Unknown'
    END as discount_bracket,
    
    -- Metrics
    COUNT(DISTINCT oi.order_id) as total_orders,
    SUM(oi.quantity) as units_sold,
    SUM(oi.line_total) as total_revenue,
    AVG(oi.line_total / NULLIF(oi.quantity,0)) as avg_unit_price

FROM fact_order_items oi
JOIN view_stg_product_master pm ON oi.product_id = pm.product_id
JOIN fact_orders o ON oi.order_id = o.order_id
JOIN view_stg_sales_events ev ON o.order_id = ev.order_id
GROUP BY 
    pm.product_id, 
    pm.product_name, 
    pm.niche_term, 
    pm.product_category,
    ev.channel_name,
    discount_bracket;
