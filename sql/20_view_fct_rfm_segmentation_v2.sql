-- 20_view_fct_rfm_segmentation_v2.sql
-- Correcting the "Viral Trap" Bug: replacing NTILE for Frequency with Absolute Thresholds.

CREATE OR REPLACE VIEW view_fct_rfm_segmentation AS
WITH raw_rfm AS (
    SELECT 
        customer_key,
        MAX(order_date) as last_order_date,
        COUNT(DISTINCT order_id) as frequency,
        SUM(line_total) as monetary,
        DATEDIFF(NOW(), MAX(order_date)) as recency_days
    FROM view_stg_master_sales
    WHERE customer_key IS NOT NULL 
    GROUP BY customer_key
),
scored_rfm AS (
    SELECT 
        customer_key,
        recency_days,
        frequency,
        monetary,
        -- Recency: Keep NTILE (Relative is fine for time)
        NTILE(5) OVER (ORDER BY recency_days DESC) as r_score,
        
        -- Frequency: ABSOLUTE THRESHOLDS (The Fix)
        -- 88% of customers buy once. If we use NTILE, they get random scores 1-5.
        -- New Logic:
        -- 1 Order = Score 1
        -- 2 Orders = Score 3
        -- 3 Orders = Score 4
        -- 4+ Orders = Score 5
        CASE 
            WHEN frequency >= 4 THEN 5
            WHEN frequency = 3 THEN 4
            WHEN frequency = 2 THEN 3
            ELSE 1 
        END as f_score,

        -- Monetary: Keep NTILE (Relative is fine for spend capacity)
        NTILE(5) OVER (ORDER BY monetary ASC) as m_score
    FROM raw_rfm
)
SELECT 
    customer_key,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) as rfm_cell,
    CASE 
        -- Champions: Bought Recently (4+), Spent Well (4+), AND CAME BACK (Freq >= 2 -> Score 3+)
        WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 4 THEN 'Champions'
        
        -- Loyal: Bought frequently (Freq >= 2)
        WHEN f_score >= 3 THEN 'Loyal Customers'
        
        -- Potential Loyalist: High Recency, High Spend, but only 1 order (The "Whales" or "Traffic")
        WHEN r_score >= 4 AND m_score >= 3 AND f_score = 1 THEN 'Potential Loyalist'
        
        -- New Customers: High Recency, Low Spend, 1 order
        WHEN r_score >= 4 AND f_score = 1 THEN 'New Customers'
        
        -- At Risk: Used to come back (Freq >= 2), but haven't seen them (Recency <= 2)
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        
        -- Lost: Low Recency, Low Frequency
        ELSE 'Lost' 
    END AS customer_segment
FROM scored_rfm;
