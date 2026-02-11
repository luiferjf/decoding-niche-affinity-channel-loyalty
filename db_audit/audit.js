const mysql = require('mysql2/promise');

const configs = [
    { name: 'pasion', user: 'u298795178_pasion', password: 'Lfjf6239094', database: 'u298795178_pasion' },
    { name: 'rbn', user: 'u298795178_rbn', password: 'Lfjf6239094', database: 'u298795178_rbn' },
    { name: 'victus', user: 'u298795178_victus', password: 'Lfjf6239094', database: 'u298795178_victus' },
    { name: 'nebula', user: 'u298795178_nebula', password: 'Lfjf6239094', database: 'u298795178_nebula' },
    { name: 'foundation', user: 'u298795178_foundation_v1', password: 'Lfjf6239094', database: 'u298795178_foundation_v1' },
    { name: 'agent_lab', user: 'u298795178_agent_lab', password: '2C&bPx+jr', database: 'u298795178_agent_lab' }
];

const host = 'srv1567.hstgr.io';

async function audit() {
    for (const config of configs) {
        console.log(`\n--- Auditing ${config.name} ---`);
        let connection;
        try {
            connection = await mysql.createConnection({
                host: host,
                user: config.user,
                password: config.password,
                database: config.database,
                connectTimeout: 10000
            });

            const [tables] = await connection.query('SHOW TABLES');
            const tableNames = tables.map(t => Object.values(t)[0]);
            console.log(`Tables in ${config.name}: ${tableNames.length} tables found`);
            if (tableNames.length < 20) console.log(`Tables: ${tableNames.join(', ')}`);

            // Audit row counts for key tables
            const keyTables = tableNames.filter(name =>
                name.includes('posts') ||
                name.includes('order_items') ||
                name.includes('dim_') ||
                name.includes('fact_')
            );

            for (const table of keyTables) {
                try {
                    const [rows] = await connection.query(`SELECT COUNT(*) as count FROM ${table}`);
                    console.log(`Table ${table}: ${rows[0].count} rows`);
                } catch (e) { }
            }

            // Check if there is an analytical schema
            const analyticalTables = tableNames.filter(n => n.startsWith('dim_') || n.startsWith('fact_'));
            if (analyticalTables.length > 0) {
                console.log(`Analytical tables found: ${analyticalTables.join(', ')}`);
                for (const table of analyticalTables.slice(0, 3)) {
                    const [columns] = await connection.query(`DESCRIBE ${table}`);
                    console.log(`Schema for ${table}:`);
                    console.table(columns.map(c => ({ column: c.Field, type: c.Type })));
                }
            }

        } catch (err) {
            console.error(`Error auditing ${config.name}:`, err.message);
        } finally {
            if (connection) await connection.end();
        }
    }
}

audit();
