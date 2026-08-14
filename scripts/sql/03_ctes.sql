-- ============================================================
-- CTEs (COMMON TABLE EXPRESSIONS)
-- Project: Medallion Architecture
-- Tool: DuckDB
--
-- A CTE creates a temporary named result that can be
-- referenced by the main query.
--
-- Basic syntax:
--
-- WITH cte_name AS (
--     SELECT ...
-- )
-- SELECT ...
-- FROM cte_name;
-- ============================================================


-- ============================================================
-- 1. BASIC CTE
-- ============================================================
-- Find employees whose salary is greater than 80,000.
--
-- The CTE first creates a temporary result called
-- high_salary_employees.
--
-- The main query then reads from that result.

WITH high_salary_employees AS (

    SELECT
        employee_id,
        full_name,
        department,
        salary
    FROM 'data/silver/cleaned_data.parquet'
    WHERE TRY_CAST(salary AS DOUBLE) > 80000

)

SELECT *
FROM high_salary_employees
LIMIT 10;


-- ============================================================
-- 2. CTE + AGGREGATION
-- ============================================================
-- Calculate the average salary for each department,
-- then show departments whose average salary is above 70,000.

WITH department_salary AS (

    SELECT
        department,
        ROUND(
            AVG(TRY_CAST(salary AS DOUBLE)),
            2
        ) AS average_salary
    FROM 'data/silver/cleaned_data.parquet'
    GROUP BY department

)

SELECT
    department,
    average_salary
FROM department_salary
WHERE average_salary > 70000
ORDER BY average_salary DESC;


-- ============================================================
-- 3. CTE + GROUP BY + HAVING
-- ============================================================
-- Count employees in each department and keep only
-- departments with more than 100 employees.

WITH department_counts AS (

    SELECT
        department,
        COUNT(*) AS employee_count
    FROM 'data/silver/cleaned_data.parquet'
    GROUP BY department

)

SELECT
    department,
    employee_count
FROM department_counts
WHERE employee_count > 100
ORDER BY employee_count DESC;


-- ============================================================
-- 4. MULTIPLE CTEs
-- ============================================================
-- Multiple CTEs can be created using commas.
--
-- First CTE:
-- Calculate employee count per department.
--
-- Second CTE:
-- Calculate average salary per department.
--
-- Final query:
-- Combine both results.

WITH department_counts AS (

    SELECT
        department,
        COUNT(*) AS employee_count
    FROM 'data/silver/cleaned_data.parquet'
    GROUP BY department

),

department_salary AS (

    SELECT
        department,
        ROUND(
            AVG(TRY_CAST(salary AS DOUBLE)),
            2
        ) AS average_salary
    FROM 'data/silver/cleaned_data.parquet'
    GROUP BY department

)

SELECT
    dc.department,
    dc.employee_count,
    ds.average_salary
FROM department_counts AS dc
JOIN department_salary AS ds
    ON dc.department = ds.department
ORDER BY ds.average_salary DESC;


-- ============================================================
-- 5. CTE + JOIN
-- ============================================================
-- First create a filtered employee dataset using a CTE.
-- Then join it with the benefits table.

WITH active_employees AS (

    SELECT
        employee_id,
        full_name,
        department,
        employment_status
    FROM 'data/silver/cleaned_data.parquet'
    WHERE employment_status = 'Active'

)

SELECT
    e.employee_id,
    e.full_name,
    e.department,
    b.insurance_provider
FROM active_employees AS e
LEFT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- CTE VS SUBQUERY
-- ============================================================
--
-- SUBQUERY:
-- A query written inside another query.
--
-- CTE:
-- A named temporary result created using WITH.
--
-- CTEs are often easier to read and maintain when a query
-- becomes complex.
--
-- SUBQUERY:
--
-- SELECT *
-- FROM employees
-- WHERE salary > (
--     SELECT AVG(salary)
--     FROM employees
-- );
--
-- CTE:
--
-- WITH average_salary AS (
--     SELECT AVG(salary) AS avg_salary
--     FROM employees
-- )
-- SELECT *
-- FROM employees
-- WHERE salary > (SELECT avg_salary FROM average_salary);
--
-- ============================================================



WITH high_salary_employees AS (

    SELECT
        employee_id,
        full_name,
        department,
        salary
    FROM 'data/silver/cleaned_data.parquet'
    WHERE TRY_CAST(salary AS DOUBLE) > 80000

)

SELECT *
FROM high_salary_employees
LIMIT 10;WITH high_salary_employees AS (

    SELECT
        employee_id,
        full_name,
        department,
        salary
    FROM 'data/silver/cleaned_data.parquet'
    WHERE TRY_CAST(salary AS DOUBLE) > 80000

)

SELECT *
FROM high_salary_employees
LIMIT 10;WITH high_salary_employees AS (

    SELECT
        employee_id,
        full_name,
        department,
        salary
    FROM 'data/silver/cleaned_data.parquet'
    WHERE TRY_CAST(salary AS DOUBLE) > 80000

)

SELECT *
FROM high_salary_employees
LIMIT 10;