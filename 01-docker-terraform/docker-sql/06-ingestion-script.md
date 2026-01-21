# Creating the Data Ingestion Script

**[↑ Up](README.md)** | **[← Previous](05-data-ingestion.md)** | **[Next →](07-pgadmin.md)**

Now let's convert the notebook to a Python script.

## Convert Notebook to Script

```bash
uv run jupyter nbconvert --to=script notebook.ipynb
mv notebook.py ingest_data.py
```

## The Complete Ingestion Script

See the `pipeline/` directory for the complete script with click integration. Here's the core structure:

```python
import pandas as pd
from sqlalchemy import create_engine
from tqdm.auto import tqdm

dtype = {
    "VendorID": "Int64",
    "passenger_count": "Int64",
    "trip_distance": "float64",
    "RatecodeID": "Int64",
    "store_and_fwd_flag": "string",
    "PULocationID": "Int64",
    "DOLocationID": "Int64",
    "payment_type": "Int64",
    "fare_amount": "float64",
    "extra": "float64",
    "mta_tax": "float64",
    "tip_amount": "float64",
    "tolls_amount": "float64",
    "improvement_surcharge": "float64",
    "total_amount": "float64",
    "congestion_surcharge": "float64"
}

parse_dates = [
    "tpep_pickup_datetime",
    "tpep_dropoff_datetime"
]
```

## Click Integration

The script uses `click` for command-line argument parsing:

```python
import click

@click.command()
@click.option('--pg-user', default='root', help='PostgreSQL user')
@click.option('--pg-pass', default='root', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-port', default=5432, type=int, help='PostgreSQL port')
@click.option('--pg-db', default='ny_taxi', help='PostgreSQL database name')
@click.option('--target-table', default='yellow_taxi_data', help='Target table name')
def run(pg_user, pg_pass, pg_host, pg_port, pg_db, target_table):
    # Ingestion logic here
    pass
```

## Running the Script

The script reads data in chunks (100,000 rows at a time) to handle large files efficiently without running out of memory.

Example usage:

```bash
uv run python ingest_data.py \
  --pg-user=root \
  --pg-pass=root \
  --pg-host=localhost \
  --pg-port=5432 \
  --pg-db=ny_taxi \
  --target-table=yellow_taxi_trips
```

**[↑ Up](README.md)** | **[← Previous](05-data-ingestion.md)** | **[Next →](07-pgadmin.md)**
