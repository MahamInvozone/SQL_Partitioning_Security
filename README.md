# SQL, Data Partitioning & Security Pipeline

A practical Data Engineering project built on the Medallion Architecture using Python, SQL, DuckDB, Pandas, and Parquet.

## Objectives

- Practice SQL filtering, sorting, aggregations, subqueries, CTEs, and window functions.
- Practice INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS, and multi-table joins.
- Understand and implement data partitioning across Bronze, Silver, and Gold layers.
- Understand RBAC, column-level security, and row-level security.
- Query Parquet data directly with DuckDB.

## Architecture

```text
Bronze (raw CSV)
       |
       v
Silver (cleaned Parquet)
       |
       +----> Partitioned Silver
       |
       v
Gold (aggregated Parquet)
       |
       +----> Partitioned Gold
```

## Project Structure

```text
Medallion_Architecture/
├── data/
│   ├── bronze/sample_data.csv
│   ├── silver/cleaned_data.parquet
│   ├── silver/employee_benefits.parquet
│   ├── silver/partitioned/
│   ├── gold/department_summary.parquet
│   └── gold/partitioned/
├── scripts/
│   ├── bronze_to_silver.py
│   ├── silver_to_gold.py
│   ├── create_benefits.py
│   ├── create_partitions.py
│   ├── create_gold_partitions.py
│   ├── run_sql.py
│   ├── test_security.py
│   ├── sql/
│   │   ├── 01_sql_fundamentals.sql
│   │   ├── 02_joins.sql
│   │   ├── 03_ctes.sql
│   │   ├── 04_window_functions.sql
│   │   └── 05_partitioning_notes.sql
│   └── security/
│       ├── 01_rbac.sql
│       ├── 02_column_level_security.sql
│       └── 03_row_level_security.sql
├── README.md
└── .gitignore
```

## Medallion Layers

### Bronze
Raw source data stored in `data/bronze/sample_data.csv`. It contains realistic data-quality issues such as missing values and inconsistent casing.

### Silver
Cleaned and transformed employee data stored as Parquet in `data/silver/cleaned_data.parquet`.

### Gold
Business-oriented aggregated data stored in `data/gold/department_summary.parquet`, including department-level salary analysis.

## SQL Practice

### SQL Fundamentals

`01_sql_fundamentals.sql` covers:

- SELECT and WHERE
- ORDER BY and LIMIT
- DISTINCT, LIKE, IN, BETWEEN
- NULL handling
- COUNT, SUM, AVG, MIN, MAX
- GROUP BY and HAVING
- Subqueries

### Advanced Joins

`02_joins.sql` covers:

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- SELF JOIN
- CROSS JOIN
- Multi-table joins

An employee benefits dataset was created to practice joining multiple datasets.

### CTEs

`03_ctes.sql` demonstrates Common Table Expressions for breaking complex SQL into readable steps.

### Window Functions

`04_window_functions.sql` covers ROW_NUMBER, RANK, DENSE_RANK, PARTITION BY, ordering within windows, and department-level calculations.

## Data Partitioning

Silver data is partitioned by `department` using `scripts/create_partitions.py`.

Example query:

```sql
SELECT COUNT(*)
FROM 'data/silver/partitioned/**/*.parquet'
WHERE department = 'IT';
```

The test returned **99 IT employees**.

Gold partitioning is created by `scripts/create_gold_partitions.py`.

Partition columns should be selected based on:

- Data volume
- Query/filter patterns
- Column cardinality
- Data access requirements
- Number and size of generated files

## Data Security

### RBAC

`01_rbac.sql` demonstrates role-based access using example roles such as Admin, HR, and Manager.

### Column-Level Security

`02_column_level_security.sql` demonstrates restricting sensitive columns while allowing access to non-sensitive employee information.

### Row-Level Security

`03_row_level_security.sql` demonstrates restricting users to authorized rows. The IT Manager example returns **99 IT employees**.

## Security Testing

Run:

```bash
python scripts/test_security.py
```

The test demonstrates Admin, HR, Manager, column-level, and row-level views. The Admin view returned **1010 rows**.

## DuckDB

DuckDB is used to query Parquet directly without first loading the entire dataset into Pandas.

Example:

```python
import duckdb

result = duckdb.sql("""
    SELECT *
    FROM 'data/silver/cleaned_data.parquet'
    LIMIT 5
""")

print(result)
```

## Running the Project

Activate the environment:

```bash
source .venv/bin/activate
```

Run the pipeline:

```bash
python scripts/bronze_to_silver.py
python scripts/silver_to_gold.py
```

Create supporting datasets and partitions:

```bash
python scripts/create_benefits.py
python scripts/create_partitions.py
python scripts/create_gold_partitions.py
```

Run SQL examples:

```bash
python scripts/run_sql.py
```

Test security:

```bash
python scripts/test_security.py
```

## Key Observations

- SQL provides a structured way to filter, transform, aggregate, join, and analyze data.
- Different JOIN types solve different matching and non-matching record requirements.
- CTEs make complex SQL easier to read and maintain.
- Window functions calculate across related rows without collapsing the result like GROUP BY.
- Partitioning can reduce unnecessary data scanning for frequent partition-column filters.
- RBAC controls access by role.
- Column-level security controls which fields users can access.
- Row-level security controls which records users can access.

## Best Practices

- Keep Bronze data unchanged.
- Clean and standardize data in Silver.
- Store business-ready results in Gold.
- Use Parquet for analytical storage.
- Choose partitions based on real query patterns.
- Avoid excessive partitions.
- Use the correct JOIN for the business requirement.
- Give users only the permissions they need.
- Document SQL with comments for future revision.

## Learning Outcome

This project provided practical experience with Medallion Architecture, SQL fundamentals, advanced joins, CTEs, window functions, Parquet, DuckDB, data partitioning, RBAC, column-level security, row-level security, and Data Engineering pipeline design.
