-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW - Crate star schema tables
.read 01_Create_Tables_DW.sql

-- Step 2: DW - Load data from csv files into tables
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart
.read 03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Mart - Create priority mart
.read 05_create_priority_mart.sql

-- Step 6: Mart - Update priority mart
.read 06_update_priority_mart.sql