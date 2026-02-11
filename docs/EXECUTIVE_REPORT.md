# Executive Report: Customer Equity Audit & Niche Strategy
**Client:** Unified Retail Group (Portfolio) | **Period:** 2018 - 2023 

## 1. The Business Problem
The client operates a complex ecosystem of 4 distinct brands (**Oriente Petrolero, Rabbona, Victus, Nebula**) supported by an agile In-House POD (Print-on-Demand) factory. 
**The Challenge:** While production was agile, marketing budget was being allocated inefficiently based on "Volume" rather than "Customer Value". The business lacked a unified view of which Niches (Interests) and Channels were driving true retention vs. one-time churn.

## 2. The Solution: Customer Equity Audit
We unified data from all 4 WooCommerce stores into a single Analytical Engine to audit the business across three dimensions:
1.  **Niche Affinity:** Moving beyond "Products" to "Passions" (F1, Football, Pop Culture).
2.  **Channel Loyalty:** Evaluating the ROI of the "High Touch" WhatsApp Admin channel.
3.  **RFM Segmentation:** Mathematically identifying "Champions" (High Lifetime Value).

## 3. Key Findings & Strategic Insights

### A. Niche Strategy: Volume vs. Value
*   **The "Golden Goose" (Oriente Petrolero):** Drives **70% of the 'Champions'**. It is the engine of the company.
    *   **Strategic Action (WhatsApp-First):** Shift Meta Ads budget entirely to **Click-to-WhatsApp** campaigns. Optimize the **WhatsApp Catalog** for frictionless purchasing and launch new drops exclusively via Chat broadcast lists.
*   **The "Guest Opportunity" (Formula 1):** F1 drives massive traffic. Most are "Guest Checkouts" (skipped account creation), but we **capture 100% of their Email/Phone data**.
    *   **Refined Insight:** Low retention is a **Supply-Side Issue**, not a Demand issue. With only 2 major launches (both sold out), the customer has no reason to return.
    *   **Strategic Action (Frequency & Conversion):** Increase **Launch Cadence** (more frequent drops) to re-engage this high-intent traffic. Allocate budget to **Conversion Campaigns** specifically designed to turn "Guest Data" into "Repeat Buyers".

*   **The "Hidden Gem" (Real Madrid):** Low volume but amazing retention (**2.5:1** Ratio).
    *   **Strategic Action (LTV Growth):** Implement **Bundle Pricing** (e.g., "Season Pack") to artificially raise AOV. Leverage the high natural retention to maximize lifetime value per customer.

### B. Channel Audit: The ROI of Human Touch
*   **WhatsApp (Admin) is for Retention:** **28% (1 in 3)** customers are Champions. In the Bolivian market, "Chat Commerce" is the preferred channel for high-value loyalists.
    *   **Strategic Action:** Designate WhatsApp as the **Exclusive Pre-Launch Channel**. Reward loyalty by giving Champions 24-hour early access via chat before opening to the Web.
*   **Web Checkout:** High volume, low conversion to Champion (1.2%).
    *   **Strategic Action (Channel Migration):** Since Champions prefer Chat, use Email/SMS retargeting to **migrate** Web Guests to WhatsApp. Offer a "VIP Concierge Service" incentive to move them from the low-loyalty Web channel to the high-loyalty Chat channel.
*   **POS Data Quality Issue:** We identified a significant bias in POS data where high-volume customers were anonymous (NIT/Tax-ID). Filters were applied to exclude "Ghost Champions".

### C. The Triple Nexus (Targeting Strategy)
*   **Profile 1: The Traditionalist:** A local club fan (Oriente) who buys via Chat. Values exclusivity and human connection.
    *   **Strategic Action (VIP Outbound):** Implement a "Sneak Peek" protocol where agents actively **Call** top Champions before a launch to offer exclusive pre-order access with a loyalty discount. *Why?* High-touch service drives emotional loyalty in this segment.
*   **Profile 2: The Modern Fan:** A global sports fan (F1/Europe) who buys via Web. Values speed and autonomy.
    *   **Strategic Action (CRO & Automation):** Optimize the "Speed of Purchase" (Fast Checkout). Implement aggressive **Order Bumps** (One-Click Upsells) to maximize AOV without human friction. Expand reach via **TikTok Ads & SMS Marketing** to catch them where they browse.

### D. Growth Engine (Cross-Sell Probabilities)
The "Next Best Action" matrix identified high-probability cross-sell paths based on historical behavior:

| Purchase A (Trigger) | Next Likely Purchase (Offer) | Probability | Strategic Action (The "Playbook") |
| :--- | :--- | :--- | :--- |
| **Real Madrid** | **Oriente Petrolero** | **33.6%** | **Cross-Catalog Campaign:** Target Oriente buyers with Real Madrid offers via WhatsApp (High affinity for both). |
| **Inglaterra** | **Manchester United** | **33.3%** | **Affinity Bundles:** Create "Country + Club" packs. If they buy England, instantly offer Man Utd at checkout. |
| **Barcelona** | **PSG** | **12.3%** | **The "Messi/Neymar" Pivot:** Launch campaigns focused specifically on the *Player*, not the Club, targeting Barcelona buyers. |
| **Oriente Petrolero** | **Bolivia National Team** | **9.2%** | **Event-Triggered:** Launch "Bolivia" campaigns to Oriente fans specifically during **Match Weeks** (High National Pride). |
| **Real Madrid** | **Manchester United** | **9.0%** | **Legacy Stars:** Target Real Madrid buyers with Man Utd content emphasizing the "CR7 Legacy" connection. |

## 4. Technical Approach
*   **Data Structure:** Unified 4 SQL databases into a single Star Schema.
*   **Segmentation:** Implemented RFM using SQL `NTILE(5)` window functions.
*   **Visualization:** Tableau Dashboard (Hyperlinks to be added).
