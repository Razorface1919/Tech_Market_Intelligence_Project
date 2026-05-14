# Tech Layoffs & Job Market Intelligence Dashboard (2020–2024)

## 📌 Executive Summary
In response to unprecedented volatility in the global technology sector between 2020 and 2024, this full-stack analytics project investigates the macroeconomic shifts across the industry. By integrating over 875,000+ layoff records with global salary distributions and job listing volumes, this end-to-end data pipeline analyzes the intersection of workforce reductions, market demand, and compensation trends.

This project provides actionable intelligence for HR leadership, financial analysts, and tech professionals regarding market risk, compensation distributions, and industry resilience.

### 🔗 Project Links
* **[Watch the Video Demo](https://www.linkedin.com/feed/update/urn:li:ugcPost:7460472724524539904/)**
* **[Executive Presentation (PDF)](https://github.com/Razorface1919/Tech_Market_Intelligence_Project/blob/main/dashboard/Tech_Market_Layoffs_Intelligence_Presentation.pdf)**

---

## 📊 Data Provenance & Attribution
The raw data for this project was sourced from publicly available datasets on Kaggle. The data was strictly used as a baseline and underwent rigorous cleaning, dimensionality reduction, and feature engineering to fit this specific analytical use case. 

* **[Tech Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022):** Tracks global layoff events, company funding stages, and geographic impact → Cleaned, engineered, and ingested as the `layoffs_clean` table.
* **[Global Tech Salaries](https://www.kaggle.com/datasets/ruchi798/data-science-job-salaries):** Aggregates compensation data based on experience level, remote ratios, and job titles → Cleaned, engineered, and ingested as the `salaries_clean` table.
* **[Job Market Intelligence](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings):** Contains active tech job postings, advertised salary bands, and required skill sets → Cleaned, normalized, and ingested as the `jobs_clean` table.

---

## 🎯 Core Business Questions
1. Which industries had the highest layoff severity vs. hiring activity in 2023–24?
2. How does a company's funding stage (Seed to Post-IPO) correlate with layoff severity?
3. What specific skills appear most frequently in postings for the highest-paying analyst roles?
4. Which combination of experience level and remote ratio yields the highest median salary?

---

## 📈 Strategic Business Insights
Based on the data modeled in this repository, four core market truths emerged:

* **The Industry Volatility Matrix:** The Hardware and Consumer sectors exhibited the highest layoff risk globally, accounting for nearly 21% of all headcount reductions.
* **Startup Risk Profiles:** Funding stage is inversely correlated with layoff severity. Seed-stage companies cut the deepest, laying off an average of 82.1% of their workforce, while Series A companies averaged 47.6%.
* **The Experience Premium & Compensation Contraction:** Year-over-Year (YoY) salary growth remained flat or negative for entry-level roles as the market absorbed laid-off talent. High-level remote compensation cooled (e.g., 100% remote Executive-level median salaries dropped by 9.9% YoY), while Senior (SE) and Executive (EX) roles broadly maintained strict market premiums.
* **High-Demand, High-Cost Isolation:** Using distribution modeling, Data Architects emerged as one of the highest-compensated roles with a median salary of $180,000 and a P90 ceiling of $213,120. Data Scientists and Principal Engineers occupy the strategic quadrant of High Demand / High Cost, requiring premium compensation packages to recruit despite market cooling.

---

## 🏗️ Data Architecture & Methodology
This project was executed in a strict 3-Phase architecture, transitioning from raw flat files to a fully interactive business intelligence model.

### Phase 1: Data Engineering & Financial Modeling (Excel)
Focused on data governance, schema normalization, and advanced feature engineering to prepare raw Kaggle datasets for downstream analytical (OLAP) processing.

* **Data Governance:** Standardized text fields using `TRIM(PROPER())`, built dynamic audit logs (`COUNTBLANK`, `COUNTIF`), and forced MDY backend parsing to resolve regional OS date mismatches.
* **Feature Engineering:** Developed a proprietary logarithmic metric (`severity_score_ln = E2 * LN(C2 + 1)`) to normalize extreme layoff outliers (comparing 30,000-person enterprise cuts to 50-person startup closures). Filtered pivot caches to eliminate 1/1/1900 temporal anomalies.
* **Financial Benchmarking:** Built a dynamic descriptive inputs/outputs model using `AVERAGEIFS` and array-based `STDEV.S` calculations. Deployed a 2-variable What-If Data Table with `IFERROR` wrappers to seamlessly handle null matrix intersections (e.g., zero records for "Executive Data Scientist at a Small Company").

### Phase 2: Relational Warehousing & Analytics (PostgreSQL)
* **Database Design:** Built a relational schema bridging Natural Keys (e.g., `job_id`) and auto-generated Surrogate Keys (`id SERIAL`) to ensure referential integrity while successfully resolving DDL schema misalignments and data type overflows.
* **Advanced SQL:** Authored production-grade queries using CTEs for modular aggregation, Window Functions (`LAG()`, `RANK()`, `AVG() OVER()`) for YoY growth and 3-month rolling momentum, and Statistical Functions (`PERCENTILE_CONT()`) to generate robust compensation bands.
* **Schema Optimization:** Intentionally denormalized the Layoffs dataset for read-speed efficiency while ruthlessly normalizing the Jobs dataset to drop semantic duplicates.

### Phase 3: Business Intelligence & Visualization (Power BI)
Moved beyond flat-file reporting by utilizing enterprise-grade data modeling and DAX methodologies.

* **The Star Schema:** Architected a relational data model bridging three distinct fact tables (Layoffs, Salaries, Jobs) using a custom-built, continuous `Dim_Date` calendar table and a unified `Dim_Industry` dimension.
* **Time Intelligence:** Engineered custom DAX measures (using `SAMEPERIODLASTYEAR` and `DIVIDE` error-handling) to calculate Year-Over-Year salary growth and Month-Over-Month hiring momentum.
* **Statistical Guardrails:** Built P25 and P75 salary band calculations combined with global Median baselines to ensure extreme executive compensation outliers did not skew visual market realities.

---

## 📸 Dashboard Previews

### Page 1: Market Overview & Geographic Impact
<img width="1438" height="802" alt="image" src="https://github.com/user-attachments/assets/4aa0255a-4374-4820-9ac1-1aa0c1e1549c" /> 
Tracks macroeconomic layoff volume over time alongside geographic hotspots and total human impact.

### Page 2: Salary Benchmarking & Experience Distribution
<img width="1437" height="802" alt="image" src="https://github.com/user-attachments/assets/dd1a17ca-4f95-483f-bbcf-dc3ab98b9856" /> 
Maps the P25–P75 compensation bands for top roles, cross-filtered by a custom Remote Work % parameter.

### Page 3: Strategic Risk Matrix
<img width="1437" height="802" alt="image" src="https://github.com/user-attachments/assets/43ff32dc-ab99-47bb-808d-01215031d742" />
A dynamic scatter plot and risk matrix plotting Role Demand against Compensation Cost to inform hiring strategies.

---

## 📂 Repository Navigation

```text
├── data/                               # Cleaned, foundation datasets & master Data Dictionary
│   ├── Jobs_Clean.csv
│   ├── Layoffs_Clean.csv
│   ├── Salaries_Clean.csv
│   └── data_dictionary.md
├── script/                             # Engineering workbooks and SQL source code
│   ├── Data_Engineering_and_Financial_Model.xlsx
│   ├── database_setup_and_ddl_01.sql   # Table creation and schema definitions
│   ├── business_intelligence_queries_02.sql    # CTEs, Window Functions, and aggregations
│   └── DAX_Measures.md                 # Time Intelligence and statistical distribution logic
├── outputs/                            # CSV results generated by SQL scripts
│   ├── Q1a_Industry_Volatility_Metrics.csv
│   ├── Q1b_Rolling_3M_Layoff_Momentum.csv
│   ├── Q2_Funding_Stage_Risk_Profile.csv
│   ├── Q3_Salary_Percentile_Bands.csv
│   └── Q4_YoY_Compensation_Growth.csv
├── dashboard/                          # Presentation layer
│   ├── Tech_Market_Layoffs_Intelligence.pbix             # Power BI file
│   └── Tech_Market_Layoffs_Intelligence_Presentation.pdf # Static PDF export
└── README.md
```

*Created by Shubham Singh | [LinkedIn Profile](https://www.linkedin.com/in/shubham-singh-819967266)*
