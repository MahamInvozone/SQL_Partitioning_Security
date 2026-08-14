import duckdb

# Connect to DuckDB
con = duckdb.connect()

# ------------------------------------------------------------
# RBAC VIEWS
# ------------------------------------------------------------

con.execute("""
CREATE OR REPLACE VIEW admin_employee_data AS
SELECT *
FROM 'data/silver/cleaned_data.parquet';
""")

con.execute("""
CREATE OR REPLACE VIEW hr_employee_data AS
SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status,
    salary
FROM 'data/silver/cleaned_data.parquet';
""")

con.execute("""
CREATE OR REPLACE VIEW manager_employee_data AS
SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status
FROM 'data/silver/cleaned_data.parquet';
""")

# ------------------------------------------------------------
# COLUMN-LEVEL SECURITY
# ------------------------------------------------------------

con.execute("""
CREATE OR REPLACE VIEW safe_employee_data AS
SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status,
    performance_score
FROM 'data/silver/cleaned_data.parquet';
""")

# ------------------------------------------------------------
# ROW-LEVEL SECURITY
# ------------------------------------------------------------

con.execute("""
CREATE OR REPLACE VIEW it_manager_employee_data AS
SELECT
    employee_id,
    full_name,
    department,
    job_title,
    employment_status
FROM 'data/silver/cleaned_data.parquet'
WHERE department = 'IT';
""")

# ------------------------------------------------------------
# TEST RESULTS
# ------------------------------------------------------------

print("\n--- ADMIN VIEW ---")
print(con.sql("""
SELECT COUNT(*) AS total_rows
FROM admin_employee_data
"""))

print("\n--- HR VIEW ---")
print(con.sql("""
SELECT *
FROM hr_employee_data
LIMIT 5
"""))

print("\n--- MANAGER VIEW ---")
print(con.sql("""
SELECT *
FROM manager_employee_data
LIMIT 5
"""))

print("\n--- COLUMN-LEVEL SECURITY ---")
print(con.sql("""
SELECT *
FROM safe_employee_data
LIMIT 5
"""))

print("\n--- ROW-LEVEL SECURITY: IT MANAGER ---")
print(con.sql("""
SELECT
    department,
    COUNT(*) AS employee_count
FROM it_manager_employee_data
GROUP BY department
"""))

con.close()