# Sales-Analysis-of-a-Mobile-Phone-Store-in-Ho-Chi-Minh-City
This project analyzes the sales data from a mobile phone retail chain in Ho Chi Minh City. The primary goal is to extract actionable business insights from transactional data to answer key questions about customer behavior, product performance, and purchasing trends.
## Dataset
The analysis is based on two main datasets provided in .csv format:

**-Phone_Sales.csv:** Contains detailed transaction data for mobile phones, including customer demographics, product information, pricing, and payment methods.

**-Accessories_Sales.csv:** Contains transaction data for accessories and insurance sold alongside the main products.
## Business Questions & Analytical Strategy
The analysis is structured to answer key business questions by exploring several strategic areas:

**-Sales & Customer Trends:** How do order volumes and the unique customer count trend on a monthly basis? This helps gauge overall business health and growth.

**-Customer Demographics and Preferences:** Who are our key customer segments? We analyze brand preferences by gender and identify the most valuable age groups by purchase volume and revenue.

**-Product Performance:** Which products are our top performers? We identify the top 3 revenue-generating phones each month to understand what drives sales.

**-Cross-Sell & Up-Sell Opportunities:** What is the potential for increasing the average order value? This is investigated by analyzing the accessory/insurance purchasing habits of key customer segments (e.g., the 26-30 age group and customers of specific brands).

**-Payment Behavior Analysis:** How do customers prefer to pay? We explore the popularity of installment plans across different age groups and phone brands to inform financial partnerships and promotions.
## Methodology
**-Data Storage:** The raw data from the CSV files will be uploaded and stored in a relational database on Google BigQuery to facilitate querying.

**-Data Analysis:** Structured Query Language (SQL) will be used to clean, transform, join, and analyze the data to address the defined business questions.

**-Data Visualization:** The results from the SQL queries will be visualized using tools like Google Looker Studio, Tableau, or Power BI to create intuitive charts and dashboards for presenting the findings.

## Insights & Recommendations
This final section will summarize the key findings from the analysis and provide actionable business recommendations.
## Repository Structure
Organize your project files using a clean and intuitive directory structure like the one below:

phone-sales-analysis/
├── data/
│   ├── Phone_Sales.csv
│   └── Accessories_Sales.csv
├── sql_queries/
│   ├── 01_monthly_orders.sql
│   ├── 02_monthly_customers.sql
│   ├── 03_gender_brand_preference.sql
│   ├── 04_age_group_performance.sql
│   ├── 05_top_monthly_revenue_products.sql
│   ├── 06_age_26_30_brand_preference.sql
│   ├── 07_age_26_30_accessories_purchase.sql
│   ├── 08_brand_accessories_purchase.sql
│   ├── 09_age_installment_by_age.sql
│   └── 10_brand_installment_by_brand.sql
├── visualizations/
│   └── (Screenshots of charts, dashboards, etc.)
└── README.md
