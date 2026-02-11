# Executive Report: Customer Equity Audit & Niche Strategy
**Client:** Unified Retail Group (Portfolio) | **Period:** 2018 - 2023 

![Dashboard Overview](../dashboards/Dashboard-project.png)

## 1. The Business Problem
The client operates a complex ecosystem of 4 distinct brands (**Oriente Petrolero, Rabbona, Victus, Nebula**) supported by an **Agile In-House Manufacturing Hub**.
**The Challenge:** The business evolved from a pure digital model to a **Hybrid Retail System** (Physical Store + E-commerce). Production complexity varied by design (tiered vinyl costs, variable labor time), creating hidden margin leaks. While production was agile, marketing budget was being allocated inefficiently based on "Volume" rather than "Customer Value".

## 2. The Solution: Customer Equity Audit
We unified data from all 4 WooCommerce stores into a single Analytical Engine to audit the business across three dimensions:
1.  **Niche Affinity:** Moving beyond "Products" to "Passions" (F1, Football, Pop Culture).
2.  **Channel Loyalty:** Evaluating the ROI of the "High Touch" **Chat Channel (WhatsApp, FB Messenger, IG DM, TikTok DM)**.
3.  **RFM Segmentation:** Mathematically identifying "Champions" (High Lifetime Value).

## 3. Key Findings & Strategic Insights

### A. Niche Strategy: Acquisition vs. Loyalty
*   **Formula 1: High Acquisition, High Churn.** F1 drives the highest volume of New Customers (70% via Web), yet shows lower retention. High volume is currently a "one-off" transaction model.
    *   **Strategic Action (Frequency & Conversion):** Increase **Launch Cadence** (more frequent drops) and implement automated email/SMS flows to turn these "New Customers" into repeat buyers. 
*   **Oriente Petrolero: The Loyalty Engine.** While acquisition volume is lower, these customers have a **3x higher probability** of becoming "Champions." They are the anchor of business profitability.
    *   **Strategic Action (Retention First):** Prioritize budget for loyalty-re-engagement campaigns and exclusive customer-only drops for the Oriente segment.
*   **Real Madrid: The High-Affinity Gem.** High natural retention (**2.5:1** Ratio).
    *   **Strategic Action (AOV Growth):** Implement **Bundle Pricing** to increase average order value, capitalizing on the high loyalty.

### B. Channel Audit: The ROI of Assisted Sales
*   **Chat Channel (WhatsApp, FB Messenger, IG DM, TikTok DM):** This is the **Retention Champion**. **28% (1 in 3)** customers are Champions. Personalized assisted sales is the preferred anchor for high-value loyalists.
    *   **Strategic Action:** Designate Chat channels for **Exclusive Pre-Launch Access**. Target Oriente Champions with early-access links via WhatsApp 24 hours before public release.
*   **Web Checkout:** High acquisition volume but secondary for Champion conversion (1.2%).
    *   **Strategic Action (Omnichannel Migration):** Use remarketing to migrate "Web-Only" buyers of high-potential niches (Oriente) into the high-retention Chat ecosystem.
*   **POS Data Quality Issue:** We identified a significant bias in POS data where high-volume customers were anonymous (NIT/Tax-ID). Filters were applied to exclude "Ghost Champions".

### C. The Triple Nexus (Targeting Strategy)
*   **Profile 1: The Champion Traditionalist:** These are the business's most valuable customers (**Champions**). They are fans of the local club (Oriente) who exclusively use **Chat Channels** for their transactions. This segment represents the perfect intersection of high-affinity interest and high-touch relationship management.
    *   **Strategic Action (VIP Outbound):** Implement a "Sneak Peek" protocol where agents actively **Call** top Champions before a launch to offer exclusive pre-order access with a loyalty discount. *Why?* High-touch service drives emotional loyalty in this segment.
*   **Profile 2: The Modern Fan:** A global sports fan (F1/Europe) who buys via Web. Values speed and autonomy.
    *   **Strategic Action (CRO & Automation):** Optimize the "Speed of Purchase" (Fast Checkout). Implement aggressive **Order Bumps** (One-Click Upsells) to maximize AOV without human friction. Expand reach via **TikTok Ads & SMS Marketing** to catch them where they browse.

### D. Growth Engine (Cross-Sell Probabilities)
The "Next Best Action" matrix identified high-probability cross-sell paths based on historical behavior:

| Purchase A (Trigger) | Next Likely Purchase (Offer) | Probability | Strategic Action (The "Playbook") |
| :--- | :--- | :--- | :--- |
| **Oriente Petrolero** | **Real Madrid** | **35.2%** | **Multi-Tier Loyalty:** Latam customers show high lealtad dual (Local Hero + European Giant). Offer "Home + Global" bundle discounts. |
| **Inglaterra** | **Manchester United** | **33.3%** | **Affinity Bundles:** Country + Club correlation. If they buy England, instantly offer Man Utd at checkout. |
| **Barcelona** | **PSG** | **12.3%** | **The "Player" Effect:** Launch player-centric campaigns (Messi/Neymar legacy) targeting Barcelona buyers with PSG kits. |
| **Oriente Petrolero** | **Bolivia National Team** | **9.2%** | **Event-Triggered:** Push National Team drops to Oriente buyers specifically during FIFA Match Weeks. |

## 4. Technical Approach
*   **Data Structure:** Unified 4 SQL databases into a single Star Schema.
*   **Segmentation:** Implemented RFM using SQL `NTILE(5)` window functions.
*   **Visualization:** Tableau Dashboard (Hyperlinks to be added).
