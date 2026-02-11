const mysql = require('mysql2/promise');

const targetConfig = {
    host: 'srv1567.hstgr.io',
    user: 'u298795178_agent_lab',
    password: '2C&bPx+jr',
    database: 'u298795178_agent_lab'
};

const sourceConfigs = [
    { name: 'pasion', user: 'u298795178_pasion', password: 'Lfjf6239094', database: 'u298795178_pasion' },
    { name: 'rabbona', user: 'u298795178_rbn', password: 'Lfjf6239094', database: 'u298795178_rbn' },
    { name: 'victus', user: 'u298795178_victus', password: 'Lfjf6239094', database: 'u298795178_victus' },
    { name: 'nebula', user: 'u298795178_nebula', password: 'Lfjf6239094', database: 'u298795178_nebula' }
];

async function debugEtl() {
    let targetConn;
    try {
        console.log("Connecting to Agent Lab...");
        targetConn = await mysql.createConnection(targetConfig);

        console.log("\n--- STORE CODES in dim_store ---");
        const [stores] = await targetConn.query("SELECT store_key, store_code, store_name FROM dim_store");
        console.table(stores);

        for (const source of sourceConfigs) {
            console.log(`\n--- Inspecting ${source.name} ---`);
            let sourceConn;
            try {
                sourceConn = await mysql.createConnection({
                    host: 'srv1567.hstgr.io',
                    user: source.user,
                    password: source.password,
                    database: source.database
                });

                const [tables] = await sourceConn.query("SHOW TABLES LIKE '%posts%'");
                const postTable = tables.map(t => Object.values(t)[0])[0]; // Get first match
                console.log(`Found posts table: ${postTable}`);

                // Deduce prefix
                const prefix = postTable.replace('posts', '');
                console.log(`Deduced prefix: ${prefix}`);

            } catch (err) {
                console.error(`Error inspecting ${source.name}:`, err.message);
            } finally {
                if (sourceConn) await sourceConn.end();
            }
        }

    } catch (err) {
        console.error("Debug Error:", err);
    } finally {
        if (targetConn) await targetConn.end();
    }
}

debugEtl();
