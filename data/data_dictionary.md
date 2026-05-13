# Data Dictionary: Tech Market Intelligence (2020–2024)

This document defines the schema and engineered features for the three core datasets feeding the analytical SQL database and Power BI dashboard. All data has been pre-processed, scrubbed for duplicates, normalized, and engineered via Excel prior to database ingestion.

## 1. Layoffs_Clean.csv
Tracks global technology company layoff events, funding stages, and severity metrics.

* **company:** Name of the organization.
* **location:** Primary metropolitan area of the layoff event.
* **total_laid_off:** Total number of employees terminated. (Nulls strictly preserved).
* **date_formatted:** Standardized date of the event in `YYYY-MM` format (converted from raw epoch/regional strings).
* **percentage_laid_off:** The percentage of the total workforce terminated, expressed as a decimal.
* **industry:** Categorical sector of the company (e.g., Finance, Healthcare, Crypto).
* **stage:** Funding stage at the time of the event (e.g., Series A, Post-IPO).
* **funds_raised:** Total capital raised by the company in millions (USD).
* **country:** Nation where the layoff occurred.
* **severity_tier:** **[Engineered Feature]** A categorical metric (1-Low to 4-Critical) derived from nested logical conditions evaluating both layoff volume and percentage.
* **severity_score_ln:** **[Engineered Feature]** A continuous mathematical feature utilizing logarithmic scaling `percentage * LN(total_laid_off + 1)` to normalize extreme outliers and create a smoothed severity gradient.
* **year:** **[Engineered Feature]** Pre-calculated 4-digit integer extracted for optimized OLAP time-series querying and Power BI slicer performance.

## 2. Salaries_Clean.csv
Aggregates global compensation data for data science and analytics roles.

* **work_year:** The year the salary was paid.
* **experience_level:** Categorical seniority (EN = Entry, MI = Mid, SE = Senior, EX = Executive).
* **employment_type:** Type of employment (FT = Full-Time, PT = Part-Time, CT = Contract, FL = Freelance).
* **job_title:** Standardized role designation (e.g., Data Scientist, Data Engineer).
* **salary_in_usd:** Standardized compensation converted entirely to US Dollars for accurate geographic baseline comparisons.
* **employee_residence:** ISO 3166 country code of the employee's primary residence.
* **remote_ratio:** Percentage of remote work permitted (0 = On-site, 50 = Hybrid, 100 = Fully Remote).
* **company_location:** ISO 3166 country code of the employer's headquarters.
* **company_size:** Categorical headcount bracket (S = Small, M = Medium, L = Large).

## 3. Jobs_Clean.csv
Current job market intelligence detailing active postings, skill requirements, and compensation bandwidths. 
*(Note: Schema normalized to remove redundant time and casing variables prior to database ingestion).*

* **company_name:** Name of the hiring organization.
* **title:** The specific job title advertised.
* **max_salary:** The upper bound of the advertised compensation.
* **pay_period:** The frequency of the compensation (e.g., YEARLY, HOURLY).
* **location:** City or region of the job posting.
* **views:** Total applicant views on the posting.
* **med_salary:** The median advertised compensation.
* **min_salary:** The lower bound of the advertised compensation.
* **formatted_work_type:** Normalized casing (Title Case) indicating employment type (e.g., Full-time, Contract).
* **applies:** Total number of submitted applications.
* **remote_allowed:** Indicates if the position permits remote work (Nulls mapped to 'Unknown').
* **formatted_experience_level:** The required seniority for the role.
* **skills_desc:** Text array/description of required technical and soft skills.
* **listed_time_formatted:** Standardized posting date in `YYYY-MM` format.
* **currency:** The base currency of the job posting.
* **compensation_type:** Categorizes the pay structure (e.g., BASE_SALARY).
* **normalized_salary:** An annualized, standardized USD calculation of the compensation for accurate market benchmarking.