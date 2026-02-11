CREATE OR REPLACE VIEW view_stg_sales_events AS
SELECT 
    o.order_id,
    o.order_created_utc as order_date,
    o.store_code,
    o.net_revenue,
    
    -- Omnichannel Segmentation
    COALESCE(sig.created_via, 'unknown') as raw_channel,
    CASE 
        WHEN sig.created_via = 'pos' THEN 'Point of Sale'
        WHEN sig.created_via = 'admin' THEN 'Manual Admin'
        WHEN sig.created_via = 'checkout' THEN 'Online Web'
        ELSE 'Other Channels'
    END as channel_name,

    -- Seasonality Labels in English
    CASE 
        WHEN MONTH(o.order_created_utc) = 11 AND DAY(o.order_created_utc) >= 20 THEN 'Black Friday Season'
        WHEN MONTH(o.order_created_utc) = 12 THEN 'Holiday Season'
        ELSE 'Regular Period'
    END as season_type,

    -- Major High-Impact Events
    CASE 
        WHEN o.order_created_utc BETWEEN '2022-11-20' AND '2022-12-18' THEN 'FIFA World Cup 2022'
        WHEN o.order_created_utc BETWEEN '2021-06-13' AND '2021-07-10' THEN 'Copa America 2021'
        WHEN o.order_created_utc BETWEEN '2019-06-14' AND '2019-07-07' THEN 'Copa America 2019'
        ELSE 'No Special Event'
    END as sport_event_name

FROM fact_orders o
LEFT JOIN stg_order_signals sig ON o.order_id = sig.order_id AND o.store_code = sig.store_code;
