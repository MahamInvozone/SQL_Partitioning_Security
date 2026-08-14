-- ============================================================
-- DATA PARTITIONING
-- Project: Medallion Architecture
-- ============================================================

-- WHAT IS PARTITIONING?
-- Partitioning divides a dataset into smaller physical
-- groups based on one or more columns.
--
-- Example:
--
-- department=IT/
-- department=Sales/
-- department=Finance/
--
-- Instead of scanning all data, a query filtering by
-- department may only need to read the relevant partition.


-- ============================================================
-- SILVER LAYER
-- ============================================================
--
-- Our Silver data is partitioned by:
--
-- department
--
-- Example:
--
-- data/silver/partitioned/
-- ├── department=IT/
-- ├── department=Sales/
-- ├── department=Finance/
-- └── ...
--
-- WHY?
--
-- Department has a reasonable number of distinct values
-- in our dataset and is useful for filtering employee data.


-- ============================================================
-- GOLD LAYER
-- ============================================================
--
-- Our Gold data is also partitioned by:
--
-- department
--
-- Gold contains aggregated/business-level information,
-- so department is useful for department-specific analysis.


-- ============================================================
-- PARTITION PRUNING
-- ============================================================
--
-- Example:
--
-- SELECT COUNT(*)
-- FROM 'data/silver/partitioned/**/*.parquet'
-- WHERE department = 'IT';
--
-- Result from our project:
--
-- 99 employees
--
-- DuckDB can use the partition information to avoid
-- unnecessarily reading unrelated department partitions.


-- ============================================================
-- HOW TO CHOOSE A PARTITION COLUMN
-- ============================================================
--
-- Consider:
--
-- 1. DATA VOLUME
--    Partitioning is more useful for large datasets.
--
-- 2. QUERY PATTERNS
--    Choose columns frequently used in WHERE filters.
--
-- 3. CARDINALITY
--    Avoid columns with extremely high numbers of unique
--    values, such as employee_id.
--
-- 4. DATA DISTRIBUTION
--    Avoid highly unbalanced partitions.
--
-- 5. ACCESS PATTERNS
--    Partition according to how downstream users query data.


-- ============================================================
-- GOOD PARTITION COLUMNS
-- ============================================================
--
-- Examples:
--
-- date
-- year
-- month
-- department
-- region
-- country
--
-- depending on the workload.


-- ============================================================
-- BAD PARTITIONING EXAMPLES
-- ============================================================
--
-- employee_id
-- transaction_id
-- email
--
-- These often create a huge number of tiny partitions.
--
-- This is called the SMALL FILE PROBLEM.


-- ============================================================
-- IMPORTANT BEST PRACTICES
-- ============================================================
--
-- ✓ Don't partition every column.
-- ✓ Choose columns based on query patterns.
-- ✓ Avoid very high-cardinality columns.
-- ✓ Avoid creating thousands of tiny files.
-- ✓ Consider data volume before partitioning.
-- ✓ Monitor partition sizes.
-- ✓ Use date-based partitioning for time-series data
--   when appropriate.
--
-- ============================================================