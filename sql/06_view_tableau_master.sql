CREATE OR REPLACE VIEW view_tableau_master AS
WITH clean_orders AS (
    SELECT 
        order_id, 
        MAX(order_created_utc) as order_date, 
        MAX(store_code) as store_code, 
        MAX(customer_key) as customer_key,
        MAX(net_revenue) as net_revenue
    FROM fact_orders
    GROUP BY order_id
),
clean_items AS (
    SELECT 
        order_id, 
        product_id, 
        SUM(line_total) as line_total, 
        SUM(quantity) as quantity
    FROM fact_order_items
    GROUP BY order_id, product_id
),
dedup_events AS (
    SELECT 
        order_id,
        MAX(channel_name) as channel_name,
        MAX(season_type) as season_type,
        MAX(sport_event_name) as sport_event_name
    FROM view_stg_sales_events
    GROUP BY order_id
)
SELECT 
    o.order_id,
    o.order_date,
    o.store_code,
    o.customer_key,
    ev.channel_name,
    ev.season_type,
    ev.sport_event_name,
    pm.niche_term,
    pm.product_category,
    oi.line_total,
    oi.quantity
FROM clean_orders o
JOIN clean_items oi ON o.order_id = oi.order_id
LEFT JOIN dedup_events ev ON o.order_id = ev.order_id
LEFT JOIN view_stg_product_master pm ON oi.product_id = pm.product_id;
