const mysql = require('mysql2/promise');

const config = { name: 'agent_lab', user: 'u298795178_agent_lab', password: '2C&bPx+jr', database: 'u298795178_agent_lab' };
const host = 'srv1567.hstgr.io';

async function detailAudit() {
    console.log(`\n--- Detail Audit of Agent Lab Star Schema ---`);
    let connection;
    try {
        connection = await mysql.createConnection({
            host: host,
            user: config.user,
            password: config.password,
            database: config.database
        });

        // 1. Time range of orders
        const [timeRange] = await connection.query('SELECT MIN(order_date) as start_date, MAX(order_date) as end_date FROM fact_orders');
        console.log(`Order Time Range: ${timeRange[0].start_date} to ${timeRange[0].end_date}`);

        // 2. Customer contact data quality
        const [customerQuality] = await connection.query(`
            SELECT 
                COUNT(*) as total_customers,
                SUM(CASE WHEN customer_email IS NOT NULL AND customer_email != '' THEN 1 ELSE 0 END) as with_email,
                SUM(CASE WHEN customer_phone IS NOT NULL AND customer_phone != '' THEN 1 ELSE 0 END) as with_phone,
                SUM(CASE WHEN (customer_email IS NOT NULL AND customer_email != '') AND (customer_phone IS NOT NULL AND customer_phone != '') THEN 1 ELSE 0 END) as with_both
            FROM dim_customer_profile
        `);
        console.log('Customer Data Quality:', customerQuality[0]);

        // 3. Sales by store
        const [storeSales] = await connection.query(`
            SELECT s.store_name, COUNT(f.order_id) as order_count, SUM(f.total_amount) as total_revenue
            FROM fact_orders f
            JOIN dim_store s ON f.store_id = s.store_id
            GROUP BY s.store_name
        `);
        console.table(storeSales);

        // 4. Sample product terms (categories)
        const [categories] = await connection.query('SELECT name, COUNT(*) as count FROM dim_product_terms GROUP BY name ORDER BY count DESC LIMIT 10');
        console.log('Top Categories/Terms:');
        console.table(categories);

        // 5. Order Channels
        const [channels] = await connection.query('SELECT channel_name, COUNT(*) as count FROM dim_channel GROUP BY channel_name');
        console.log('Order Channels:');
        console.table(channels);

    } catch (err) {
        console.error(`Error in detail audit:`, err.message);
    } finally {
        if (connection) await connection.end();
    }
}

detailAudit();
