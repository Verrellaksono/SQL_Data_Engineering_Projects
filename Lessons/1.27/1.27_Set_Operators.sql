-- Union & Union ALL
SELECT UNNEST([1, 1, 1, 2])
UNION ALL
SELECT UNNEST([1, 1, 3]);

-- Intersect & Intersect ALL
SELECT UNNEST([1, 1, 1, 2])
INTERSECT ALL
SELECT UNNEST([1, 1, 3]);

-- Except & Except ALL
SELECT UNNEST([1, 1, 1, 2])
EXCEPT
SELECT UNNEST([1, 1, 3]);

CREATE TEMP TABLE jobs_2023 AS
SELECT * EXCLUDE (job_id,job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id,job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023
UNION
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*) 
FROM jobs_2024;

SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;