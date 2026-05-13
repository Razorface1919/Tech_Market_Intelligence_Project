-- ==============================================================================
-- Script 2: Business Intelligence Queries
-- Description: Final analytical queries for the Layoffs & Job Market project.
-- ==============================================================================

-- ==============================================================================
-- Q1a: Industry Volatility Analysis
-- ==============================================================================
WITH layoff_metrics AS (
    SELECT industry, SUM(total_laid_off) AS total_layoffs
    FROM layoffs_clean
    WHERE year IN (2023, 2024) AND industry IS NOT NULL AND industry != 'Unknown'
    GROUP BY industry
),
job_metrics AS (
    SELECT l.industry, COUNT(DISTINCT j.job_id) AS total_job_postings
    FROM jobs_clean j
    INNER JOIN layoffs_clean l ON j.company_name = l.company
    WHERE j.listed_time LIKE '2023%' OR j.listed_time LIKE '2024%'
    GROUP BY l.industry
)
SELECT 
    COALESCE(lm.industry, jm.industry) AS industry_name,
    COALESCE(lm.total_layoffs, 0) AS total_layoffs,
    COALESCE(jm.total_job_postings, 0) AS hiring_activity,
    ROUND(COALESCE(jm.total_job_postings, 0)::NUMERIC / NULLIF(COALESCE(lm.total_layoffs, 0), 0), 4) AS hiring_to_layoff_ratio
FROM layoff_metrics lm
FULL OUTER JOIN job_metrics jm ON lm.industry = jm.industry
ORDER BY total_layoffs DESC;

-- ==============================================================================
-- Q1b: Rolling 3-Month Layoff Trend
-- ==============================================================================
SELECT
    date AS layoff_month,
    industry,
    SUM(total_laid_off) AS monthly_layoffs,
    ROUND(AVG(SUM(total_laid_off)) OVER (
        PARTITION BY industry ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 0) AS rolling_3m_avg
FROM layoffs_clean
WHERE date IS NOT NULL AND industry IS NOT NULL AND industry != 'Unknown'
GROUP BY date, industry
ORDER BY industry, date;

-- ==============================================================================
-- Q2: Company Stage Risk Profile (Percentage-Based)
-- ==============================================================================
SELECT
    stage AS funding_stage,
    COUNT(DISTINCT company) AS total_companies_affected,
    SUM(total_laid_off) AS total_jobs_lost,
    ROUND(AVG(percentage_laid_off), 4) AS avg_pct_laid_off,
    RANK() OVER (ORDER BY AVG(percentage_laid_off) DESC) AS risk_rank
FROM layoffs_clean
WHERE stage IS NOT NULL AND stage != 'Unknown' AND percentage_laid_off IS NOT NULL
GROUP BY stage
ORDER BY risk_rank ASC;

-- ==============================================================================
-- Q3: Salary Percentile Bands by Job Title
-- ==============================================================================
SELECT
    job_title,
    COUNT(*) AS total_records,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary_in_usd)) AS p25_salary,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary_in_usd)) AS median_salary,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary_in_usd)) AS p75_salary,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salary_in_usd)) AS p90_salary
FROM salaries_clean
WHERE salary_in_usd IS NOT NULL
GROUP BY job_title
HAVING COUNT(*) >= 10
ORDER BY median_salary DESC
LIMIT 20;

-- ==============================================================================
-- Q4: YoY Compensation Growth by Experience & Remote Ratio 
-- ==============================================================================
WITH yearly_metrics AS (
    SELECT
        experience_level,
        remote_ratio,
        work_year,
        (PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary_in_usd))::NUMERIC AS median_salary,
        COUNT(*) AS sample_size
    FROM salaries_clean
    WHERE salary_in_usd IS NOT NULL
    GROUP BY experience_level, remote_ratio, work_year
    HAVING COUNT(*) >= 5 
)
SELECT 
    experience_level,
    remote_ratio,
    work_year,
    median_salary,
    LAG(median_salary) OVER (PARTITION BY experience_level, remote_ratio ORDER BY work_year) AS prev_year_salary,
    ROUND(100.0 * (median_salary - LAG(median_salary) OVER (PARTITION BY experience_level, remote_ratio ORDER BY work_year)) 
    / NULLIF(LAG(median_salary) OVER (PARTITION BY experience_level, remote_ratio ORDER BY work_year), 0), 1) AS yoy_growth_pct
FROM yearly_metrics
ORDER BY work_year DESC, median_salary DESC;