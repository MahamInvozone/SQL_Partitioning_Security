import duckdb

input_file = "data/silver/cleaned_data.parquet"
output_path = "data/silver/partitioned"

query = f"""
COPY (
    SELECT *
    FROM '{input_file}'
)
TO '{output_path}'
(
    FORMAT PARQUET,
    PARTITION_BY (department)
);
"""

duckdb.sql(query)

print("Silver data partitioned successfully.")