# 🛒 End-to-End E-Commerce Revenue & Retention Intelligence

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge\&logo=postgresql\&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge\&logo=python\&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-2C2D72?style=for-the-badge\&logo=pandas\&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge\&logo=Power%20BI\&logoColor=black)

## 📌 Executive Summary

This project is a full-stack data analytics pipeline built for a simulated e-commerce company (based on the Olist Brazilian E-Commerce dataset). The goal was to engineer a relational database from 100,000+ raw records, perform advanced SQL analytics, and build an automated BI reporting layer to uncover the drivers of revenue, funnel drop-offs, and customer churn.

**Key Achievements:** Engineered an automated Python ETL pipeline, authored 150+ lines of advanced SQL (CTEs, Window Functions, Cohorts), and designed an executive-facing Power BI dashboard.

---

## 📊 Executive Power BI Dashboard

I built an interactive Business Intelligence dashboard to allow stakeholders to filter revenue trends, monitor AOV, and track payment behaviors dynamically.

![Executive Dashboard](reports/executive_dashboard.png)

---

## 💡 Key Business Insights & Strategic Recommendations

Rather than just reporting numbers, this project translates data into actionable business strategies:

* 🚨 **The "Leaky Bucket" Retention Problem:**

  * **Finding:** 97% of the user base consists of one-time buyers. Recency analysis reveals that over 70% of customers are either "Churned" or "Lost" (no purchases in 6+ months).
  * **Recommendation:** Shift the marketing budget from user acquisition toward retention. Implement a 30-day and 90-day post-purchase automated email sequence offering targeted discounts on complementary products.
* 🛒 **High Cart Abandonment Rate:**

  * **Finding:** Funnel analysis reveals a 69.6% cart abandonment rate. Users add items to their carts but drop off before payment.
  * **Recommendation:** Deploy automated "abandoned cart" push notifications within 2 hours of drop-off and simplify the checkout UI to reduce friction.
* 💳 **Payment Type Drives Order Value:**

  * **Finding:** Customers using Credit Cards generate the highest Average Order Value (AOV) at $162.86, while Voucher users generate the lowest ($93.24).
  * **Recommendation:** Partner with credit card providers to offer cash-back incentives or "Buy Now, Pay Later" (BNPL) options to encourage users toward higher-AOV payment methods.

---

## 🏗️ Data Architecture & Pipeline

1. **Extract & Load (Python/Pandas):**

   * Processed raw CSV datasets by handling missing values, standardizing date formats, and resolving foreign-key constraints.
   * Utilized `SQLAlchemy` to automate the ingestion of 100,000+ rows into a relational PostgreSQL database.
2. **Transform & Analyze (PostgreSQL):**

   * Designed a robust relational schema (`orders`, `customers`, `products`, `payments`, `events`).
   * Authored complex SQL modules utilizing **multi-table JOINs, CTEs, Window Functions (`LAG`, `OVER`), date math, and aggregations**.
3. **Automate (Python/Matplotlib):**

   * Built an automated reporting script (`generate_revenue_report.py`) that queries the live database and generates localized trend visualizations for weekly stakeholder updates.
4. **Visualize (Power BI):**

   * Connected Power BI directly to the PostgreSQL database to build a dynamic, interactive dashboard with cross-filtering capabilities.

---

## 📂 Repository Structure

```text
📦 ecommerce-revenue-intelligence
 ┣ 📂 bi/                   # Power BI dashboard files (.pbix)
 ┣ 📂 docs/                 # Project architecture and execution roadmap
 ┣ 📂 python/
 ┃ ┗ 📂 scripts/            # ETL pipelines and automated reporting scripts
 ┣ 📂 reports/              # Generated visualizations and dashboard screenshots
 ┣ 📂 sql/
 ┃ ┣ 📂 schema/             # DDL statements (create_tables.sql)
 ┃ ┗ 📂 queries/            # Advanced SQL analytics modules
 ┃   ┣ module_1_descriptive.sql
 ┃   ┣ module_2_user_behavior.sql
 ┃   ┣ module_3_funnel.sql
 ┃   ┗ module_4_cohorts_retention.sql
 ┣ .gitignore               # Ignores raw data / virtual environments
 ┗ README.md                # Project documentation
```

---

## 🚀 How to Run the Project

**Clone the repository:**
`git clone https://github.com/yourusername/ecommerce-revenue-intelligence.git`

**Set up the virtual environment:**
`python -m venv .venv`
`pip install -r requirements.txt`
(Dependencies: pandas, sqlalchemy, psycopg2-binary, matplotlib, seaborn)

**Initialize the database:**
Run the scripts in `sql/schema/` to generate the PostgreSQL tables.

**Run the ETL pipeline:**
Execute `python/scripts/load_data.py` to populate the database.

**Generate reports:**
Execute `python/scripts/generate_revenue_report.py` to auto-generate the latest revenue charts.
