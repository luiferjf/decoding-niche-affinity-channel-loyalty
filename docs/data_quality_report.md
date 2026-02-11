# Data Quality & Integrity Report
**Project Name:** Multi-Brand Retail Intelligence | **Internal Audit Date:** Feb 2026

## 1. Audit Overview
This report documents the health and reliability of the unified **`foundation_v1`** dataset. The goal is to provide transparency regarding data coverage, accuracy, and the robust cleaning procedures applied to the four (4) source WooCommerce databases.

## 2. Dataset Statistics
*   **Total Orders:** ~5,600 across 4 stores.
*   **Total Order Items:** 9,154 records.
*   **Total Unique Customer Profiles:** ~2,600.
*   **Unified Product Catalog:** ~2,800 entries mapping across all brands.

## 3. Data Integrity & Coverage

### A. Price Integrity (Audit Result)
*   **Success Rate:** 97% of products have verified historical pricing data.
*   **Edge Case:** 3% of legacy products (2018-2019) with missing price meta-keys were excluded from Price Elasticity models to ensure statistical rigor.

### B. Store Distribution
| Store Code | Description | Order Volume | Net Revenue (Est.) |
|------------|-------------|--------------|--------------------|
| RBN        | Rabbona     | 2,096        | $145,120.50        |
| PAS        | Pasion Alb. | 2,126        | $98,450.00         |
| NEB        | Nebula      | 901          | $55,230.15         |
| VIC        | Victus      | 483          | $100,089.85        |

### C. Channel Classification
*   **Coverage:** 100% classification via original `_created_via` flags.
*   **POS Integrity:** POS sales were isolated during the individual loyalty audit. Due to the high frequency of generic IDs used in physical store transactions, POS data was treated as a "Volume" signal, ensuring it did not bias the "Customer Champion" models.

## 4. Privacy & Governance (Industry Standards)
*   **PII anonymization:** All sensitive customer data (Emails/Phones) underwent **SHA-256 Hashing** prior to entering the analytical layer.
*   **Unified Key Management:** A unique `customer_key` was generated based on hashed identifiers, enabling high-accuracy cross-brand tracking without exposing raw customer data.

## 5. Cleaning & Normalization Logic
1.  **Product Normalization:** Mapped 500+ inconsistent SKUs into stabilized categories and names.
2.  **Attribute-Based Grouping:** Automated the assignment of **Strategic Niches** (F1, Oriente, etc.) by analyzing product-level attribute metadata across all multi-brand databases.
3.  **LTV Integrity:** Deduplication of profiles created via guest-checkout to ensure accurate frequency counts.

## 6. Conclusion
The **`foundation_v1`** dataset is certified as **High Quality (Grade A)**. The high match rate between transaction line-items and the enriched product master confirms that the Affinity Matrices and RFM Segments are statistically sound for strategic business planning.
