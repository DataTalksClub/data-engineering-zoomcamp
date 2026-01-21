# Local Setup Guide

This guide walks you through setting up a local analytics engineering environment using DuckDB and dbt.

<div align="center">

[![dbt Core](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![DuckDB](https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black)](https://duckdb.org/)

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
taxi_rides_ny:
  target: dev
  outputs:
    # DuckDB Development profile
    dev:
      type: duckdb
      path: taxi_rides_ny.duckdb
      schema: dev
      threads: 1
      extensions:
        - parquet
      settings:
        memory_limit: '2GB'
        preserve_insertion_order: false

    # DuckDB Production profile
    prod:
      type: duckdb
      path: taxi_rides_ny.duckdb
      schema: prod
      threads: 1
      extensions:
        - parquet
      settings:
        memory_limit: '2GB'
        preserve_insertion_order: false

# Troubleshooting:
# - If you have less than 4GB RAM, try setting memory_limit to '1GB'
# - If you have 16GB+ RAM, you can increase to '4GB' for faster builds
# - Expected build time: 5-10 minutes on most systems
```

## Step 4: Download and Ingest Data

Now that your dbt profile is configured, let's load the taxi data into DuckDB. Navigate to the dbt project directory and run the ingestion script

```python
import duckdb
import requests
from pathlib import Path

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

def download_and_convert_files(taxi_type):
    data_dir = Path("data") / taxi_type
    data_dir.mkdir(exist_ok=True, parents=True)

    for year in [2019, 2020]:
        for month in range(1, 13):
            parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = data_dir / parquet_filename

            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            # Download CSV.gz file
            csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = data_dir / csv_gz_filename

            response = requests.get(f"{BASE_URL}/{taxi_type}/{csv_gz_filename}", stream=True)
            response.raise_for_status()

            with open(csv_gz_filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Converting {csv_gz_filename} to Parquet...")
            con = duckdb.connect()
            con.execute(f"""
                COPY (SELECT * FROM read_csv_auto('{csv_gz_filepath}'))
                TO '{parquet_filepath}' (FORMAT PARQUET)
            """)
            con.close()

            # Remove the CSV.gz file to save space
            csv_gz_filepath.unlink()
            print(f"Completed {parquet_filename}")

def update_gitignore():
    gitignore_path = Path(".gitignore")

    # Read existing content or start with empty string
    content = gitignore_path.read_text() if gitignore_path.exists() else ""

    # Add data/ if not already present
    if 'data/' not in content:
        with open(gitignore_path, 'a') as f:
            f.write('\n# Data directory\ndata/\n' if content else '# Data directory\ndata/\n')

if __name__ == "__main__":
    # Update .gitignore to exclude data directory
    update_gitignore()

    for taxi_type in ["yellow", "green"]:
        download_and_convert_files(taxi_type)

    con = duckdb.connect("taxi_rides_ny.duckdb")
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    for taxi_type in ["yellow", "green"]:
        con.execute(f"""
            CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
            SELECT * FROM read_parquet('data/{taxi_type}/*.parquet', union_by_name=true)
        """)

    con.close()
```

This script downloads yellow and green taxi data from 2019-2020, creates the `prod` schema, and loads the raw data into DuckDB. The download may take several minutes depending on your internet connection.

## Step 5: Test the dbt Connection

Verify dbt can connect to your DuckDB database:

```bash
dbt debug
```

## Step 6: Install dbt Power User Extension (VS Code Users)

If you're using Visual Studio Code, install the **dbt Power User** extension to enhance your dbt development experience.

### What is dbt Power User?

dbt Power User is a VS Code extension that provides:

* SQL syntax highlighting and formatting for dbt models
* Inline column-level lineage visualization
* Auto-completion for dbt models, sources, and macros
* Interactive documentation preview
* Model compilation and execution directly from the editor

### Why Not Use the Official dbt Extension?

dbt Labs released an official VS Code extension called [dbt Extension](https://marketplace.visualstudio.com/items?itemName=dbtLabsInc.dbt) powered by the new dbt Fusion engine. However, this extension **requires dbt Fusion** and does not support dbt Core.

Since we're using **dbt Core** with DuckDB for local development, we need the community-maintained **dbt Power User by AltimateAI** extension instead. This extension:

* Works seamlessly with dbt Core (not just dbt Cloud)
* Supports all dbt adapters, including DuckDB
* Is actively maintained and open source
* Provides a rich feature set for local development

### Installation

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X / Cmd+Shift+X)
3. Search for "dbt Power User"
4. Install **dbt Power User by AltimateAI** (not the dbt Labs version)

Alternatively, install it from the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user).

> [!NOTE]
> At this point, your local dbt environment is fully configured and ready to use. The next steps (running models, tests, and building documentation) will be covered in the tutorial videos.

## Additional Resources

* [DuckDB Documentation](https://duckdb.org/docs/)
* [dbt Documentation](https://docs.getdbt.com/)
* [dbt-duckdb Adapter](https://github.com/duckdb/dbt-duckdb)
* [NYC Taxi Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
