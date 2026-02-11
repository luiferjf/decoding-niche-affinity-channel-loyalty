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

        const [rows] = await connection.query("SELECT * FROM fact_order_items LIMIT 1");
        if (rows.length > 0) {
            console.log("Columns:", Object.keys(rows[0]).join(", "));
        } else {
            console.log("No rows found. Showing columns from schema.");
            const [cols] = await connection.query("SHOW COLUMNS FROM fact_order_items");
            console.log(cols.map(c => c.Field).join(", "));
        }

    } catch (err) {
        console.error("Discovery Error:", err);
    } finally {
        if (connection) await connection.end();
    }
}

runDiscovery();
