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

        console.log("\n--- 1. SHOW DATABASES (Can we see the other stores?) ---");
        const [dbs] = await connection.query("SHOW DATABASES");
        console.log(dbs.map(d => d.Database).join(", "));

        console.log("\n--- 2. Search for WP Tables in Current DB ---");
        // Sometimes they are all in one DB with different prefixes
        const [tables] = await connection.query(`
            SELECT TABLE_NAME 
            FROM information_schema.tables 
            WHERE TABLE_SCHEMA = 'u298795178_agent_lab' 
            AND TABLE_NAME LIKE 'wp_%'
        `);
        if (tables.length > 0) {
            console.log("Found WP tables in agent_lab:", tables.map(t => t.TABLE_NAME).join(", "));
        } else {
            console.log("No WP tables found in agent_lab.");
        }

    } catch (err) {
        console.error("Discovery Error:", err);
    } finally {
        if (connection) await connection.end();
    }
}

runDiscovery();
