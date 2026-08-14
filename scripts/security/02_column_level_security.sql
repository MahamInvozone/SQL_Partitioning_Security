-- ============================================================
-- COLUMN-LEVEL SECURITY
-- ============================================================
--
-- Column-level security means users can access some columns
-- but not sensitive columns.
--
-- Example:
--
-- Analyst CAN see:
-- department
-- job_title
-- employment_status
--
-- Analyst CANNOT see:
-- salary
-- email
-- phone_number
-- bank_name
-- emergency_phone
-- ============================================================


-- ============================================================
-- SAFE ANALYTICS VIEW
-- ============================================================

CREATE OR REPLACE VIEW safe_employee_data AS

SELECT
    employee_id,
    full_name,
    gender,
    age,
    department,
    job_title,
    employment_status,
    work_location,
    education_level,
    performance_score,
    attendance_percentage
FROM 'data/silver/cleaned_data.parquet';


-- Test the view:

SELECT *
FROM safe_employee_data
LIMIT 10;


-- ============================================================
-- SENSITIVE COLUMNS EXCLUDED
-- ============================================================
--
-- salary
-- email
-- phone_number
-- bank_name
-- account_type
-- emergency_contact
-- emergency_phone
--
-- The user receives only the columns required for analysis.
-- ============================================================