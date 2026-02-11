# Technical Approach: Multi-Source Customer Equity Engine

## 1. Data Architecture: The Analytical Unified Layer
The core challenge was consolidating 4 isolated WooCommerce databases (MariaDB) into a single **Consolidated Star Schema** designed for strategic auditing and hybrid-model analysis.

### Layered SQL Architecture (7-Level View Logic)
To ensure data integrity and performance, I implemented a modular view architecture:
1.  **Level 1-2 (Staging):** Normalizing raw tables from 4 different brands into unified Fact and Dimension structures.
2.  **Level 3-4 (Enrichment):** Grouping 500+ SKUs into **"Strategic Niches"** based on shared product attributes (e.g., Team, Category, Player) to simplify cross-brand analysis.
3.  **Level 5 (Data Quality):** Filtering **POS Sales (Physical Store)**. Since POS transactions were often recorded using generic Tax-IDs/IDs, they were isolated to prevent "Anonymous Ghosting" from skewing the individual loyalty models.
4.  **Level 6 (The Engine):** Calculating RFM Scores using **Absolute Logic** (Segmenting by specific business thresholds rather than simple relative percentiles).
5.  **Level 7 (Reporting):** A flattened, pre-calculated layer optimized for Tableau extracts (< 500ms performance).

## 2. Strategic SQL Engineering

### A. Protecting the "Champion" Integrity (Absolute RFM)
While standard models use relative percentiles (`NTILE`), this business model required higher precision. High-turnover niches like Formula 1 could "artificially" lower the bar for what a Champion is. I implemented **Absolute Revenue and Frequency Thresholds** to ensure a "Champion" is defined by true business-value milestones.

### B. Attribute-Based Niche Normalization
By extracting attributes from product metadata across 4 stores, I created a unified "Niche Hub". This allowed us to see that a customer buying from the "Oriente Petrolero" brand was the same "Profile" regardless of which specific store they purchased from.

## 3. Tech Stack & Performance
*   **Database:** MariaDB (Production Environment).
*   **Data Modeling:** Star Schema (Denormalized for BI efficiency).
*   **Advanced SQL:** Window Functions, CTEs, and Cross-Join matrices for affinity/correlation calculation.
*   **BI Layer:** Tableau Desktop (LOD Expressions for calculating "Share of Champions" and Niche Overlap).
