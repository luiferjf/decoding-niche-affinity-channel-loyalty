-- =======================================================================================
-- LAYER 2: CUSTOMER EQUITY ENGINE (ABSOLUTE RFM)
-- Purpose: Segment customers based on absolute business value thresholds, preventing 
--          high-turnover niches from artificially lowering the 'Champion' definition.
-- =======================================================================================

CREATE OR REPLACE VIEW view_fct_rfm_segmentation AS
WITH customer_aggregates AS (
    SELECT 
        customer_key,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(line_total) AS monetary,
        DATEDIFF('2023-12-31', MAX(order_date)) AS recency_days -- Fixed reference point for portfolio consistency
    FROM view_stg_master_sales
    GROUP BY customer_key
),
rfm_absolute_scoring AS (
    SELECT 
        customer_key,
        recency_days,
        frequency,
        monetary,
        
        -- ABSOLUTE RECENCY SCHEME
        CASE 
            WHEN recency_days <= 30 THEN 5
            WHEN recency_days <= 90 THEN 4
            WHEN recency_days <= 180 THEN 3
            WHEN recency_days <= 365 THEN 2
            ELSE 1
        END AS r_score,
        
        -- ABSOLUTE FREQUENCY SCHEME (Business required: multiple purchases to be loyal)
        CASE 
            WHEN frequency >= 5 THEN 5
            WHEN frequency >= 3 THEN 4
            WHEN frequency = 2 THEN 3
            WHEN frequency = 1 THEN 1 -- Hard floor for one-off buyers
            ELSE 0
        END AS f_score,
        
        -- ABSOLUTE MONETARY SCHEME (Business required: $100+ LTV for top tier)
        CASE 
            WHEN monetary >= 300 THEN 5
            WHEN monetary >= 150 THEN 4
            WHEN monetary >= 75 THEN 3
            WHEN monetary >= 30 THEN 2
            ELSE 1
        END AS m_score

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
    CONCAT(r_score, f_score, m_score) AS rfm_code,
    
    -- Strategic Segmentation Logic
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New / Recent Buyers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk Loyalists'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Churned / One-Off'
        ELSE 'Potential Loyalists'
    END AS customer_segment
FROM rfm_absolute_scoring;
