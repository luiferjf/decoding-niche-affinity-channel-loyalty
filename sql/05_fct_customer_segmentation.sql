-- RFM Analysis (Recency, Frequency, Monetary)
-- Reference Date: Maximum date in dataset or dynamic
-- Using Window Functions (NTILE) for objective scoring

CREATE OR REPLACE VIEW view_fct_customer_segmentation AS
WITH customer_aggregates AS (
    SELECT 
        customer_key,
        MAX(order_date) as last_order_date,
        COUNT(DISTINCT order_id) as frequency,
        SUM(line_total) as monetary
    FROM view_tableau_master
    WHERE customer_key IS NOT NULL 
      AND customer_key != '0' 
      AND LENGTH(customer_key) > 5 -- Filters out short dummy IDs
    GROUP BY customer_key
),
rfm_scoring AS (
    SELECT 
        customer_key,
        last_order_date,
        DATEDIFF('2023-12-31', last_order_date) as recency_days, -- Fixed reference point for portfolio consistency
        frequency,
        monetary,
        -- Scoring 1 (Worst) to 5 (Best)
        NTILE(5) OVER (ORDER BY last_order_date ASC) as r_score,     -- Newer dates = Higher Score
        NTILE(5) OVER (ORDER BY frequency ASC) as f_score,           -- Higher freq = Higher Score
        NTILE(5) OVER (ORDER BY monetary ASC) as m_score             -- Higher money = Higher Score
    FROM customer_aggregates
)
SELECT 
    customer_key,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) as rfm_code,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
        ELSE 'Potential Loyalist'
    END as customer_segment
FROM rfm_scoring;
