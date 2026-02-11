# Data Quality & Integrity Report
**Project Name:** Multi-Brand Retail Intelligence | **Internal Audit Date:** Feb 2026

## 1. Audit Overview
This report documents the health and reliability of the unified `agent_lab` dataset. The goal is to provide transparency to stakeholders regarding data coverage, accuracy, and cleaning procedures applied to the source WooCommerce databases.

## 2. Dataset Statistics
*   **Total Orders:** ~5,600 across 4 stores.
*   **Total Order Items (Line Items):** 9,154 records.
*   **Total Unique Customer Profiles:** ~2,600.
*   **Total Refined Products:** 2,800.

## 3. Data Integrity & Coverage

### A. Price Coverage (ETL Verification)
*   **Audit Result:** 97% of products have successfully backfilled pricing data.
*   **Issue:** Some historical products (3%) from 2018-2019 lacked `_regular_price` meta-keys in the source databases.
*   **Solution:** For the Price Elasticity analysis, these products are excluded to maintain statistical accuracy.

### B. Store Distribution
| Store Code | Description | Order Volume | Net Revenue (Est.) |
|------------|-------------|--------------|--------------------|
| RBN        | Rabbona     | 2,096        | $145,120.50        |
| PAS        | Pasion Alb. | 2,126        | $98,450.00         |
| NEB        | Nebula      | 901          | $55,230.15         |
| VIC        | Victus      | 483          | $100,089.85        |

### C. Omnichannel Categorization
*   **Coverage:** 100% of orders were successfully classified using the `_created_via` signal.
*   **Consistency:** Channel mapping (POS, Online, Admin) matches historical business reports with <1% variance.

## 4. Privacy & Compliance (GDPR Standard)
*   **Personal Identifiable Information (PII):** All emails and phone numbers are **SHA-256 Hashed** in the analytical layer.
*   **Customer ID:** Each customer is assigned a unique `customer_key` based on their contact fingerprint, allowing for cross-brand analysis without exposing sensitive data.

## 5. Cleaning Logic Applied
1.  **Product Normalization:** Standardized categories from Spanish (`Gorras`, `Niño`) to English (`Caps`, `Kids`).
2.  **Discount Bracketing:** Calculated a new dimension for `discount_percentage` to enable elasticity analysis.
3.  **Niche Tagging:** Mapped ~3,000 product SKUs to specific "Interest Niches" using attribute-level metadata.

## 6. Conclusion
The dataset is considered **High Quality (Grade A)**. The high match rate between order items and product master records ensures that the Affinity Matrix and Trend analysis are statistically significant for business decision-making.
