const mysql = require('mysql2/promise');

const config = {
    host: 'srv1567.hstgr.io',
    user: 'u298795178_agent_lab',
    password: '2C&bPx+jr',
    database: 'u298795178_agent_lab'
};

async function runDiscovery() {
    let connection;
    try {
        console.log("Connecting...");
        connection = await mysql.createConnection(config);

        console.log("\n--- FACT_ORDER_ITEMS COLUMNS ---");
        const [cols] = await connection.query("SHOW COLUMNS FROM fact_order_items");
        console.log(cols.map(c => c.Field).join(", "));

        console.log("\n--- FACT_ORDERS COLUMNS (Refresher) ---");
        const [cols2] = await connection.query("SHOW COLUMNS FROM fact_orders");
        console.log(cols2.map(c => c.Field).join(", "));

        console.log("\n--- SAMPLE ROW fact_order_items ---");
        const [rows] = await connection.query("SELECT * FROM fact_order_items LIMIT 1");
        console.table(rows);

    } catch (err) {
        console.error("Discovery Error:", err);
    } finally {
        if (connection) await connection.end();
    }
}

runDiscovery();
