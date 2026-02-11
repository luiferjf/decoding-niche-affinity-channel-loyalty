const mysql = require('mysql2/promise');

const targetConfig = {
    name: 'agent_lab',
    host: 'srv1567.hstgr.io',
    user: 'u298795178_agent_lab',
    password: '2C&bPx+jr',
    database: 'u298795178_agent_lab'
};

const sourceConfigs = [
    { code: 'PA', name: 'pasion', user: 'u298795178_pasion', password: 'Lfjf6239094', database: 'u298795178_pasion', prefix: 'wp_3_' },
    { code: 'RBN', name: 'rabbona', user: 'u298795178_rbn', password: 'Lfjf6239094', database: 'u298795178_rbn', prefix: 'ohf_' },
    { code: 'VIC', name: 'victus', user: 'u298795178_victus', password: 'Lfjf6239094', database: 'u298795178_victus', prefix: 'wp_' },
    { code: 'NEB', name: 'nebula', user: 'u298795178_nebula', password: 'Lfjf6239094', database: 'u298795178_nebula', prefix: 'wp_' }
];

async function runEtl() {
    let targetConn;
    try {
        console.log("Connecting to Agent Lab...");
        targetConn = await mysql.createConnection(targetConfig);

        // 1. ALTER TABLE to add columns if not exist
        console.log("Checking Schema...");
        try {
            await targetConn.query(`
                ALTER TABLE dim_product 
                ADD COLUMN regular_price DECIMAL(10,2), 
                ADD COLUMN sale_price DECIMAL(10,2)
            `);
            console.log("✅ Columns added to dim_product.");
        } catch (e) {
            if (e.code === 'ER_DUP_FIELDNAME') {
                console.log("ℹ️ Columns already exist.");
            } else {
                throw e;
            }
        }

        // 2. Loop through sources and update
        for (const source of sourceConfigs) {
            console.log(`\n--- Processing ${source.name} (${source.code}) ---`);
            let sourceConn;
            try {
                sourceConn = await mysql.createConnection({
                    host: 'srv1567.hstgr.io',
                    user: source.user,
                    password: source.password,
                    database: source.database
                });

                const tablePrefix = source.prefix;

                console.log(`Fetching prices from ${source.database}.${tablePrefix}postmeta...`);

                // Complex query to pivot meta
                const [products] = await sourceConn.query(`
                    SELECT 
                        p.ID,
                        MAX(CASE WHEN pm.meta_key = '_sku' THEN pm.meta_value END) as sku,
                        MAX(CASE WHEN pm.meta_key = '_regular_price' THEN pm.meta_value END) as regular_price,
                        MAX(CASE WHEN pm.meta_key = '_sale_price' THEN pm.meta_value END) as sale_price
                    FROM ${tablePrefix}posts p
                    LEFT JOIN ${tablePrefix}postmeta pm ON p.ID = pm.post_id
                    WHERE p.post_type IN ('product', 'product_variation')
                    AND pm.meta_key IN ('_sku', '_regular_price', '_sale_price')
                    GROUP BY p.ID
                    HAVING sku IS NOT NULL AND sku != ''
                `);

                console.log(`Found ${products.length} products with SKUs in source.`);

                // Batch Update Target
                let updatedCount = 0;
                for (const p of products) {
                    if (!p.regular_price && !p.sale_price) continue;

                    const reg = p.regular_price || null;
                    const sale = p.sale_price || null;

                    // Update agent_lab
                    // Matching by SKU and Store Code
                    const [res] = await targetConn.query(`
                        UPDATE dim_product 
                        SET regular_price = ?, sale_price = ?
                        WHERE sku = ? AND store_code = ?
                    `, [reg, sale, p.sku, source.code]);

                    updatedCount += res.affectedRows;
                }
                console.log(`✅ Updated ${updatedCount} rows in dim_product for ${source.name}.`);

            } catch (err) {
                console.error(`Error processing ${source.name}:`, err.message);
            } finally {
                if (sourceConn) await sourceConn.end();
            }
        }

    } catch (err) {
        console.error("Global ETL Error:", err);
    } finally {
        if (targetConn) await targetConn.end();
    }
}

runEtl();
