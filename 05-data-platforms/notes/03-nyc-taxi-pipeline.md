# 5.3 - Building an End-to-End Pipeline with NYC Taxi Data

## Architecture

Three-layered pipeline using DuckDB as a locally hosted database:

1. Ingestion layer: extract data and store in raw format
2. Staging layer: pre-process, clean, transform, join with lookup tables
3. Reports layer: aggregate data and run calculations

All assets have dependencies that create the data lineage Bruin uses for orchestration.

## Project setup

Initialize from the zoomcamp template:

```bash
bruin init zoomcamp my-taxi-pipeline
cd my-taxi-pipeline
```

Project structure:

```text
zoomcamp/
├── .bruin.yml
├── README.md
└── pipeline/
    ├── pipeline.yml
    └── assets/
        ├── ingestion/
        │   ├── trips.py
        │   ├── requirements.txt
        │   ├── payment_lookup.asset.yml
        │   └── payment_lookup.csv
        ├── staging/
        │   └── trips.sql
        └── reports/
            └── trips_report.sql
```

### .bruin.yml

```yaml
default_environment: default

environments:
  default:
    connections:
      duckdb:
        - name: duckdb-default
          path: duckdb.db
```

### pipeline.yml

```yaml
name: nyc_taxi
schedule: daily
start_date: "2022-01-01"
default_connections:
  duckdb: duckdb-default
variables:
  taxi_types:
    type: array
    items:
      type: string
    default: ["yellow"]
```

- `start_date`: when running a full refresh, process data starting from this date
- Custom variables: `taxi_types` lets you control which taxi types to ingest (yellow, green, or both)
- Variables can be overridden at runtime with `--var`

## Ingestion layer

### Python asset: trips.py

The Python asset connects to the NYC taxi API and extracts data.

```python
"""@bruin
name: ingestion.trips
type: python
image: python:3.11

materialization:
  type: table
  strategy: append

columns:
  - name: pickup_datetime
    type: timestamp
    description: "When the meter was engaged"
  - name: dropoff_datetime
    type: timestamp
    description: "When the meter was disengaged"
@bruin"""

import os
import json
import pandas as pd

def materialize():
    start_date = os.environ["BRUIN_START_DATE"]
    end_date = os.environ["BRUIN_END_DATE"]
    taxi_types = json.loads(os.environ["BRUIN_VARS"]).get("taxi_types", ["yellow"])

    # Generate list of months between start and end dates
    # Fetch parquet files from:
    # https://d37ci6vzurychx.cloudfront.net/trip-data/{taxi_type}_tripdata_{year}-{month}.parquet

    return final_dataframe
```

- `materialize()` returns a DataFrame; Bruin handles inserting it into the destination
- `append` strategy: each run inserts data without touching existing rows
- Uses `BRUIN_START_DATE` / `BRUIN_END_DATE` environment variables for the time window
- Uses `BRUIN_VARS` to read the `taxi_types` pipeline variable

### Seed file: payment_lookup.asset.yml

Seed files ingest data from local CSV files into the database.

```yaml
name: ingestion.payment_lookup
type: duckdb.seed
parameters:
  path: payment_lookup.csv
columns:
  - name: payment_type_id
    type: integer
    description: "Numeric code for payment type"
    primary_key: true
    checks:
      - name: not_null
      - name: unique
  - name: payment_type_name
    type: string
    description: "Human-readable payment type"
    checks:
      - name: not_null
```

payment_lookup.csv:

```csv
payment_type_id,payment_type_name
0,flex_fare
1,credit_card
2,cash
3,no_charge
4,dispute
5,unknown
6,voided_trip
```

Quality checks (`not_null`, `unique`) run automatically after the asset finishes.

### requirements.txt

```
pandas
requests
pyarrow
python-dateutil
```

Bruin handles the environment and installs dependencies locally within the pipeline.

## Staging layer

### SQL asset: staging/trips.sql

```sql
/* @bruin
name: staging.trips
type: duckdb.sql

depends:
  - ingestion.trips
  - ingestion.payment_lookup

materialization:
  type: table
  strategy: time_interval
  incremental_key: pickup_datetime
  time_granularity: timestamp

columns:
  - name: pickup_datetime
    type: timestamp
    primary_key: true
    checks:
      - name: not_null

custom_checks:
  - name: row_count_greater_than_zero
    query: |
      SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
      FROM staging.trips
    value: 1
@bruin */

SELECT
    t.pickup_datetime,
    t.dropoff_datetime,
    t.pickup_location_id,
    t.dropoff_location_id,
    t.fare_amount,
    t.taxi_type,
    p.payment_type_name
FROM ingestion.trips t
LEFT JOIN ingestion.payment_lookup p
    ON t.payment_type = p.payment_type_id
WHERE t.pickup_datetime >= '{{ start_datetime }}'
  AND t.pickup_datetime < '{{ end_datetime }}'
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY t.pickup_datetime, t.dropoff_datetime,
                 t.pickup_location_id, t.dropoff_location_id, t.fare_amount
    ORDER BY t.pickup_datetime
) = 1
```

- `time_interval` strategy: deletes rows in the time window, then inserts the query result
- The `WHERE` clause must filter to the same time window to avoid duplicates
- `QUALIFY ROW_NUMBER()` deduplicates using a composite key
- Dependencies on both `ingestion.trips` and `ingestion.payment_lookup` ensure this runs after ingestion

## Reports layer

### SQL asset: reports/trips_report.sql

```sql
/* @bruin
name: reports.trips_report
type: duckdb.sql

depends:
  - staging.trips

materialization:
  type: table
  strategy: time_interval
  incremental_key: trip_date
  time_granularity: date

columns:
  - name: trip_date
    type: date
    primary_key: true
  - name: taxi_type
    type: string
    primary_key: true
  - name: payment_type
    type: string
    primary_key: true
  - name: trip_count
    type: bigint
    checks:
      - name: non_negative
@bruin */

SELECT
    CAST(pickup_datetime AS DATE) AS trip_date,
    taxi_type,
    payment_type_name AS payment_type,
    COUNT(*) AS trip_count,
    SUM(fare_amount) AS total_fare,
    AVG(fare_amount) AS avg_fare
FROM staging.trips
WHERE pickup_datetime >= '{{ start_datetime }}'
  AND pickup_datetime < '{{ end_datetime }}'
GROUP BY 1, 2, 3
```

## Running the full pipeline

```bash
# Validate structure and definitions
bruin validate ./pipeline/pipeline.yml

# Run with a small date range for testing
bruin run ./pipeline/pipeline.yml --start-date 2022-01-01 --end-date 2022-02-01

# Full refresh
bruin run ./pipeline/pipeline.yml --full-refresh

# Query results
bruin query --connection duckdb-default --query "SELECT COUNT(*) FROM ingestion.trips"
```

Open the pipeline YAML file in the Bruin panel and view the lineage tab to see all assets and their dependencies. Execution order:

1. Ingestion assets run first (trips + lookup, in parallel)
2. Staging asset runs after both ingestion assets complete
3. Report asset runs after staging completes

## Materialization strategies summary

| Strategy | Behavior |
|----------|----------|
| `table` | Drop and recreate the table each time |
| `append` | Insert new data without touching existing rows |
| `merge` | Upsert based on key columns |
| `time_interval` | Delete rows in date range, then re-insert |
| `delete+insert` | Delete matching rows, then insert |
| `create+replace` | Create or replace the table |
