-- 06_fct_rfm_segmentation.sql
-- Purpose: The Engine. Scoring customers based on value and loyalty.
-- Target: foundation_v1.view_fct_rfm_segmentation

CREATE OR REPLACE VIEW view_fct_rfm_segmentation AS
WITH raw_rfm AS (
    SELECT 
        customer_key,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(line_total) AS monetary,
        DATEDIFF(NOW(), MAX(order_date)) AS recency_days
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
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score, -- 5 is best (most recent)
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,     -- 5 is best (most frequent)
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score       -- 5 is best (highest spend)
    FROM raw_rfm
)
SELECT 
    customer_key,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_cell,
    
    -- Strategic Segmentation (The "Golden Nuggets")
    CASE 
        WHEN r_score = 5 AND f_score = 5 AND m_score = 5 THEN 'Champions'
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Loyal'
        WHEN r_score <= 2 AND f_score >= 4 THEN 'At Risk'  -- Hubieron comprado mucho, pero se fueron
        WHEN r_score >= 4 AND f_score = 1 THEN 'New Customers'
        ELSE 'Review'
    END AS customer_segment
FROM scored_rfm;
