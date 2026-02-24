-- =======================================================================================
-- LAYER 3: AFFINITY & CROSS-SELL MATRIX
-- Purpose: Calculate the probability of a customer buying cross-niche, generating 
--          actionable signals for retargeting and bundling.
-- =======================================================================================

-- 1. Summarize Customer Spend per Niche and Channel
CREATE OR REPLACE VIEW view_customer_niche_summary AS
SELECT 
    customer_key,
    channel_name,
    niche_term,
    count(distinct order_date) as purchase_days,
    sum(line_total) as total_spend
FROM view_stg_master_sales
GROUP BY customer_key, channel_name, niche_term;

-- 2. Affinity Matrix (Next Best Action / Cross-Sell Correlation)
CREATE OR REPLACE VIEW view_rpt_affinity_matrix AS
SELECT 
    a.niche_term as trigger_niche,
    b.niche_term as target_niche,
    a.channel_name,
    COUNT(DISTINCT a.customer_key) as shared_customers_count,
    
    -- Overlap Percentage (Probability)
    ROUND(
        COUNT(DISTINCT a.customer_key) / 
        (SELECT COUNT(DISTINCT customer_key) FROM view_customer_niche_summary WHERE niche_term = a.niche_term) * 100, 
    2) as cross_sell_probability_pct

FROM view_customer_niche_summary a
JOIN view_customer_niche_summary b ON a.customer_key = b.customer_key
WHERE a.niche_term != b.niche_term
GROUP BY a.niche_term, b.niche_term, a.channel_name;
