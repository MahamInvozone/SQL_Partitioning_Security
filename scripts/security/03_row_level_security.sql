-- ============================================================
-- ROW-LEVEL SECURITY
-- ============================================================
--
-- Row-level security means users can only see rows they
-- are authorised to access.
--
-- Example:
--
-- IT manager
--     ↓
-- Can see IT employees
--
-- Cannot see:
-- Sales
-- Finance
-- HR
-- etc.
-- ============================================================


-- ============================================================
-- IT MANAGER VIEW
-- ============================================================

CREATE OR REPLACE VIEW it_manager_employee_data AS

SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status
FROM 'data/silver/cleaned_data.parquet'
WHERE department = 'IT';


-- Test:

SELECT *
FROM it_manager_employee_data
LIMIT 10;


-- ============================================================
-- SALES MANAGER VIEW
-- ============================================================

CREATE OR REPLACE VIEW sales_manager_employee_data AS

SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status
FROM 'data/silver/cleaned_data.parquet'
WHERE department = 'Sales';


-- Test:

SELECT *
FROM sales_manager_employee_data
LIMIT 10;


-- ============================================================
-- CONCEPT
-- ============================================================
--
-- IT Manager
-- → department = 'IT'
--
-- Sales Manager
-- → department = 'Sales'
--
-- The filtering condition determines which rows
-- the user is allowed to see.
--
-- Production databases can enforce this dynamically
-- based on the authenticated user's identity/role.
-- ============================================================