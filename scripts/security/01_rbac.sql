-- ============================================================
-- ROLE-BASED ACCESS CONTROL (RBAC)
-- Project: Medallion Architecture
-- Tool: DuckDB demonstration
-- ============================================================

-- RBAC means permissions are assigned to ROLES.
--
-- Example roles:
--
-- ADMIN
-- HR
-- MANAGER
-- ANALYST
--
-- Users are assigned to these roles.
--
-- In a production database, the database system would
-- enforce CREATE ROLE / GRANT / REVOKE permissions.
--
-- Here we demonstrate the concept using separate views.


-- ============================================================
-- 1. ADMIN VIEW
-- ============================================================
-- Admin users can access the complete employee dataset.

CREATE OR REPLACE VIEW admin_employee_data AS

SELECT *
FROM 'data/silver/cleaned_data.parquet';


-- ============================================================
-- 2. HR VIEW
-- ============================================================
-- HR needs employee information including salary.

CREATE OR REPLACE VIEW hr_employee_data AS

SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status,
    salary
FROM 'data/silver/cleaned_data.parquet';


-- ============================================================
-- 3. MANAGER VIEW
-- ============================================================
-- Managers don't need sensitive financial information.
--
-- Therefore salary is excluded.

CREATE OR REPLACE VIEW manager_employee_data AS

SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status
FROM 'data/silver/cleaned_data.parquet';


-- ============================================================
-- 4. ANALYST VIEW
-- ============================================================
-- Analysts receive only business-related information.

CREATE OR REPLACE VIEW analyst_employee_data AS

SELECT
    employee_id,
    department,
    job_title,
    employment_status
FROM 'data/silver/cleaned_data.parquet';


-- ============================================================
-- RBAC SUMMARY
-- ============================================================
--
-- ADMIN
-- → Full access
--
-- HR
-- → Employee + salary information
--
-- MANAGER
-- → Employee information without salary
--
-- ANALYST
-- → Non-sensitive analytical information
--
-- In production, these views would be protected using
-- database permissions such as GRANT and REVOKE.
-- ============================================================