import duckdb

input_file = "data/silver/cleaned_data.parquet"
output_path = "data/gold/partitioned"

query = f"""
COPY (
    SELECT
        department,
        COUNT(*) AS employee_count,
        ROUND(AVG(TRY_CAST(salary AS DOUBLE)), 2) AS average_salary,
        ROUND(SUM(TRY_CAST(salary AS DOUBLE)), 2) AS total_salary
    FROM '{input_file}'
    GROUP BY department
)
TO '{output_path}'
(
    FORMAT PARQUET,
    PARTITION_BY (department)
);
"""

duckdb.sql(query)

print("Gold data partitioned successfully.")