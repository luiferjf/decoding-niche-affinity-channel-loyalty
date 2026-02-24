-- =======================================================================================
-- LAYER 4: STRATEGIC REPORTING (TABLEAU ENDPOINTS)
-- Purpose: Flattened, analytics-ready views designed for direct consumption by Tableau.
-- =======================================================================================

-- 1. Master Transaction Table (Granular)
CREATE OR REPLACE VIEW view_tableau_master AS
SELECT 
    o.order_id,
    o.order_date,
    o.customer_key,
    o.channel_name,
    o.niche_term,
    pm.product_category,
    pm.discount_percentage,
    o.line_total,
    o.quantity
FROM view_stg_master_sales o
LEFT JOIN fact_order_items oi ON o.order_id = oi.order_id
LEFT JOIN view_stg_product_master pm ON oi.product_id = pm.product_id;


-- 2. The Triple Nexus: Segmentation + Niche + Channel Matrix (Aggregated)
CREATE OR REPLACE VIEW view_rpt_strategic_insights AS
WITH primary_affinity AS (
    -- Identify the dominant Niche and Channel for each customer based on spend
    SELECT 
        customer_key,
        SUBSTRING_INDEX(GROUP_CONCAT(niche_term ORDER BY total_spend DESC), ',', 1) as dominant_niche,
        SUBSTRING_INDEX(GROUP_CONCAT(channel_name ORDER BY total_spend DESC), ',', 1) as preferred_channel,
        COUNT(DISTINCT niche_term) as unique_niches_bought
    FROM view_customer_niche_summary
    GROUP BY customer_key
)
SELECT 
    rfm.customer_key,
    rfm.customer_segment,
    rfm.monetary as lifetime_value,
    rfm.frequency as total_orders,
    rfm.recency_days,
    aff.dominant_niche,
    aff.preferred_channel,
    aff.unique_niches_bought,
    
    -- Strategic Action Tags
    CASE WHEN aff.unique_niches_bought > 1 THEN 'Multi-Niche Buyer' ELSE 'Single-Niche Buyer' END as cross_sell_status,
    CASE WHEN aff.preferred_channel = 'Chat / Assisted Sales' THEN 'High-Touch' ELSE 'Self-Serve' END as service_tier

FROM view_fct_rfm_segmentation rfm
JOIN primary_affinity aff ON rfm.customer_key = aff.customer_key;
