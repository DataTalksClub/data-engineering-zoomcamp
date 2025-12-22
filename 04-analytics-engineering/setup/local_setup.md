# Local Setup Guide

This guide walks you through setting up a local analytics engineering environment using DuckDB and dbt.

<div align="center">

[![dbt Core](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![DuckDB](https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black)](https://duckdb.org/)
[![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)](https://streamlit.io/)

</div>

>[!NOTE]
>*This guide will explain how to do the setup manually. If you want an additional challenge, try to run this setup using Docker Compose or a Python virtual environment.*

**Important**: All dbt commands must be run from inside the `taxi_rides_ny/` directory. The setup steps below will guide you through:

1. Installing the necessary tools
2. Configuring your connection to DuckDB
3. Loading the NYC taxi data
4. Verifying everything works

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

## Step 3: Configure dbt Profile

Since this repository already contains a dbt project (`taxi_rides_ny/`), you don't need to run `dbt init`. Instead, you need to configure your dbt profile to connect to DuckDB.

### Create or Update `~/.dbt/profiles.yml`

The dbt profile tells dbt how to connect to your database. Create or update the file `~/.dbt/profiles.yml` with the following content:

```yaml
# dbt profiles configuration
taxi_rides_ny:
  target: dev
  outputs:
    # DuckDB Development profile
    # Conservative settings to work on most PCs (4GB+ RAM)
    dev:
      type: duckdb
      path: taxi_rides_ny.duckdb
      threads: 1
      extensions:
        - httpfs
        - parquet
      settings:
        memory_limit: '2GB'
        preserve_insertion_order: false
        temp_directory: '.duckdb_temp/'

    # DuckDB Production profile
    # More threads and memory for better performance (16GB+ RAM recommended)
    prod:
      type: duckdb
      path: taxi_rides_ny.duckdb
      threads: 1
      extensions:
        - httpfs
        - parquet
      settings:
        memory_limit: '4GB'
        preserve_insertion_order: false
        temp_directory: '.duckdb_temp/'
```

> [!IMPORTANT]
> **Understanding the database path**: The `path: taxi_rides_ny.duckdb` is relative to where you run dbt commands. Since you'll be running dbt from inside the `taxi_rides_ny/` directory, the database file will be created at `taxi_rides_ny/taxi_rides_ny.duckdb`.
>
> The profile name `taxi_rides_ny` matches the `profile: 'taxi_rides_ny'` setting in the project's `dbt_project.yml` file. This connection is already configured in the repository.

## Step 4: Download and Ingest Data

Now that your dbt profile is configured, let's load the taxi data into DuckDB. Navigate to the dbt project directory and run the ingestion script

```python
import duckdb
import requests
from pathlib import Path

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

def download_files(taxi_type):
    data_dir = Path("data") / taxi_type
    data_dir.mkdir(exist_ok=True, parents=True)

    for year in [2019, 2020]:
        for month in range(1, 13):
            filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            filepath = data_dir / filename

            if filepath.exists():
                continue

            response = requests.get(f"{BASE_URL}/{taxi_type}/{filename}", stream=True)
            response.raise_for_status()

            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

if __name__ == "__main__":
    for taxi_type in ["yellow", "green"]:
        download_files(taxi_type)

    con = duckdb.connect("taxi_rides_ny.duckdb")
    con.execute("CREATE SCHEMA IF NOT EXISTS nytaxi")

    for taxi_type in ["yellow", "green"]:
        con.execute(f"""
            CREATE OR REPLACE TABLE nytaxi.{taxi_type}_tripdata AS
            SELECT * FROM read_csv('data/{taxi_type}/*.csv.gz', union_by_name=true, auto_detect=true, compression='gzip')
        """)

    con.close()
```

This script downloads yellow and green taxi data from 2019-2020, creates the `nytaxi` schema, and loads the data into DuckDB. The download may take several minutes depending on your internet connection.

## Step 5: Test the dbt Connection

Verify dbt can connect to your DuckDB database:

```bash
dbt debug
```

## Step 6: Install Streamlit

Streamlit is used for building interactive data applications and dashboards. You'll use this later to visualize the analytics you build with dbt.

```bash
pip install streamlit
```

> [!NOTE]
> At this point, your local dbt environment is fully configured and ready to use. The next steps (running models, tests, and building documentation) will be covered in the tutorial videos.

## Additional Resources

* [DuckDB Documentation](https://duckdb.org/docs/)
* [dbt Documentation](https://docs.getdbt.com/)
* [dbt-duckdb Adapter](https://github.com/duckdb/dbt-duckdb)
* [Streamlit Documentation](https://docs.streamlit.io/)
* [NYC Taxi Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
