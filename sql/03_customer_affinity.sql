-- 1. Summarize Customer Spend per Niche and Channel
CREATE OR REPLACE VIEW view_customer_niche_summary AS
SELECT 
    o.customer_key,
    ev.channel_name,
    pm.niche_term,
    count(distinct o.order_id) as orders_count,
    sum(oi.line_total) as total_spend
FROM fact_orders o
JOIN fact_order_items oi ON o.order_id = oi.order_id
JOIN view_stg_product_master pm ON oi.product_id = pm.product_id
JOIN view_stg_sales_events ev ON o.order_id = ev.order_id
GROUP BY o.customer_key, ev.channel_name, pm.niche_term;

-- 2. Affinity Matrix (Lift Analysis)
CREATE OR REPLACE VIEW view_rpt_affinity_matrix AS
SELECT 
    a.niche_term as niche_a,
    b.niche_term as niche_b,
    a.channel_name,
    COUNT(DISTINCT a.customer_key) as shared_customers_count,
    
    -- Overlap Percentage
    ROUND(
        COUNT(DISTINCT a.customer_key) / 
        (SELECT COUNT(DISTINCT customer_key) FROM view_customer_niche_summary WHERE niche_term = a.niche_term) * 100, 
    2) as overlap_percentage

FROM view_customer_niche_summary a
JOIN view_customer_niche_summary b ON a.customer_key = b.customer_key
WHERE a.niche_term != b.niche_term
GROUP BY a.niche_term, b.niche_term, a.channel_name;
