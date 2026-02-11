const mysql = require('mysql2/promise');

const configs = [
    { name: 'pasion', user: 'u298795178_pasion', password: 'Lfjf6239094', database: 'u298795178_pasion' },
    { name: 'rbn', user: 'u298795178_rbn', password: 'Lfjf6239094', database: 'u298795178_rbn' },
    { name: 'victus', user: 'u298795178_victus', password: 'Lfjf6239094', database: 'u298795178_victus' },
    { name: 'nebula', user: 'u298795178_nebula', password: 'Lfjf6239094', database: 'u298795178_nebula' }
];

async function listTables() {
    for (const config of configs) {
        let connection;
        try {
            connection = await mysql.createConnection({
                host: 'srv1567.hstgr.io',
                user: config.user,
                password: config.password,
                database: config.database
            });

            console.log(`\n--- ${config.name} Tables (ending in 'posts') ---`);
            const [tables] = await connection.query("SHOW TABLES LIKE '%posts'");
            // Print all matches
            tables.forEach(t => console.log(Object.values(t)[0]));

        } catch (err) {
            console.error(`Error with ${config.name}:`, err.message);
        } finally {
            if (connection) await connection.end();
        }
    }
}

listTables();
