const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const config = {
    host: 'srv1567.hstgr.io',
    user: 'u298795178_agent_lab',
    password: '2C&bPx+jr',
    database: 'u298795178_agent_lab'
};

async function runExport() {
    let connection;
    try {
        connection = await mysql.createConnection(config);
        console.log('Querying Master View...');
        const [rows] = await connection.query('SELECT * FROM view_tableau_master');

        const headers = Object.keys(rows[0]);
        const csvContent = [
            headers.join(','),
            ...rows.map(row => headers.map(h => {
                let v = row[h];
                if (v === null) return '';
                if (v instanceof Date) return v.toISOString();
                if (typeof v === 'string') return `"${v.replace(/"/g, '""')}"`;
                return v;
            }).join(','))
        ].join('\n');

        fs.writeFileSync('c:/Users/Administrator/Desktop/Workspaces/lista_de_proyectos/data/processed/view_tableau_master.csv', csvContent);
        console.log('✅ File view_tableau_master.csv created successfully.');

    } catch (err) {
        console.error('Export error:', err);
    } finally {
        if (connection) await connection.end();
    }
}

runExport();
