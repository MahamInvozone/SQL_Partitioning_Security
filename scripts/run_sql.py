import duckdb

sql_file = "scripts/sql/01_sql_fundamentals.sql"

with open(sql_file, "r") as file:
    query = file.read()

result = duckdb.sql(query)

print(result)