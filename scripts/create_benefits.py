import duckdb

query = """
COPY (
    SELECT
        employee_id,
        insurance_provider,
        account_type,
        laptop_assigned
    FROM 'data/silver/cleaned_data.parquet'
)
TO 'data/silver/employee_benefits.parquet'
(FORMAT PARQUET);
"""

duckdb.sql(query)

print("employee_benefits.parquet created successfully.")