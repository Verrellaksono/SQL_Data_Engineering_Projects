SELECT LENGTH('SQL');

SELECT LOWER('SQL');
SELECT UPPER('sql');

SELECT LEFT('SQL', 2);
SELECT RIGHT('SQL', 2);
SELECT SUBSTRING('SQL', 2, 2);

SELECT CONCAT('SQL', '-', 'Functions');
SELECT 'SQL' || '-' || 'Functions';

SELECT 'SQL';
SELECT TRIM('   SQL  ');

SELECT REPLACE('SQL', 'Q', '_');
SELECT REGEXP_REPLACE('data@example.com', '^.*(@)', '\1');


WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT 
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category,
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;


-- NULLIF
SELECT NULLIF(10, 20);

SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL 
    OR salary_year_avg IS NOT NULL
LIMIT 10;

-- COALESCE
SELECT COALESCE(NULL, NULL, 2);

SELECT
    salary_year_avg,
    salary_hour_avg,
    coalesce(salary_year_avg, salary_hour_avg*2080)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL 
    OR salary_year_avg IS NOT NULL
LIMIT 10;

-- Final Example - Simplify with Coalesce
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) as standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150_000 THEN 'Mid'
        ELSE 'High'
    END as salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;