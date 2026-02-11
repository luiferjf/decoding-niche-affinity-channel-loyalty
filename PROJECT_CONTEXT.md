# Project Context: Customer Equity Audit (2026)

This document defines the scope of the "Customer Equity Audit" project, designed to demonstrate Senior Data Analyst capabilities by analyzing the intersection of **Product Interest**, **Sales Channel**, and **Customer Value**.

## 1. Project Identity
**Title:** Customer Equity Audit & Niche Strategy.
**Goal:** Optimize Factory Throughput & Marketing Spend by identifying High-LTV (Lifetime Value) Customer Segments.
**Key Question:** "Who are our most valuable customers, what Niche brought them in, and through which Channel do they stay loyal?"

## 2. The Three Strategic Pillars (The "Cube")

### A. Interest Niches (The "What")
Instead of analyzing generic "Products", we analyze **"Interests"**.
- **Oriente Petrolero (Baseline):** High volume, local passion.
- **Formula 1 (Trend):** Exploding popularity, potentially high value.
- **Pop Culture (Viral):** Short lifecycle, high impulse (movies/series).
- **International Football (Legacy):** Real Madrid, Man Utd (Global brands).

### B. Sales Channels (The "Where")
We analyze the medium to understand the "Human Touch" vs "Automation".
- **Web (Checkout):** 100% Digital, self-service.
- **Admin (WhatsApp/Social):** Human-assisted sales (High effort, potentially high loyalty).
- **POS (Physical):** In-person experience. **Note**: High volume of "NIT" (Tax ID) transactions indicating purchase for tax credit/business use rather than pure fan loyalty.

### C. RFM Segmentation (The "Who")
We mathematically classify customers based on behavior (2018-2023).
- **Champions (5-5-5):** Bought recently, buy often, spend the most. The "Whales".
- **Loyal Customers:** Frequent buyers. The "Backbone".
- **New Customers:** High Recency, Low Frequency. The "Future".
- **At Risk:** High Frequency (past), Low Recency. The "Bleeding" (Churn).

## 3. The Correlations (The "Golden Nuggets")

### 1. Niche x Segment (The "Gateway Drug")
*Question:* "Which Niche creates Champions?"
*Hypothesis:* F1 might attract many "New Customers" (Viral), but Football creates "Champions" (Repeat).
*Action:* Shift marketing budget to the Niche that builds Equity, not just Volume.

### 2. Channel x Segment (The "Human Factor")
*Question:* "Does the Admin channel reduce Churn?"
*Hypothesis:* Customers who interact with humans (Admin) have a higher retention rate than Web customers.
*Action:* If true, validate the 15-person team cost as a "Retention Investment".

### 3. Niche x Channel (Channel Preference)
*Question:* "Where do F1 fans prefer to buy?"
*Hypothesis:* Tech-savvy niches (F1, Gamers) prefer Web. Traditional niches (Oriente) prefer WhatsApp.
*Action:* Tailor the sales experience per Niche.

## 4. Technical Execution
- **Step 1 (Unified View):** Create `view_stg_master_sales` (One line per item with Niche/Channel tags).
- **Step 2 (RFM Engine):** Create `view_fct_rfm_segmentation`. **Filtering**: Exclude short keys/NITs to separate B2B tax buyers from true fan behavior.
- **Step 3 (Strategic Join):** Create `view_rpt_strategic_insights` linking Segmentation to Niches and Channels.
