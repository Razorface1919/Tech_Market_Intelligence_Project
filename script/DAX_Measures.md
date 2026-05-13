# Tech Layoffs & Compensation Intelligence: Core DAX Measures

This document outlines the core DAX logic engineered for the Power BI data model. The measures are categorized by business function, demonstrating data modeling, percentile distribution, and time intelligence capabilities.

---

## 1. Data Modeling & Dimensionality

### Date Dimension (Dim_Date)
**Business Problem Solved:** Creates a continuous, relationship-ready calendar table essential for accurate Time Intelligence calculations (MoM, YoY) across all fact tables.

```dax
Dim_Date = 
VAR MinYear = YEAR ( MINX ( FILTER ( Layoffs_Clean, YEAR ( Layoffs_Clean[date] ) > 2000 ), Layoffs_Clean[date] ) )
VAR MaxYear = YEAR ( MAXX ( FILTER ( Layoffs_Clean, YEAR ( Layoffs_Clean[date] ) > 2000 ), Layoffs_Clean[date] ) )
RETURN
ADDCOLUMNS (
    CALENDAR ( DATE ( MinYear, 1, 1 ), DATE ( MaxYear, 12, 31 ) ),
    "Year", YEAR ( [Date] ), -- Extracts the 4-digit year
    "Quarter", "Q" & FORMAT ( [Date], "Q" ),
    "MonthNum", MONTH ( [Date] ), -- Extracts the month number (1-12) for sorting
    "MonthName", FORMAT ( [Date], "MMMM" ), -- Extracts full month name (January)
    "MonthShort", FORMAT ( [Date], "MMM" ), -- Extracts short month name (Jan)
    "YearMonthNum", INT ( FORMAT ( [Date], "YYYYMM" ) ), -- Creates numerical key for chronological sorting
    "Weekday", WEEKDAY ( [Date], 2 ), -- Assigns a number to the day (1 = Monday)
    "IsWeekend", IF ( WEEKDAY ( [Date], 2 ) > 5, "Weekend", "Weekday" ) -- Flags weekends


## 2. Compensation & Salary Distribution Metrics

### Median USD Salary
**Business Problem Solved:** Establishes the foundational baseline for compensation, using the median to ensure extreme outlier salaries do not skew the dataset.

```dax
Median USD Salary = 
MEDIAN ( Salaries_Clean[salary_in_usd] )

### Average USD Salary
**Business Problem Solved:** Calculates the mean salary for high-level variance comparison against the median.

```dax
Average USD Salary = 
AVERAGE ( Salaries_Clean[salary_in_usd] )

### Salary P25 (25th Percentile)
**Business Problem Solved:** Identifies the lower boundary of the market rate to help visualize the baseline salary band for entry-level or lower-tier compensation.

```dax
Salary P25 = 
PERCENTILE.INC ( Salaries_Clean[salary_in_usd], 0.25 )

### Salary P75 (75th Percentile)
**Business Problem Solved:** Identifies the upper boundary of the market rate to visualize the premium salary band for senior-level and highly competitive roles.

```dax
Salary P75 = 
PERCENTILE.INC ( Salaries_Clean[salary_in_usd], 0.75 )


## 3. Layoff Impact & Risk Metrics

### Total People Laid Off
**Business Problem Solved:** Aggregates the total human impact of workforce reductions across the filtered dimensions.

```dax
Total People Laid Off = 
SUM ( Layoffs_Clean[total_laid_off] )

### Total Layoff Events
**Business Problem Solved:** Counts the distinct occurrences of layoffs to measure the frequency of market volatility.

```dax
Total Layoff Events = 
COUNTROWS ( Layoffs_Clean )

### Companies Affected
**Business Problem Solved:** Calculates the distinct count of organizations executing layoffs to measure how widespread the industry impact is.

```dax
Companies Affected = 
DISTINCTCOUNT ( Layoffs_Clean[company] )

### Avg % Laid Off
**Business Problem Solved:** Calculates the average severity of the layoffs relative to total company headcount.

```dax
Avg % Laid Off = 
AVERAGE ( Layoffs_Clean[percentage_laid_off] )


## 4. Market Demand & Time Intelligence

### Total Jobs Listed
**Business Problem Solved:** Quantifies the overall market demand and hiring volume for specific roles.

```dax
Total Jobs Listed = 
DISTINCTCOUNT ( Jobs_Clean[job_id] )

### YoY Median Salary Growth %
**Business Problem Solved:** Uses Time Intelligence to calculate Year-Over-Year salary fluctuations, safely handling blank data periods to prevent visual errors.

```dax
YoY Median Salary Growth % = 
VAR CurrentSalary = [Median USD Salary] -- Calling the measure we built in Phase 3.2
VAR PrevYearSalary = 
    CALCULATE (
        [Median USD Salary],
        SAMEPERIODLASTYEAR ( Dim_Date[Date] )
    )
RETURN 
    DIVIDE ( CurrentSalary - PrevYearSalary, PrevYearSalary, 0 )DISTINCTCOUNT ( Jobs_Clean[job_id] )

### MoM Job Listings Change %
**Business Problem Solved:** Tracks the short-term hiring momentum by calculating the Month-Over-Month variance in active job listings.

```dax
MoM Job Listings Change % = 
VAR CurrentMonth = [Total Jobs Listed]
VAR PrevMonth = 
    CALCULATE (
        [Total Jobs Listed],
        DATEADD ( Dim_Date[Date], -1, MONTH )
    )
RETURN 
    DIVIDE ( CurrentMonth - PrevMonth, PrevMonth, 0 )





