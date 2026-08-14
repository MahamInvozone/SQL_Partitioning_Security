-- ============================================================
-- SQL FUNDAMENTALS - EMPLOYEE DATASET
-- Project: Medallion Architecture
-- Data Source: Silver Layer - cleaned_data.parquet
-- Tool: DuckDB
--
-- Topics Covered:
-- 1. SELECT
-- 2. WHERE
-- 3. ORDER BY
-- 4. COUNT()
-- 5. GROUP BY
-- 6. AVG()
-- 7. SUM()
-- 8. MIN() / MAX()
-- 9. HAVING
-- 10. Subqueries
-- ============================================================


-- ============================================================
-- 1. SELECT
-- ============================================================
-- SELECT is used to retrieve specific columns from a dataset.
--
-- Syntax:
-- SELECT column1, column2
-- FROM table;
--
-- Here we select employee ID, name, department and job title.

SELECT
    employee_id,
    full_name,
    department,
    job_title
FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 2. WHERE - FILTERING
-- ============================================================
-- WHERE filters individual rows based on a condition.
--
-- Example:
-- Get employees who belong to the IT department.

SELECT
    employee_id,
    full_name,
    department,
    job_title
FROM 'data/silver/cleaned_data.parquet'
WHERE department = 'IT'
LIMIT 10;


-- ------------------------------------------------------------
-- WHERE with AND
-- ------------------------------------------------------------
-- AND means BOTH conditions must be true.
--
-- Example:
-- Employees who are in IT AND have Active employment status.

SELECT
    employee_id,
    full_name,
    department,
    employment_status
FROM 'data/silver/cleaned_data.parquet'
WHERE department = 'IT'
  AND employment_status = 'Active'
LIMIT 10;


-- ------------------------------------------------------------
-- WHERE with OR
-- ------------------------------------------------------------
-- OR means at least ONE condition must be true.
--
-- Example:
-- Employees from either IT or Engineering.

SELECT
    employee_id,
    full_name,
    department
FROM 'data/silver/cleaned_data.parquet'
WHERE department = 'IT'
   OR department = 'Engineering'
LIMIT 10;


-- ------------------------------------------------------------
-- WHERE with numeric values
-- ------------------------------------------------------------
-- Some numeric-looking columns in our dataset are stored as VARCHAR.
-- TRY_CAST() converts them to numeric values safely.
--
-- TRY_CAST() returns NULL instead of throwing an error
-- when a value cannot be converted.

SELECT
    employee_id,
    full_name,
    age
FROM 'data/silver/cleaned_data.parquet'
WHERE TRY_CAST(age AS INTEGER) > 30
LIMIT 10;


-- ============================================================
-- 3. ORDER BY - SORTING
-- ============================================================
-- ORDER BY sorts the result.
--
-- ASC  = ascending (small → large / A → Z)
-- DESC = descending (large → small / Z → A)
--
-- Example:
-- Sort employees by salary from highest to lowest.

SELECT
    employee_id,
    full_name,
    salary
FROM 'data/silver/cleaned_data.parquet'
ORDER BY TRY_CAST(salary AS DOUBLE) DESC
LIMIT 10;


-- ------------------------------------------------------------
-- ORDER BY with text
-- ------------------------------------------------------------
-- Sort employees alphabetically by name.

SELECT
    employee_id,
    full_name,
    department
FROM 'data/silver/cleaned_data.parquet'
ORDER BY full_name ASC
LIMIT 10;


-- ============================================================
-- 4. COUNT()
-- ============================================================
-- COUNT() is an aggregate function.
--
-- COUNT(*) counts the total number of rows.

SELECT
    COUNT(*) AS total_employees
FROM 'data/silver/cleaned_data.parquet';


-- ============================================================
-- 5. GROUP BY
-- ============================================================
-- GROUP BY creates groups based on one or more columns.
--
-- Example:
-- Group employees by department and count employees in each
-- department.

SELECT
    department,
    COUNT(*) AS employee_count
FROM 'data/silver/cleaned_data.parquet'
GROUP BY department
ORDER BY employee_count DESC;


-- ============================================================
-- 6. AVG()
-- ============================================================
-- AVG() calculates the average value.
--
-- Example:
-- Calculate the average salary for each department.
--
-- TRY_CAST() is required because salary is stored as VARCHAR.

SELECT
    department,
    ROUND(
        AVG(TRY_CAST(salary AS DOUBLE)),
        2
    ) AS average_salary
FROM 'data/silver/cleaned_data.parquet'
GROUP BY department
ORDER BY average_salary DESC;


-- ============================================================
-- 7. SUM()
-- ============================================================
-- SUM() calculates the total of numeric values.
--
-- Example:
-- Calculate the total salary paid by each department.

SELECT
    department,
    ROUND(
        SUM(TRY_CAST(salary AS DOUBLE)),
        2
    ) AS total_salary
FROM 'data/silver/cleaned_data.parquet'
GROUP BY department
ORDER BY total_salary DESC;


-- ============================================================
-- 8. MIN() AND MAX()
-- ============================================================
-- MIN() returns the smallest value.
-- MAX() returns the largest value.
--
-- Example:
-- Find minimum and maximum salary in each department.

SELECT
    department,
    MIN(TRY_CAST(salary AS DOUBLE)) AS minimum_salary,
    MAX(TRY_CAST(salary AS DOUBLE)) AS maximum_salary
FROM 'data/silver/cleaned_data.parquet'
GROUP BY department
ORDER BY department;


-- ============================================================
-- 9. HAVING
-- ============================================================
-- HAVING filters GROUPS after GROUP BY.
--
-- IMPORTANT DIFFERENCE:
--
-- WHERE  → filters individual rows
-- HAVING → filters aggregated groups
--
-- Example:
-- Show only departments having more than 100 employees.

SELECT
    department,
    COUNT(*) AS employee_count
FROM 'data/silver/cleaned_data.parquet'
GROUP BY department
HAVING COUNT(*) > 100
ORDER BY employee_count DESC;


-- ============================================================
-- 10. SUBQUERIES
-- ============================================================
-- A subquery is a query inside another query.
--
-- The inner query executes first and provides a value/result
-- to the outer query.
--
-- Example:
-- Find employees whose salary is higher than the overall
-- average salary.


SELECT
    employee_id,
    full_name,
    department,
    salary
FROM 'data/silver/cleaned_data.parquet'
WHERE TRY_CAST(salary AS DOUBLE) > (

    -- INNER QUERY / SUBQUERY
    SELECT
        AVG(TRY_CAST(salary AS DOUBLE))
    FROM 'data/silver/cleaned_data.parquet'

)
ORDER BY TRY_CAST(salary AS DOUBLE) DESC
LIMIT 10;


-- ============================================================
-- SQL CLAUSE ORDER - IMPORTANT FOR REVISION
-- ============================================================
--
-- A typical SQL query follows this logical order:
--
-- FROM
--   ↓
-- WHERE
--   ↓
-- GROUP BY
--   ↓
-- HAVING
--   ↓
-- SELECT
--   ↓
-- ORDER BY
--   ↓
-- LIMIT
--
-- Example:
--
-- SELECT department, COUNT(*)
-- FROM employees
-- WHERE employment_status = 'Active'
-- GROUP BY department
-- HAVING COUNT(*) > 50
-- ORDER BY COUNT(*) DESC
-- LIMIT 5;
--
-- ============================================================