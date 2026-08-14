# Medallion Architecture – Data Engineering Project

## Overview

This project demonstrates a practical Data Engineering pipeline using the **Medallion Architecture**, SQL, Parquet, DuckDB, data partitioning, advanced joins, and data security concepts.

The pipeline processes employee data through three layers:

**Bronze → Silver → Gold**

The project also demonstrates SQL fundamentals, advanced SQL joins, CTEs, window functions, data partitioning, and different levels of data access control.

---

## Project Objectives

- Understand and implement Medallion Architecture.
- Practice SQL fundamentals.
- Practice advanced SQL joins.
- Understand CTEs and subqueries.
- Practice SQL window functions.
- Understand data partitioning.
- Implement partitioning across Silver and Gold layers.
- Understand RBAC.
- Understand column-level security.
- Understand row-level security.
- Store processed data using Parquet.
- Query Parquet files directly using DuckDB.
- Compare Pandas and DuckDB for data processing.
- Document observations and best practices.

---

# 1. Medallion Architecture

The project follows the following data flow:

```text
Raw CSV
   ↓
Bronze Layer
   ↓
Silver Layer
   ↓
Gold Layer
   ↓
Analytics / SQL Queries
Bronze Layer

Location:

data/bronze/

The Bronze layer contains the raw source data with minimal or no transformations.

Example:

data/bronze/sample_data.csv

Purpose:

Preserve raw data.
Maintain the original source information.
Provide a reliable starting point for processing.
Silver Layer

Location:

data/silver/

The Silver layer contains cleaned and transformed data.

Example:

data/silver/cleaned_data.parquet

Transformations include:

Handling missing values.
Cleaning whitespace.
Standardizing text.
Converting appropriate columns to correct data types.
Cleaning numeric fields.
Cleaning date fields.

The Silver layer is intended to contain structured and reliable data suitable for analysis.

Gold Layer

Location:

data/gold/

The Gold layer contains aggregated and business-ready data.

Example:

data/gold/department_summary.parquet

Example aggregation:

Employee count by department.
Average salary by department.
Total salary by department.
Minimum salary.
Maximum salary.

The Gold layer is designed for reporting and analytics.

2. Dataset

The project uses an employee dataset containing approximately:

Rows: 1010
Columns: 50

Important columns include:

record_id
employee_id
first_name
last_name
full_name
gender
age
date_of_birth
email
phone_number
address
city
state
country
department
job_title
employment_status
salary
annual_bonus
performance_score
education_level
years_experience
project_count
training_hours
employee_rating
and other employee-related fields

The dataset intentionally contains realistic data-quality issues such as:

Missing values
Inconsistent casing
Extra whitespace
Missing numeric values
Missing dates

This allows the pipeline to demonstrate practical data cleaning.

3. SQL Fundamentals

SQL queries are stored in:

scripts/sql/01_sql_fundamentals.sql

The SQL practice covers:

SELECT
WHERE
DISTINCT
ORDER BY
LIMIT
AND / OR
IN
BETWEEN
LIKE
NULL handling
COUNT
SUM
AVG
MIN
MAX
GROUP BY
HAVING
Subqueries
CTEs
Window functions

Example:

SELECT
    department,
    AVG(salary) AS average_salary
FROM 'data/silver/cleaned_data.parquet'
GROUP BY department
ORDER BY average_salary DESC;

SQL is executed using DuckDB.

4. Advanced SQL Joins

Join queries are stored in:

scripts/sql/02_joins.sql

The project demonstrates:

Inner Join

Returns matching records from both tables.

Left Join

Returns all records from the left table and matching records from the right table.

Right Join

Returns all records from the right table and matching records from the left table.

Full Outer Join

Returns all records from both tables.

Self Join

Joins a table with itself.

Cross Join

Produces combinations of rows between two tables.

Multi-table Join

Combines more than two tables.

An additional employee benefits dataset is used to demonstrate joins:

data/silver/employee_benefits.parquet
5. CTEs and Subqueries

CTE queries are stored in:

scripts/sql/03_ctes.sql

CTE stands for:

Common Table Expression

CTEs make complex queries easier to read and organize.

Example:

WITH department_salary AS (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM 'data/silver/cleaned_data.parquet'
    GROUP BY department
)
SELECT *
FROM department_salary
WHERE average_salary > 70000;

Subqueries were also practiced for filtering and analytical calculations.

6. Window Functions

Window function queries are stored in:

scripts/sql/04_window_functions.sql

The project demonstrates functions such as:

ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
SUM() OVER()
AVG() OVER()
PARTITION BY

Example:

SELECT
    employee_id,
    full_name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank
FROM 'data/silver/cleaned_data.parquet';

Window functions allow calculations across related rows without collapsing the result into one row per group.

7. Data Partitioning

Partitioning separates data into smaller groups based on a selected column.

The partitioning scripts are:

scripts/create_partitions.py
scripts/create_gold_partitions.py

Partitioning notes are documented in:

scripts/sql/05_partitioning_notes.sql

The Silver layer is partitioned by:

department

Example structure:

data/silver/partitioned/
├── department=IT/
├── department=Sales/
├── department=Finance/
├── department=Marketing/
└── ...

The Gold layer is also partitioned for analytical access.

Partitioning is useful because queries that filter on the partition column can potentially read only the relevant partitions instead of scanning all files.

Example:

SELECT COUNT(*)
FROM 'data/silver/partitioned/**/*.parquet'
WHERE department = 'IT';

Result:

99 employees
8. Choosing Partition Columns

A good partition column should be selected based on:

Data volume
Query patterns
Filtering frequency
Cardinality
Data access requirements

For this project, department is a reasonable example because:

It has a relatively small number of distinct values.
Employees are frequently analyzed by department.
Queries commonly filter by department.
It avoids creating thousands of tiny partitions.

Avoid partitioning by columns with very high cardinality such as:

employee_id
email
phone_number

because this could create too many small files.

9. Data Security

Security demonstrations are stored in:

scripts/security/

Files:

01_rbac.sql
02_column_level_security.sql
03_row_level_security.sql

Testing is performed using:

scripts/test_security.py
Role-Based Access Control (RBAC)

RBAC controls access based on a user's role.

Example roles:

Admin
HR
Manager

Different roles receive different levels of access.

Example:

Admin  → Full access
HR     → Employee and salary information
Manager → Employee information without sensitive financial data
Column-Level Security

Column-level security restricts access to specific columns.

For example, sensitive fields such as:

salary
bank_name
account_type
phone_number

can be hidden from users who do not need access to them.

A manager view can expose:

employee_id
full_name
department
job_title
employment_status

while hiding sensitive financial information.

Row-Level Security

Row-level security restricts which rows a user can access.

For example, an IT manager may only access:

department = 'IT'

Example result:

IT → 99 employees

This means the user can work with the data but only see rows they are authorized to access.

10. DuckDB

DuckDB is used as the SQL engine for this project.

It allows SQL queries to run directly against Parquet files without requiring the complete dataset to be loaded into a Pandas DataFrame first.

Example:

import duckdb

result = duckdb.sql("""
    SELECT *
    FROM 'data/silver/cleaned_data.parquet'
    LIMIT 10
""")

print(result)

Advantages:

SQL-based analytics
Works directly with Parquet
Efficient analytical queries
Lightweight
Suitable for local data engineering workflows
11. Pandas vs DuckDB

The project also contains:

scripts/pandas_vs_duckdb.py

This compares data processing approaches using Pandas and DuckDB.

Pandas

Useful for:

Data cleaning
Transformation
Exploratory analysis
DataFrame operations
DuckDB

Useful for:

SQL analytics
Aggregations
Joins
Querying Parquet
Analytical workloads

A practical data engineering workflow can use both:

Pandas → Cleaning / Transformation
DuckDB → SQL Analytics
Parquet → Storage
12. Project Structure
Medallion_Architecture/
│
├── data/
│   ├── bronze/
│   │   └── sample_data.csv
│   │
│   ├── silver/
│   │   ├── cleaned_data.parquet
│   │   ├── employee_benefits.parquet
│   │   └── partitioned/
│   │
│   └── gold/
│       ├── department_summary.parquet
│       └── partitioned/
│
├── scripts/
│   ├── bronze_to_silver.py
│   ├── silver_to_gold.py
│   ├── check_data.py
│   ├── create_benefits.py
│   ├── create_partitions.py
│   ├── create_gold_partitions.py
│   ├── duckdb_queries.py
│   ├── pandas_vs_duckdb.py
│   ├── run_sql.py
│   ├── test_security.py
│   │
│   ├── sql/
│   │   ├── 01_sql_fundamentals.sql
│   │   ├── 02_joins.sql
│   │   ├── 03_ctes.sql
│   │   ├── 04_window_functions.sql
│   │   └── 05_partitioning_notes.sql
│   │
│   └── security/
│       ├── 01_rbac.sql
│       ├── 02_column_level_security.sql
│       └── 03_row_level_security.sql
│
├── README.md
└── .gitignore
13. How to Run the Project

Create and activate the virtual environment:

python3 -m venv .venv
source .venv/bin/activate

Run the Bronze → Silver pipeline:

python scripts/bronze_to_silver.py

Run the Silver → Gold pipeline:

python scripts/silver_to_gold.py

Check the data:

python scripts/check_data.py

Create employee benefits data:

python scripts/create_benefits.py

Create Silver partitions:

python scripts/create_partitions.py

Create Gold partitions:

python scripts/create_gold_partitions.py

Run SQL examples:

python scripts/run_sql.py

Run security demonstrations:

python scripts/test_security.py
14. Key Observations
Medallion Architecture

Separating data into Bronze, Silver, and Gold layers makes the pipeline easier to maintain, debug, and scale.

Parquet

Parquet is preferred for analytical workloads because it is columnar and efficient for storage and querying.

SQL

SQL provides a powerful way to filter, aggregate, join, rank, and analyze structured data.

Partitioning

Partitioning can reduce unnecessary data scanning when queries frequently filter on the partition column.

Security

Different users should only receive the minimum access required for their work.

DuckDB

DuckDB provides a lightweight way to perform SQL analytics directly on Parquet files.

15. Best Practices
Keep raw Bronze data unchanged.
Apply cleaning and standardization in the Silver layer.
Keep business-level aggregations in the Gold layer.
Use Parquet for analytical storage.
Choose partition columns based on query patterns and cardinality.
Avoid excessive small partitions.
Use RBAC to manage user permissions.
Restrict sensitive columns when necessary.
Restrict rows according to user authorization.
Follow the principle of least privilege.
Keep SQL queries organized and documented.
Use CTEs to improve readability of complex queries.
Use window functions when calculations are required across related rows.
Use DuckDB for efficient SQL-based analytical queries on Parquet.
Conclusion

This project demonstrates a complete Data Engineering workflow using:

Medallion Architecture + Pandas + Parquet + DuckDB + SQL + Partitioning + Data Security

The pipeline progresses from raw data in the Bronze layer to cleaned data in the Silver layer and finally to analytics-ready data in the Gold layer.

The project also demonstrates how SQL, partitioning, and access-control techniques can be applied to build a more efficient, maintainable, and secure data pipeline.