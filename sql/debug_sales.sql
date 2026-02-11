-- debug_sales_raw.sql
CREATE OR REPLACE VIEW debug_sales_raw AS
SELECT 
    f.order_id,
    f.status_canonical,
    i.line_total
FROM fact_orders f
JOIN fact_order_items i ON f.order_id = i.order_id;
