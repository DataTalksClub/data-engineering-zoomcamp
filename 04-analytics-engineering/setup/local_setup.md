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
      threads: 4
      type: duckdb
  target: dev
```

> [!IMPORTANT]
> The profile name `taxi_rides_ny` in `profiles.yml` **must match** the `profile: 'taxi_rides_ny'` setting in your `dbt_project.yml` file. If you used a different project name during `dbt init`, update one to match the other.

## Step 4: Download and Ingest Data

Now that your dbt project is set up, let's load the taxi data into DuckDB.

### Understanding the Data Architecture

Before loading data, it's important to understand the schema strategy we're using:

* **`raw` schema**: Stores raw, unprocessed data exactly as it comes from the source. Think of this as your "landing zone". Data here should never be changed or transformed.
* **`staging` schema** (created later by dbt): Contains cleaned, standardized versions of raw data with consistent naming and types. This is only meant for minor transformations.
* **`intermediate` schema** (created later by dbt): Contains any major transformation that is not meant to be exposed to business users.
* **`marts` schema** (created later by dbt): Business-ready datasets combining multiple sources for analytics and reporting.

This **raw → staging → intermediate → marts** pattern is the industry-standard approach in modern analytics engineering. You're setting up the `raw` layer now, and in future lessons you'll use dbt to build the staging and mart layers.

### Choose Your Approach

You can load the data using either **Python** (recommended for most users) or **DuckDB CLI** (for those who prefer pure SQL). Both approaches produce identical results.

<details>
<summary><b>Option A: Python Script (Recommended)</b></summary>

Create a file called `ingest_data.py` in your `taxi_rides_ny` dbt project directory:

```python
from datetime import datetime
from dateutil.relativedelta import relativedelta
import duckdb
import os

# Configuration
START_DATE = '2019-01-01'
END_DATE = '2020-12-01'
BASE_URL = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'
DB_PATH = 'taxi_rides_ny.duckdb'

def generate_urls(taxi_type, start, end):
    urls, current = [], datetime.strptime(start, '%Y-%m-%d')
    end_dt = datetime.strptime(end, '%Y-%m-%d')
    while current <= end_dt:
        urls.append(f"{BASE_URL}{taxi_type}_tripdata_{current.strftime('%Y-%m')}.parquet")
        current += relativedelta(months=1)
    return urls

# Verify we're in the correct directory (where dbt_project.yml exists)
if not os.path.exists('dbt_project.yml'):
    print("ERROR: dbt_project.yml not found!")
    print("Please run this script from your dbt project directory (taxi_rides_ny/)")
    exit(1)

# Connect and create schema
con = duckdb.connect(DB_PATH)
con.execute("CREATE SCHEMA IF NOT EXISTS raw")

# Load yellow taxi data
print("Loading yellow taxi data...")
yellow_urls = generate_urls('yellow', START_DATE, END_DATE)
con.execute(f"CREATE OR REPLACE TABLE raw.yellow_tripdata AS SELECT * FROM read_parquet({yellow_urls}, union_by_name=true)")
print(f"✓ Loaded {con.execute('SELECT COUNT(*) FROM raw.yellow_tripdata').fetchone()[0]:,} records")

# Load green taxi data
print("Loading green taxi data...")
green_urls = generate_urls('green', START_DATE, END_DATE)
con.execute(f"CREATE OR REPLACE TABLE raw.green_tripdata AS SELECT * FROM read_parquet({green_urls}, union_by_name=true)")
print(f"✓ Loaded {con.execute('SELECT COUNT(*) FROM raw.green_tripdata').fetchone()[0]:,} records")

con.close()
print("✓ Done!")
```

Install the required dependency and run the script:

```bash
pip install python-dateutil
python ingest_data.py
```

> [!IMPORTANT]
> **Always run this script from your dbt project directory** (where `dbt_project.yml` is located). The script includes a safety check to prevent creating the database in the wrong location. This ensures your Python script and dbt use the same DuckDB database file.

</details>

<details>
<summary><b>Option B: DuckDB CLI (Pure SQL)</b></summary>

This approach uses DuckDB's built-in capabilities to download and load the data. This works on all operating systems (Windows, Mac, Linux) and is memory-efficient.

From within your `taxi_rides_ny` dbt project directory, open the DuckDB CLI:

```bash
duckdb taxi_rides_ny.duckdb
```

Then execute the following SQL commands to load the data into tables:

```sql
-- Create the raw schema
CREATE SCHEMA IF NOT EXISTS raw;

-- Configuration variables for both datasets
SET VARIABLE base_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/';
SET VARIABLE start_date = DATE '2019-01-01';
SET VARIABLE end_date = DATE '2020-12-01';

-- Create yellow tripdata table with dynamically generated URLs
CREATE OR REPLACE TABLE taxi_rides_ny.raw.yellow_tripdata AS
SELECT *
FROM read_parquet(
    list_transform(
        generate_series(getvariable('start_date'),
                       getvariable('end_date'),
                       INTERVAL 1 MONTH),
        d -> getvariable('base_url') || 'yellow_tripdata_' || strftime(d, '%Y-%m') || '.parquet'
    ),
    union_by_name=true
);

-- Create green tripdata table with dynamically generated URLs
CREATE OR REPLACE TABLE taxi_rides_ny.raw.green_tripdata AS
SELECT *
FROM read_parquet(
    list_transform(
        generate_series(getvariable('start_date'),
                       getvariable('end_date'),
                       INTERVAL 1 MONTH),
        d -> getvariable('base_url') || 'green_tripdata_' || strftime(d, '%Y-%m') || '.parquet'
    ),
    union_by_name=true
);

-- Export data as partitioned parquet files for backup/portability
-- Partitioning by year and month keeps files manageable and enables efficient queries
COPY (
    SELECT *,
           year(tpep_pickup_datetime) AS year,
           month(tpep_pickup_datetime) AS month
    FROM raw.yellow_tripdata
)
TO 'data/yellow_tripdata'
(FORMAT PARQUET, PARTITION_BY (year, month));

COPY (
    SELECT *,
           year(lpep_pickup_datetime) AS year,
           month(lpep_pickup_datetime) AS month
    FROM raw.green_tripdata
)
TO 'data/green_tripdata'
(FORMAT PARQUET, PARTITION_BY (year, month));
```

</details>

### Verify Data Loaded Successfully

**If you used the Python script**, verification is automatically performed at the end of the script execution.

**If you used the DuckDB CLI approach**, verify the data manually by running these commands in the DuckDB CLI:

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
