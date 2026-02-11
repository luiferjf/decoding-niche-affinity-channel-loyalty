const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const config = {
    host: 'srv1567.hstgr.io',
    user: 'u298795178_agent_lab',
    password: '2C&bPx+jr',
    database: 'u298795178_agent_lab'
};

const viewsToExport = [
    'view_stg_product_master',
    'view_stg_sales_events',
    'view_customer_niche_summary',
    'view_fct_price_elasticity',
    'view_fct_customer_segmentation'
];

const outputDir = path.join(__dirname, '../data/processed');

async function exportData() {
    let connection;
    try {
        console.log("Connecting to Agent Lab...");
        connection = await mysql.createConnection(config);

        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        for (const view of viewsToExport) {
            console.log(`\n--- Exporting ${view} ---`);
            try {
                const [rows] = await connection.query(`SELECT * FROM ${view}`);

                if (rows.length === 0) {
                    console.warn(`⚠️ View ${view} is empty. Skipping.`);
                    continue;
                }

                const headers = Object.keys(rows[0]);
                const csvData = [
                    headers.join(','),
                    ...rows.map(row => headers.map(header => {
                        let val = row[header];
                        if (val === null) return '';
                        if (val instanceof Date) return val.toISOString();
                        if (typeof val === 'string') return `"${val.replace(/"/g, '""')}"`;
                        return val;
                    }).join(','))
                ].join('\n');

                const filePath = path.join(outputDir, `${view}.csv`);
                fs.writeFileSync(filePath, csvData);
                console.log(`✅ CSV generated: ${filePath} (${rows.length} rows)`);
            } catch (queryErr) {
                console.error(`❌ Error exporting ${view}:`, queryErr.message);
            }
        }

    } catch (err) {
        console.error("Critical Export Error:", err);
    } finally {
        if (connection) await connection.end();
    }
}

exportData();
