# DuckDB Codespace Setup Guide - Module 4 Analytics Engineering

Welcome to the Module 4 Analytics Engineering homework! This guide will help you get started with the DuckDB environment and complete all homework questions.

---

## Overview

This DuckDB codespace comes pre-configured with:
- **dbt-core 1.11.2** with **dbt-duckdb adapter**
- **Pre-loaded taxi data** (Green, Yellow, FHV from 2019-2020)
- **Isolated workspace** at `/home/vscode/homework`
- **All dependencies** pre-installed

**Total setup time**: ~2 minutes

---

## Part 1: Verify Environment Setup

### Step 1: Verify dbt Installation

```bash
dbt --version
```

**Expected output**:
```
Core:
  - installed: 1.11.2
  - latest: 1.11.2 - Up to date!

Plugins:
  - duckdb: 1.10.0 - Up to date!
```

### Step 2: Verify Database and Data

The taxi data has been pre-loaded during codespace creation. Verify it by querying the raw tables:

```bash
cd /home/vscode/homework
duckdb taxi_rides_ny.duckdb "SELECT COUNT(*) FROM main.green_tripdata"
duckdb taxi_rides_ny.duckdb "SELECT COUNT(*) FROM main.yellow_tripdata"
```

**Expected output**:
- Green taxi: 7,778,101 rows
- Yellow taxi: 109,047,518 rows

You can also view sample data:
```bash
duckdb taxi_rides_ny.duckdb "SELECT * FROM main.green_tripdata LIMIT 5"
```

**Note**: The staging models (stg_green_tripdata, stg_yellow_tripdata) are views that will be created when you run `dbt build` in Part 3. All dbt models will be created in the `dev` schema.

### Step 3: Verify dbt Connection

```bash
cd /home/vscode/homework
dbt debug```

**Expected output**:
```
Connection test: OK connection ok
All checks passed!
```

✅ **Part 1 Complete** - Environment is ready!

---

## Part 2: Understanding the Data

### Data Sources

The pre-loaded database contains:

1. **Green Taxi** (2019-2020): ~7.7M records
2. **Yellow Taxi** (2019-2020): ~109M records
3. **FHV (For Hire Vehicles)** (2019): ~43M records
4. **Taxi Zone Lookup**: 265 zones with borough/zone names

### Project Structure

```
/home/vscode/homework/
├── dbt_project.yml          # dbt project configuration
├── profiles/
│   └── profiles.yml         # DuckDB connection settings (pre-configured)
├── models/
│   ├── staging/             # Staging models (clean/standardize raw data)
│   │   ├── stg_green_tripdata.sql
│   │   └── stg_yellow_tripdata.sql
│   ├── intermediate/        # Intermediate transformations
│   │   ├── int_trips_unioned.sql
│   │   └── int_trips.sql
│   └── marts/              # Final fact/dimension tables
│       ├── dim_zones.sql
│       └── fct_trips.sql
├── seeds/
│   ├── taxi_zone_lookup.csv
│   └── payment_type_lookup.csv
└── taxi_rides_ny.duckdb    # DuckDB database file
```

### Key Models Explained

- **staging**: Clean raw data, rename columns, standardize types
- **intermediate**: Union Green + Yellow, add deduplication
- **marts**: Final business layer with fact tables and dimensions
  - `dim_zones`: Dimension table for taxi zones (265 zones)
  - `fct_trips`: Fact table with all trip details (~197k sample)

---

## Part 3: Build the Base Models

### Step 1: Build All Base Models

```bash
cd /home/vscode/homework
dbt build```

**Build time**: ~30-60 seconds (depending on data size)

### Expected Results

```
Completed successfully

Done. PASS=34 WARN=0 ERROR=0 SKIP=11 TOTAL=45
```

**Models Created**:
- Seeds: `payment_type_lookup` (7 rows), `taxi_zone_lookup` (265 rows)
- Staging: `stg_green_tripdata`, `stg_yellow_tripdata` (views)
- Intermediate: `int_trips_unioned`, `int_trips` (tables)
- Marts: `dim_zones`, `fct_trips` (tables)

### Step 2: Verify Data Quality

Check the main fact table:

```bash
dbt show --select fct_trips --limit 10```

Query the database directly:

```bash
duckdb /home/vscode/homework/taxi_rides_ny.duckdb
```

Then run:
```sql
SELECT
  service_type,
  COUNT(*) as total_trips,
  COUNT(DISTINCT pickup_zone) as pickup_zones
FROM dev.fct_trips
GROUP BY service_type;
```

**Expected**: You should see trip counts for Green and Yellow taxis.

To exit DuckDB: `CTRL+D` or `.exit`

✅ **Part 3 Complete** - Base models built successfully!

---


## Part 4: Next Steps

Your environment is ready! Here's what you can do:

### Working with dbt

**Create new models:**
```bash
# Create a new SQL file in models/marts/
touch models/marts/my_new_model.sql
```

**Build and test models:**
```bash
# Build a specific model
dbt run --select my_model

# Build a model and its dependencies
dbt run --select +my_model

# Test your models
dbt test --select my_model

# View model results
dbt show --select my_model --limit 20
```

**Explore your data:**
```bash
# Open DuckDB CLI
duckdb /home/vscode/homework/taxi_rides_ny.duckdb

# Then run SQL queries
SELECT * FROM main.green_tripdata LIMIT 10;
SELECT * FROM dev.fct_trips LIMIT 10;
```

### 📝 Homework

Ready to tackle the homework? **Open `HOMEWORK.md`** for all questions and instructions.

The homework will guide you through:
- Understanding dbt concepts (sources, variables, macros)
- Building analytical models
- Working with window functions and aggregations
- Creating new dbt models to answer specific business questions

**Resources:**
- dbt Documentation: https://docs.getdbt.com/
- DuckDB SQL Reference: https://duckdb.org/docs/sql/introduction

---

## Troubleshooting

### Issue 1: "Database not found"

**Error**: `Catalog Error: Table "main.green_tripdata" does not exist!`

**Solution**: The data should be pre-loaded. Check if database file exists:
```bash
ls -lh /home/vscode/homework/taxi_rides_ny.duckdb
```

If missing, the Docker image may not have baked the data. Check setup.log:
```bash
cat /home/vscode/homework/setup.log
```

### Issue 2: "No such relation"

**Error**: `Catalog Error: Table with name "stg_green_tripdata" does not exist!`

**Solution**: The staging models are views that must be created before you can query them. Build them first:
```bash
dbt build --select staging```

After building, you can view the staging models:
```bash
dbt show --select stg_green_tripdata --limit 10
```

### Issue 3: "Memory limit exceeded"

**Error**: `Out of Memory Error`

**Solution**: The DuckDB profiles.yml is configured with 4GB memory limit. If you're working with full datasets (100M+ rows), you may need to:
- Work with filtered data (use WHERE clauses)
- Build models incrementally
- Use views instead of tables for intermediate models

### Issue 4: "dbt deps failed"

**Error**: Package dependency issues

**Solution**: Re-run deps:
```bash
cd /home/vscode/homework
dbt clean
dbt deps
```

### Issue 5: "Model already exists"

**Error**: When trying to rebuild a model

**Solution**: Use `--full-refresh`:
```bash
dbt run --select your_model --full-refresh
```

---

## Tips for Success

### 1. **Start Simple**
- Test your logic on small datasets first (add LIMIT 1000)
- Build incrementally, don't try to solve everything at once

### 2. **Use dbt show for Quick Testing**
```bash
dbt show --select your_model --limit 20```

### 3. **Use DuckDB CLI for Ad-Hoc Queries**
```bash
duckdb /home/vscode/homework/taxi_rides_ny.duckdb
```

Then explore:
```sql
SHOW TABLES;
SELECT * FROM dev.fct_trips LIMIT 10;
```

### 4. **Check Compiled SQL**
```bash
dbt compile --select your_model
cat target/compiled/taxi_rides_ny/models/marts/your_model.sql
```

### 5. **Use CTE (Common Table Expressions)**
Break complex queries into readable steps:
```sql
with revenue_by_quarter as (
  -- Step 1
),
yoy_comparison as (
  -- Step 2
)
select * from yoy_comparison
```

---

## Expected Build Performance

With the pre-loaded data:

- **Staging models** (views): <1 second each
- **Intermediate models** (tables): 5-10 seconds each
- **Marts** (fact/dim tables): 10-30 seconds each
- **Full build** (dbt build): ~60 seconds

For full datasets (100M+ rows):
- Expect 5-10 minutes for full build
- Individual complex models may take 2-3 minutes

---

## Data Validation Queries

### Check Record Counts

```sql
-- In DuckDB CLI
SELECT 'green_tripdata' as table_name, COUNT(*) as row_count FROM main.green_tripdata
UNION ALL
SELECT 'yellow_tripdata', COUNT(*) FROM main.yellow_tripdata
UNION ALL
SELECT 'fhv_tripdata', COUNT(*) FROM main.fhv_tripdata;
```

**Expected counts (per homework)**:
- Green: 7,778,101
- Yellow: 109,047,518
- FHV: 43,244,696

### Check Date Ranges

```sql
SELECT
  'green' as source,
  MIN(pickup_datetime) as earliest,
  MAX(pickup_datetime) as latest
FROM main.green_tripdata
UNION ALL
SELECT
  'yellow',
  MIN(pickup_datetime),
  MAX(pickup_datetime)
FROM main.yellow_tripdata;
```

**Expected**: Data from 2019-01-01 to 2020-12-31

---

## Submitting Your Homework

1. **Test your models**:
   ```bash
   dbt test --select your_new_models
   ```

2. **Document your queries**:
   - Keep your SQL files in `models/marts/`
   - Add comments explaining your logic

3. **Query your results**:
   - Use DuckDB CLI or `dbt show` to get the answers
   - Copy the results to the homework submission form

4. **Submit**: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw4

---

## Quick Reference Commands

```bash
# Navigate to workspace
cd /home/vscode/homework

# Build everything
dbt build
# Build specific model
dbt run --select fct_trips
# Build model and its dependencies
dbt run --select +fct_trips
# Build model and its dependents
dbt run --select fct_trips+
# Run tests
dbt test
# Show compiled SQL
dbt compile --select model_name
# View results
dbt show --select model_name --limit 10
# Clean build artifacts
dbt clean

# Reinstall dependencies
dbt deps

# Open DuckDB CLI
duckdb /home/vscode/homework/taxi_rides_ny.duckdb
```

---

## Additional Resources

- **dbt Documentation**: https://docs.getdbt.com/
- **dbt-duckdb Adapter**: https://github.com/duckdb/dbt-duckdb
- **DuckDB SQL Reference**: https://duckdb.org/docs/sql/introduction
- **Homework Questions**: See `/workspaces/data-engineering-zoomcamp/cohorts/2025/04-analytics-engineering/homework.md`

---

## Summary

You now have:
- ✅ Pre-configured dbt environment with DuckDB
- ✅ Pre-loaded taxi data (Green, Yellow, FHV)
- ✅ Base models built and tested
- ✅ Guide for all 7 homework questions
- ✅ SQL templates and examples
- ✅ Troubleshooting tips

**Total setup time**: ~2 minutes
**You're ready to tackle the homework!** 🚀

For questions 5-7, create your new models in `models/marts/`, run `dbt run --select your_model`, then query the results to find the answers.

Good luck! 🎉
