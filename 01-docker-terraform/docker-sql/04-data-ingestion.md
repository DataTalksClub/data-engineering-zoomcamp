# NY Taxi Dataset and Data Ingestion

**[↑ Up](README.md)** | **[← Previous](03-postgres-docker.md)** | **[Next →](05-ingestion-script.md)**

We will now create a Jupyter Notebook `notebook.ipynb` file which we will use to read a CSV file and export it to Postgres.

## Setting up Jupyter

Install Jupyter:

```bash
uv add --dev jupyter
```

Let's create a Jupyter notebook to explore the data:

```bash
uv run jupyter notebook
```

## The NYC Taxi Dataset

We will use data from the [NYC TLC Trip Record Data website](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page).

Specifically, we will use the [Yellow taxi trip records CSV file for January 2021](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz).

This data used to be csv, but later they switched to parquet. We want to keep using CSV because we need to do a bit of extra pre-processing (for the purposes of learning it).

A dictionary to understand each field is available [here](https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf).

> Note: The CSV data is stored as gzipped files. Pandas can read them directly.

## Explore the Data

Create a new notebook and run:

```python
import pandas as pd

# Read a sample of the data
prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/'
df = pd.read_csv(prefix + 'yellow_tripdata_2021-01.csv.gz', nrows=100)

# Display first rows
df.head()

# Check data types
df.dtypes

# Check data shape
df.shape
```

### Handling Data Types

We have a warning:

```
/tmp/ipykernel_25483/2933316018.py:1: DtypeWarning: Columns (6) have mixed types. Specify dtype option on import or set low_memory=False.
```

So we need to specify the types:

```python
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

df = pd.read_csv(
    prefix + 'yellow_tripdata_2021-01.csv.gz',
    nrows=100,
    dtype=dtype,
    parse_dates=parse_dates
)
```

## Ingesting Data into Postgres

In the Jupyter notebook, we create code to:

1. Download the CSV file
2. Read it in chunks with pandas
3. Convert datetime columns
4. Insert data into PostgreSQL using SQLAlchemy

### Install SQLAlchemy

```bash
uv add sqlalchemy psycopg2-binary
```

### Create Database Connection

```python
from sqlalchemy import create_engine
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
```

### Get DDL Schema

```python
print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))
```

Output:

```sql
CREATE TABLE yellow_taxi_data (
    "VendorID" BIGINT,
    tpep_pickup_datetime TIMESTAMP WITHOUT TIME ZONE,
    tpep_dropoff_datetime TIMESTAMP WITHOUT TIME ZONE,
    passenger_count BIGINT,
    trip_distance FLOAT(53),
    "RatecodeID" BIGINT,
    store_and_fwd_flag TEXT,
    "PULocationID" BIGINT,
    "DOLocationID" BIGINT,
    payment_type BIGINT,
    fare_amount FLOAT(53),
    extra FLOAT(53),
    mta_tax FLOAT(53),
    tip_amount FLOAT(53),
    tolls_amount FLOAT(53),
    improvement_surcharge FLOAT(53),
    total_amount FLOAT(53),
    congestion_surcharge FLOAT(53)
)
```

### Create the Table

```python
df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')
```

`head(n=0)` makes sure we only create the table, we don't add any data yet.

## Ingesting Data in Chunks

We don't want to insert all the data at once. Let's do it in batches and use an iterator for that:

```python
df_iter = pd.read_csv(
    ...
    iterator=True,
    chunksize=100000
)
```

### Iterate Over Chunks

```python
for df_chunk in df_iter:
    print(len(df_chunk))
```

### Inserting Data

```python
df_chunk.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')
```

### Complete Ingestion Loop

```python
first = True

for df_chunk in df_iter:

    if first:
        # Create table schema (no data)
        df_chunk.head(0).to_sql(
            name="yellow_taxi_data",
            con=engine,
            if_exists="replace"
        )
        first = False
        print("Table created")

    # Insert chunk
    df_chunk.to_sql(
        name="yellow_taxi_data",
        con=engine,
        if_exists="append"
    )

    print("Inserted:", len(df_chunk))
```

### Alternative Approach (Without First Flag)

```python
first_chunk = next(df_iter)

first_chunk.head(0).to_sql(
    name="yellow_taxi_data",
    con=engine,
    if_exists="replace"
)

print("Table created")

first_chunk.to_sql(
    name="yellow_taxi_data",
    con=engine,
    if_exists="append"
)

print("Inserted first chunk:", len(first_chunk))

for df_chunk in df_iter:
    df_chunk.to_sql(
        name="yellow_taxi_data",
        con=engine,
        if_exists="append"
    )
    print("Inserted chunk:", len(df_chunk))
```

## Adding Progress Bar

Add `tqdm` to see progress:

```bash
uv add tqdm
```

Put it around the iterable:

```python
from tqdm.auto import tqdm

for df_chunk in tqdm(df_iter):
    ...
```

## Verify the Data

Connect to it using pgcli:

```bash
uv run pgcli -h localhost -p 5432 -u root -d ny_taxi
```

And explore the data.

**[↑ Up](README.md)** | **[← Previous](03-postgres-docker.md)** | **[Next →](05-ingestion-script.md)**
