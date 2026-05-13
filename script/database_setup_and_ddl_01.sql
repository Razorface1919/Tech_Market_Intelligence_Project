-- ==============================================================================
-- Script 1: Database Setup & Data Definition Language (DDL)
-- Description: Final schemas for Jobs, Layoffs, and Salaries tables.
-- ==============================================================================

-- 1. Salaries Table (Uses Surrogate Key)
CREATE TABLE salaries_clean (
    id SERIAL PRIMARY KEY,
    work_year INT,
    experience_level VARCHAR(50),
    employment_type VARCHAR(50),
    job_title VARCHAR(150),
    salary_in_usd INT,
    employee_residence VARCHAR(100),
    remote_ratio INT,
    company_location VARCHAR(100),
    company_size VARCHAR(50)
);

-- 2. Jobs Table (Aligned to 17 columns, uses Natural Key)
CREATE TABLE jobs_clean (
    job_id BIGINT PRIMARY KEY,               
    company_name VARCHAR(255),               
    title VARCHAR(255),                      
    max_salary NUMERIC(15,2),                
    pay_period VARCHAR(50),                  
    location VARCHAR(255),                   
    views INTEGER,                           
    med_salary NUMERIC(15,2),                
    min_salary NUMERIC(15,2),                
    formatted_work_type VARCHAR(100),        
    applies INTEGER,                         
    remote_allowed VARCHAR(50),              
    formatted_experience_level VARCHAR(100), 
    listed_time VARCHAR(50),                 
    currency VARCHAR(10),                    
    compensation_type VARCHAR(50),           
    normalized_salary NUMERIC(15,2)          
);

-- 3. Layoffs Table (Aligned sequence to CSV, uses Surrogate Key)
CREATE TABLE layoffs_clean (
    id SERIAL PRIMARY KEY,              
    company VARCHAR(150),               
    location VARCHAR(100),              
    total_laid_off INTEGER,             
    date VARCHAR(10),                   
    year INTEGER,                       
    percentage_laid_off NUMERIC(10,4),  
    severity_tier VARCHAR(50),          
    severity_score_ln NUMERIC(10,4),    
    industry VARCHAR(100),              
    stage VARCHAR(100),                 
    funds_raised NUMERIC(15,2),         
    country VARCHAR(100)                
);