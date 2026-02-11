const mysql = require('mysql2/promise');

const configs = [
    { name: 'pasion', user: 'u298795178_pasion', password: 'Lfjf6239094', database: 'u298795178_pasion' },
    { name: 'agent_lab', user: 'u298795178_agent_lab', password: '2C&bPx+jr', database: 'u298795178_agent_lab' }
];

const host = 'srv1567.hstgr.io';

async function investigate() {
    for (const config of configs) {
        console.log(`\n--- Investigating ${config.name} ---`);
        let connection;
        try {
            connection = await mysql.createConnection({
                host: host,
                user: config.user,
                password: config.password,
                database: config.database
            });

            if (config.name === 'pasion') {
                // Look for city/billing info in postmeta
                // Usually _billing_city, _billing_state
                console.log('Sample billing metadata:');
                const [meta] = await connection.query(`
                    SELECT meta_key, meta_value 
                    FROM wp_3_postmeta 
                    WHERE meta_key IN ('_billing_city', '_billing_state', '_billing_country') 
                    LIMIT 20
                `);
                console.table(meta);

                // Look for POS or manual order indicators
                // Often _created_via or a specific status
                console.log('Sample order creation metadata:');
                const [via] = await connection.query(`
                    SELECT meta_key, meta_value, COUNT(*) as count 
                    FROM wp_3_postmeta 
                    WHERE meta_key = '_created_via' 
                    GROUP BY meta_value
                `);
                console.table(via);
            }

            if (config.name === 'agent_lab') {
                // Check if city/state was brought into unified schema (might be missing)
                const [cols] = await connection.query('DESCRIBE fact_orders');
                const hasState = cols.some(c => c.Field.includes('state') || c.Field.includes('city'));
                console.log(`Unified schema has location columns: ${hasState}`);
            }

        } catch (err) {
            console.error(`Error investigating ${config.name}:`, err.message);
        } finally {
            if (connection) await connection.end();
        }
    }
}

investigate();
