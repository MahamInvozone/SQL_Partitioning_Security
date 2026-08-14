-- ============================================================
-- WINDOW FUNCTIONS
-- Project: Medallion Architecture
-- Tool: DuckDB
--
-- Window functions perform calculations across related rows
-- while keeping the original rows.
--
-- Basic syntax:
--
-- FUNCTION() OVER (
--     PARTITION BY column
--     ORDER BY column
-- )
--
-- Topics:
-- 1. ROW_NUMBER()
-- 2. RANK()
-- 3. DENSE_RANK()
-- 4. LAG()
-- 5. LEAD()
-- 6. SUM() OVER()
-- 7. AVG() OVER()
-- ============================================================


-- ============================================================
-- 1. ROW_NUMBER()
-- ============================================================
-- ROW_NUMBER() gives each row a unique sequential number.
--
-- Here employees are numbered according to salary,
-- highest salary first.

SELECT
    employee_id,
    full_name,
    department,
    salary,

    ROW_NUMBER() OVER (
        ORDER BY TRY_CAST(salary AS DOUBLE) DESC
    ) AS salary_position

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 2. ROW_NUMBER() WITH PARTITION BY
-- ============================================================
-- PARTITION BY divides the data into groups.
--
-- Here numbering starts again from 1 for every department.
--
-- Example:
--
-- IT:
-- 1
-- 2
-- 3
--
-- Sales:
-- 1
-- 2
-- 3

SELECT
    employee_id,
    full_name,
    department,
    salary,

    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY TRY_CAST(salary AS DOUBLE) DESC
    ) AS department_rank

FROM 'data/silver/cleaned_data.parquet'
LIMIT 20;


-- ============================================================
-- 3. RANK()
-- ============================================================
-- RANK() assigns the same rank to tied values.
--
-- Important:
-- RANK() leaves gaps after ties.
--
-- Example:
--
-- Salary      Rank
-- 100000       1
-- 100000       1
-- 90000        3
--
-- Notice that rank 2 is skipped.

SELECT
    employee_id,
    full_name,
    department,
    salary,

    RANK() OVER (
        ORDER BY TRY_CAST(salary AS DOUBLE) DESC
    ) AS salary_rank

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 4. DENSE_RANK()
-- ============================================================
-- DENSE_RANK() also gives the same rank to tied values,
-- but it does NOT leave gaps.
--
-- Example:
--
-- Salary      Rank
-- 100000       1
-- 100000       1
-- 90000        2
--
-- Difference:
--
-- RANK()       → 1, 1, 3
-- DENSE_RANK() → 1, 1, 2

SELECT
    employee_id,
    full_name,
    department,
    salary,

    DENSE_RANK() OVER (
        ORDER BY TRY_CAST(salary AS DOUBLE) DESC
    ) AS salary_rank

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 5. LAG()
-- ============================================================
-- LAG() accesses a value from a PREVIOUS row.
--
-- It is useful for comparing the current row with
-- a previous row.
--
-- Here we order employees by salary and look at the
-- previous employee's salary.

SELECT
    employee_id,
    full_name,
    salary,

    LAG(TRY_CAST(salary AS DOUBLE)) OVER (
        ORDER BY TRY_CAST(salary AS DOUBLE)
    ) AS previous_salary

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 6. LEAD()
-- ============================================================
-- LEAD() accesses a value from a FOLLOWING row.
--
-- It is the opposite of LAG().

SELECT
    employee_id,
    full_name,
    salary,

    LEAD(TRY_CAST(salary AS DOUBLE)) OVER (
        ORDER BY TRY_CAST(salary AS DOUBLE)
    ) AS next_salary

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 7. SUM() OVER()
-- ============================================================
-- SUM() can be used as a window function.
--
-- Unlike GROUP BY:
--
-- GROUP BY → combines rows
--
-- SUM() OVER() → keeps every employee row
--                and adds a calculated value.
--
-- Here we calculate the total salary for each department
-- while keeping individual employees.

SELECT
    employee_id,
    full_name,
    department,
    salary,

    SUM(TRY_CAST(salary AS DOUBLE)) OVER (
        PARTITION BY department
    ) AS department_total_salary

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 8. AVG() OVER()
-- ============================================================
-- Calculate the average salary of each department while
-- keeping every employee row.

SELECT
    employee_id,
    full_name,
    department,
    salary,

    ROUND(
        AVG(TRY_CAST(salary AS DOUBLE)) OVER (
            PARTITION BY department
        ),
        2
    ) AS department_average_salary

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- 9. EMPLOYEE SALARY VS DEPARTMENT AVERAGE
-- ============================================================
-- Window functions can be used to compare an employee's
-- salary with their department's average salary.

SELECT
    employee_id,
    full_name,
    department,
    salary,

    ROUND(
        AVG(TRY_CAST(salary AS DOUBLE)) OVER (
            PARTITION BY department
        ),
        2
    ) AS department_average_salary,

    ROUND(
        TRY_CAST(salary AS DOUBLE)
        -
        AVG(TRY_CAST(salary AS DOUBLE)) OVER (
            PARTITION BY department
        ),
        2
    ) AS difference_from_average

FROM 'data/silver/cleaned_data.parquet'
LIMIT 10;


-- ============================================================
-- WINDOW FUNCTION SUMMARY
-- ============================================================
--
-- ROW_NUMBER()
-- → Gives every row a unique number.
--
-- RANK()
-- → Same rank for ties, gaps after ties.
--
-- DENSE_RANK()
-- → Same rank for ties, no gaps.
--
-- LAG()
-- → Access previous row.
--
-- LEAD()
-- → Access next row.
--
-- SUM() OVER()
-- → Running/partitioned totals while keeping rows.
--
-- AVG() OVER()
-- → Average across a window while keeping rows.
--
-- PARTITION BY
-- → Divides rows into groups for the window calculation.
--
-- ORDER BY inside OVER()
-- → Defines the order used by the window function.
--
-- ============================================================