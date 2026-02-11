const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const config = {
    host: 'srv1567.hstgr.io',
    user: 'u298795178_agent_lab',
    password: '2C&bPx+jr',
    database: 'u298795178_agent_lab',
    multipleStatements: true
};

const sqlDir = path.join(__dirname, '../sql');

async function deploy() {
    let connection;
    try {
        console.log("Connecting to Agent Lab...");
        connection = await mysql.createConnection(config);

        if (!fs.existsSync(sqlDir)) {
            console.error(`❌ SQL Directory not found: ${sqlDir}`);
            return;
        }

        const files = fs.readdirSync(sqlDir).filter(f => f.endsWith('.sql'));
        console.log(`Found ${files.length} SQL files in ${sqlDir}`);

        for (const file of files) {
            console.log(`\n--- Deploying ${file} ---`);
            const sql = fs.readFileSync(path.join(sqlDir, file), 'utf8');
            try {
                await connection.query(sql);
                console.log(`✅ Successfully deployed ${file}`);
            } catch (err) {
                console.error(`❌ Error deploying ${file}:`, err.message);
            }
        }

    } catch (err) {
        console.error("Deploy Error:", err);
    } finally {
        if (connection) await connection.end();
    }
}

deploy();
