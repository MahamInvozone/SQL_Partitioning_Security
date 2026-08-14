-- ============================================================
-- SQL JOINS
-- Project: Medallion Architecture
-- Tool: DuckDB
--
-- Main table:
--   data/silver/cleaned_data.parquet
--
-- Second table:
--   data/silver/employee_benefits.parquet
--
-- Common key:
--   employee_id
--
-- Topics:
-- 1. INNER JOIN
-- 2. LEFT JOIN
-- 3. RIGHT JOIN
-- 4. FULL OUTER JOIN
-- 5. SELF JOIN
-- 6. CROSS JOIN
-- 7. MULTI-TABLE JOIN
-- ============================================================


-- ============================================================
-- 1. INNER JOIN
-- ============================================================
-- INNER JOIN returns only rows that have a matching value
-- in BOTH tables.
--
-- Concept:
--
-- employees              benefits
--     ● -------------------- ●
--          matching rows
--
-- Syntax:
--
-- SELECT ...
-- FROM table1
-- INNER JOIN table2
--     ON table1.key = table2.key;


SELECT
    e.employee_id,
    e.full_name,
    e.department,
    b.insurance_provider,
    b.account_type
FROM 'data/silver/cleaned_data.parquet' AS e
INNER JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- 2. LEFT JOIN
-- ============================================================
-- LEFT JOIN returns:
--
-- ALL rows from the LEFT table
-- + matching rows from the RIGHT table.
--
-- If there is no match in the right table,
-- the right-side columns become NULL.
--
-- Very commonly used when we want to keep the complete
-- dataset from the primary/left table.


SELECT
    e.employee_id,
    e.full_name,
    e.department,
    b.insurance_provider,
    b.account_type
FROM 'data/silver/cleaned_data.parquet' AS e
LEFT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- 3. RIGHT JOIN
-- ============================================================
-- RIGHT JOIN returns:
--
-- ALL rows from the RIGHT table
-- + matching rows from the LEFT table.
--
-- If there is no match in the left table,
-- the left-side columns become NULL.
--
-- RIGHT JOIN is essentially the opposite perspective
-- of LEFT JOIN.


SELECT
    e.employee_id,
    e.full_name,
    b.employee_id AS benefits_employee_id,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e
RIGHT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- 4. FULL OUTER JOIN
-- ============================================================
-- FULL OUTER JOIN returns:
--
-- ALL matching rows
-- + unmatched rows from the LEFT table
-- + unmatched rows from the RIGHT table.
--
-- Missing values on either side appear as NULL.
--
-- Concept:
--
-- LEFT ONLY + MATCHING + RIGHT ONLY


SELECT
    e.employee_id,
    e.full_name,
    b.employee_id AS benefits_employee_id,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e
FULL OUTER JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 20;


-- ============================================================
-- 5. SELF JOIN
-- ============================================================
-- A SELF JOIN joins a table with ITSELF.
--
-- This is useful for hierarchical relationships.
--
-- Example:
-- employee → manager
--
-- Our dataset contains manager_name rather than a manager_id,
-- so we can demonstrate a self join by matching manager_name
-- with another employee's full_name.
--
-- IMPORTANT:
-- Self joins use aliases so we can treat the same table
-- as two separate logical tables.
--
-- e  = employee
-- m  = manager


SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.manager_name,
    m.employee_id AS manager_employee_id
FROM 'data/silver/cleaned_data.parquet' AS e
LEFT JOIN 'data/silver/cleaned_data.parquet' AS m
    ON LOWER(TRIM(e.manager_name)) = LOWER(TRIM(m.full_name))
LIMIT 10;


-- ============================================================
-- 6. CROSS JOIN
-- ============================================================
-- CROSS JOIN creates every possible combination of rows
-- between two tables.
--
-- Example:
--
-- Table A = 3 rows
-- Table B = 2 rows
--
-- CROSS JOIN = 3 × 2 = 6 rows
--
-- WARNING:
-- CROSS JOIN can create a HUGE result for large datasets.
--
-- We use LIMIT here only for demonstration.


SELECT
    e.employee_id,
    e.department,
    b.account_type
FROM 'data/silver/cleaned_data.parquet' AS e
CROSS JOIN 'data/silver/employee_benefits.parquet' AS b
LIMIT 20;


-- ============================================================
-- 7. MULTI-TABLE JOIN
-- ============================================================
-- A multi-table join combines THREE OR MORE tables.
--
-- Example:
--
-- employees
--     ↓
-- benefits
--     ↓
-- department information
--
-- For now, we can demonstrate a multi-table join by using
-- the employee table more than once.
--
-- e  = employee
-- m  = manager
-- b  = benefits


SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.department,
    m.full_name AS manager_name,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e

LEFT JOIN 'data/silver/cleaned_data.parquet' AS m
    ON LOWER(TRIM(e.manager_name)) = LOWER(TRIM(m.full_name))

LEFT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id

LIMIT 10;


-- ============================================================
-- JOIN SUMMARY
-- ============================================================
--
-- INNER JOIN
-- → Only matching rows from both tables.
--
-- LEFT JOIN
-- → All rows from left + matching rows from right.
--
-- RIGHT JOIN
-- → All rows from right + matching rows from left.
--
-- FULL OUTER JOIN
-- → All rows from both tables.
--
-- SELF JOIN
-- → A table joined with itself.
--
-- CROSS JOIN
-- → Every possible combination of rows.
--
-- MULTI-TABLE JOIN
-- → Joining three or more tables.
--
-- ============================================================-- ============================================================
-- SQL JOINS
-- Project: Medallion Architecture
-- Tool: DuckDB
--
-- Main table:
--   data/silver/cleaned_data.parquet
--
-- Second table:
--   data/silver/employee_benefits.parquet
--
-- Common key:
--   employee_id
--
-- Topics:
-- 1. INNER JOIN
-- 2. LEFT JOIN
-- 3. RIGHT JOIN
-- 4. FULL OUTER JOIN
-- 5. SELF JOIN
-- 6. CROSS JOIN
-- 7. MULTI-TABLE JOIN
-- ============================================================


-- ============================================================
-- 1. INNER JOIN
-- ============================================================
-- INNER JOIN returns only rows that have a matching value
-- in BOTH tables.
--
-- Concept:
--
-- employees              benefits
--     ● -------------------- ●
--          matching rows
--
-- Syntax:
--
-- SELECT ...
-- FROM table1
-- INNER JOIN table2
--     ON table1.key = table2.key;


SELECT
    e.employee_id,
    e.full_name,
    e.department,
    b.insurance_provider,
    b.account_type
FROM 'data/silver/cleaned_data.parquet' AS e
INNER JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- 2. LEFT JOIN
-- ============================================================
-- LEFT JOIN returns:
--
-- ALL rows from the LEFT table
-- + matching rows from the RIGHT table.
--
-- If there is no match in the right table,
-- the right-side columns become NULL.
--
-- Very commonly used when we want to keep the complete
-- dataset from the primary/left table.


SELECT
    e.employee_id,
    e.full_name,
    e.department,
    b.insurance_provider,
    b.account_type
FROM 'data/silver/cleaned_data.parquet' AS e
LEFT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- 3. RIGHT JOIN
-- ============================================================
-- RIGHT JOIN returns:
--
-- ALL rows from the RIGHT table
-- + matching rows from the LEFT table.
--
-- If there is no match in the left table,
-- the left-side columns become NULL.
--
-- RIGHT JOIN is essentially the opposite perspective
-- of LEFT JOIN.


SELECT
    e.employee_id,
    e.full_name,
    b.employee_id AS benefits_employee_id,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e
RIGHT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;


-- ============================================================
-- 4. FULL OUTER JOIN
-- ============================================================
-- FULL OUTER JOIN returns:
--
-- ALL matching rows
-- + unmatched rows from the LEFT table
-- + unmatched rows from the RIGHT table.
--
-- Missing values on either side appear as NULL.
--
-- Concept:
--
-- LEFT ONLY + MATCHING + RIGHT ONLY


SELECT
    e.employee_id,
    e.full_name,
    b.employee_id AS benefits_employee_id,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e
FULL OUTER JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 20;


-- ============================================================
-- 5. SELF JOIN
-- ============================================================
-- A SELF JOIN joins a table with ITSELF.
--
-- This is useful for hierarchical relationships.
--
-- Example:
-- employee → manager
--
-- Our dataset contains manager_name rather than a manager_id,
-- so we can demonstrate a self join by matching manager_name
-- with another employee's full_name.
--
-- IMPORTANT:
-- Self joins use aliases so we can treat the same table
-- as two separate logical tables.
--
-- e  = employee
-- m  = manager


SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.manager_name,
    m.employee_id AS manager_employee_id
FROM 'data/silver/cleaned_data.parquet' AS e
LEFT JOIN 'data/silver/cleaned_data.parquet' AS m
    ON LOWER(TRIM(e.manager_name)) = LOWER(TRIM(m.full_name))
LIMIT 10;


-- ============================================================
-- 6. CROSS JOIN
-- ============================================================
-- CROSS JOIN creates every possible combination of rows
-- between two tables.
--
-- Example:
--
-- Table A = 3 rows
-- Table B = 2 rows
--
-- CROSS JOIN = 3 × 2 = 6 rows
--
-- WARNING:
-- CROSS JOIN can create a HUGE result for large datasets.
--
-- We use LIMIT here only for demonstration.


SELECT
    e.employee_id,
    e.department,
    b.account_type
FROM 'data/silver/cleaned_data.parquet' AS e
CROSS JOIN 'data/silver/employee_benefits.parquet' AS b
LIMIT 20;


-- ============================================================
-- 7. MULTI-TABLE JOIN
-- ============================================================
-- A multi-table join combines THREE OR MORE tables.
--
-- Example:
--
-- employees
--     ↓
-- benefits
--     ↓
-- department information
--
-- For now, we can demonstrate a multi-table join by using
-- the employee table more than once.
--
-- e  = employee
-- m  = manager
-- b  = benefits


SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.department,
    m.full_name AS manager_name,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e

LEFT JOIN 'data/silver/cleaned_data.parquet' AS m
    ON LOWER(TRIM(e.manager_name)) = LOWER(TRIM(m.full_name))

LEFT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id

LIMIT 10;


-- ============================================================
-- JOIN SUMMARY
-- ============================================================
--
-- INNER JOIN
-- → Only matching rows from both tables.
--
-- LEFT JOIN
-- → All rows from left + matching rows from right.
--
-- RIGHT JOIN
-- → All rows from right + matching rows from left.
--
-- FULL OUTER JOIN
-- → All rows from both tables.
--
-- SELF JOIN
-- → A table joined with itself.
--
-- CROSS JOIN
-- → Every possible combination of rows.
--
-- MULTI-TABLE JOIN
-- → Joining three or more tables.
--
-- ============================================================




SELECT
    e.employee_id,
    e.full_name,
    b.employee_id AS benefits_employee_id,
    b.insurance_provider
FROM 'data/silver/cleaned_data.parquet' AS e
RIGHT JOIN 'data/silver/employee_benefits.parquet' AS b
    ON e.employee_id = b.employee_id
LIMIT 10;