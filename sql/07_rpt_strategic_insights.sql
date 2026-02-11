-- Strategic Insights View: Linking Segmentation, Niches, and Channels
-- Purpose: Feed the Tableau Dashboard with a single flat table for cross-analysis.

CREATE OR REPLACE VIEW view_rpt_strategic_insights AS
WITH customer_affinity AS (
    -- Get the Top Niche and Top Channel for each customer
    SELECT 
        customer_key,
        SUBSTRING_INDEX(GROUP_CONCAT(niche_term ORDER BY orders_count DESC), ',', 1) as top_niche,
        SUBSTRING_INDEX(GROUP_CONCAT(channel_name ORDER BY orders_count DESC), ',', 1) as top_channel,
        COUNT(DISTINCT niche_term) as unique_niches_bought -- Cross-Niche metric
    FROM view_customer_niche_summary
    GROUP BY customer_key
)
SELECT 
    rfm.customer_key,
    rfm.customer_segment,
    rfm.monetary,
    rfm.frequency,
    rfm.recency_days,
    aff.top_niche,
    aff.top_channel,
    aff.unique_niches_bought,
    
    -- Derived Metrics for Visualization
    CASE WHEN aff.unique_niches_bought > 1 THEN 'Multi-Niche' ELSE 'Single-Niche' END as cross_sell_status,
    CASE WHEN aff.top_channel = 'admin' THEN 'High Touch' ELSE 'Low Touch' END as service_level

FROM view_fct_customer_segmentation rfm
LEFT JOIN customer_affinity aff ON rfm.customer_key = aff.customer_key;
