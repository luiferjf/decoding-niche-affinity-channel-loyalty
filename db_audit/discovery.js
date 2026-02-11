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

        console.log("\n--- SEARCHING FOR ORDER ITEM TABLES ---");
        const [tables] = await connection.query(`
            SELECT TABLE_NAME 
            FROM information_schema.tables 
            WHERE TABLE_SCHEMA = 'u298795178_agent_lab' 
            AND (TABLE_NAME LIKE '%order%' OR TABLE_NAME LIKE '%item%' OR TABLE_NAME LIKE '%line%')
        `);
        console.table(tables);

    } catch (err) {
        console.error("Discovery Error:", err);
    } finally {
        if (connection) await connection.end();
    }
}

runDiscovery();
