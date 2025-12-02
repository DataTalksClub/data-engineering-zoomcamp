# Local Setup Guide

This guide walks you through setting up a local analytics engineering environment using DuckDB, dbt, and Streamlit.

<div align="center">

[![dbt Core](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![DuckDB](https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black)](https://duckdb.org/)
[![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)](https://streamlit.io/)

</div>

>[!NOTE]
>*This guide will explain how to do the setup manually. If you want an additional challenge, try to run this setup using Docker Compose or a Python virtual environment.*

## Step 1: Install DuckDB

DuckDB is a fast, in-process SQL database that works great for local analytics workloads. To install DuckDB, follow the instruction on the [official site](https://duckdb.org/docs/installation) for your specific operating system.

> [!TIP]
> *You can install DuckDB in two ways. You can install the CLI or install the client API for your favorite programming language (in the case of Python, you can use `pip install duckdb`). I personally prefer installing the CLI, but either way is fine.*

## Step 2: Install dbt

```bash
pip install dbt-duckdb
```

This installs:

* `dbt-core`: The core dbt framework
* `dbt-duckdb`: The DuckDB adapter for dbt

## Step 3: Initialize dbt Project

If starting from scratch, `dbt init` will guide you through creating a new project. Here's what happens step-by-step:

1. **Run the initialization command:**

   ```bash
   dbt init taxi_rides_ny
   ```

2. **Select the database adapter:**

   You'll see a prompt like this:
   ```
   Which database would you like to use?
   [1] duckdb
   [2] postgres
   [3] redshift
   ...

   (Don't see the one you want? https://docs.getdbt.com/docs/available-adapters)

   Enter a number:
   ```

   Type the right number and press Enter to select DuckDB.

3. **Configure database settings:**

   Next, you'll be asked for database configuration:
   ```
   path (The path to your DuckDB database file) [path/to/file.duckdb]:
   ```

   Enter: `taxi_rides_ny.duckdb`

   **What this does**: This creates a file called `taxi_rides_ny.duckdb` in your project directory (the same folder as `dbt_project.yml`). This is where all your data will be stored. The path is relative, so dbt will look for this file wherever you run dbt commands from - make sure you're always in the project directory when working with dbt.

   ```
   threads (1 or more) [1]:
   ```

   Press Enter to keep the default (1), or enter `4` for parallel execution.

4. **Project created successfully:**

   You'll see:
   ```
   Your new dbt project "taxi_rides_ny" was created!
   ```

**What `dbt init` created:**

After initialization, your project directory contains:

```
taxi_rides_ny/
├── dbt_project.yml       # Project configuration file
├── README.md             # Project documentation
├── models/               # Directory for SQL model files
│   └── example/          # Example models (you can delete this)
├── macros/               # Directory for reusable SQL macros
├── seeds/                # Directory for CSV files to load
├── snapshots/            # Directory for snapshot models
├── tests/                # Directory for custom data tests
└── analyses/             # Directory for ad-hoc queries
```

**AND** it created/updated `~/.dbt/profiles.yml` with:

```yaml
taxi_rides_ny:
  outputs:
    dev:
      path: taxi_rides_ny.duckdb
      threads: 1
      type: duckdb
  target: dev
```

> [!IMPORTANT]
> The profile name `taxi_rides_ny` in `profiles.yml` **must match** the `profile: 'taxi_rides_ny'` setting in your `dbt_project.yml` file. If you used a different project name during `dbt init`, update one to match the other.

## Step 4: Download and Ingest Data

Now that your dbt project is set up, let's load the taxi data into DuckDB. From within your `taxi_rides_ny` dbt project directory, open the DuckDB CLI:

```bash
duckdb taxi_rides_ny.duckdb
```

Then execute the following SQL commands to load the data into tables:

```sql
-- Configuration variables for downloading datasets
SET VARIABLE base_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/';
SET VARIABLE start_date = DATE '2019-01-01';
SET VARIABLE end_date = DATE '2020-12-01';

-- Step 1: Download data locally as partitioned parquet files
-- This creates the data folder and downloads all data into partitioned structure
-- Download yellow tripdata and partition by year/month
COPY (
    SELECT *,
           year(tpep_pickup_datetime) AS year,
           month(tpep_pickup_datetime) AS month
    FROM read_parquet(
        list_transform(
            generate_series(getvariable('start_date'),
                           getvariable('end_date'),
                           INTERVAL 1 MONTH),
            d -> getvariable('base_url') || 'yellow_tripdata_' || strftime(d, '%Y-%m') || '.parquet'
        ),
        union_by_name=true
    )
)
TO 'data/yellow_tripdata'
(FORMAT PARQUET, PARTITION_BY (year, month));

-- Download green tripdata and partition by year/month
COPY (
    SELECT *,
           year(lpep_pickup_datetime) AS year,
           month(lpep_pickup_datetime) AS month
    FROM read_parquet(
        list_transform(
            generate_series(getvariable('start_date'),
                           getvariable('end_date'),
                           INTERVAL 1 MONTH),
            d -> getvariable('base_url') || 'green_tripdata_' || strftime(d, '%Y-%m') || '.parquet'
        ),
        union_by_name=true
    )
)
TO 'data/green_tripdata'
(FORMAT PARQUET, PARTITION_BY (year, month));

-- Step 2: Create the raw schema and tables from local parquet files
CREATE SCHEMA IF NOT EXISTS raw;

-- Create yellow tripdata table from local files
CREATE OR REPLACE TABLE raw.yellow_tripdata AS
SELECT * EXCLUDE (year, month)
FROM read_parquet('data/yellow_tripdata/**/*.parquet', hive_partitioning=true);

-- Create green tripdata table from local files
CREATE OR REPLACE TABLE raw.green_tripdata AS
SELECT * EXCLUDE (year, month)
FROM read_parquet('data/green_tripdata/**/*.parquet', hive_partitioning=true);
```

### Verify Data Loaded Successfully

Verify the data manually by running these commands in the DuckDB CLI:

```sql
-- Check which schemas exist
SHOW SCHEMAS;

-- Verify tables exist in the raw schema
SHOW TABLES;

-- Count rows in each table
SELECT COUNT(*) as yellow_count FROM raw.yellow_tripdata;
SELECT COUNT(*) as green_count FROM raw.green_tripdata;

-- Preview sample data
SELECT * FROM raw.yellow_tripdata LIMIT 5;
SELECT * FROM raw.green_tripdata LIMIT 5;
```

> [!TIP]
> *If you don't see the expected row counts or tables, exit DuckDB (`Ctrl+D` or `.exit`) and verify you're running the commands in the correct database file (`taxi_rides_ny.duckdb`).*

Once verified, exit DuckDB with `Ctrl+D` or `.exit` to return to your terminal.

## Step 5: Test the dbt Connection

Verify dbt can connect to your DuckDB database:

```bash
dbt debug
```

If you see errors, check:

1. `profiles.yml` is in the correct location (`~/.dbt/profiles.yml`)
2. Profile name matches between `profiles.yml` and `dbt_project.yml`
3. DuckDB database file exists at the specified path
4. You're running the command from within the `taxi_rides_ny` project directory

## Step 6: Install Streamlit

Streamlit is used for building interactive data applications and dashboards. You'll use this later to visualize the analytics you build with dbt.

```bash
pip install streamlit
```

## Additional Resources

* [DuckDB Documentation](https://duckdb.org/docs/)
* [dbt Documentation](https://docs.getdbt.com/)
* [dbt-duckdb Adapter](https://github.com/duckdb/dbt-duckdb)
* [Streamlit Documentation](https://docs.streamlit.io/)
* [NYC Taxi Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
