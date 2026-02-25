"""@bruin

name: ingestion.trips
connection: duckdb-default

materialization:
  type: table
  strategy: append

secrets:
  - key: duckdb-default
    inject_as: duckdb-default

columns:
  - name: vendor_id
    type: BIGINT
  - name: tpep_pickup_datetime
    type: TIMESTAMP
  - name: tpep_dropoff_datetime
    type: TIMESTAMP
  - name: passenger_count
    type: DOUBLE
  - name: trip_distance
    type: DOUBLE
  - name: ratecode_id
    type: DOUBLE
  - name: store_and_fwd_flag
    type: VARCHAR
  - name: pu_location_id
    type: BIGINT
  - name: do_location_id
    type: BIGINT
  - name: payment_type
    type: BIGINT
  - name: fare_amount
    type: DOUBLE
  - name: extra
    type: DOUBLE
  - name: mta_tax
    type: DOUBLE
  - name: tip_amount
    type: DOUBLE
  - name: tolls_amount
    type: DOUBLE
  - name: improvement_surcharge
    type: DOUBLE
  - name: total_amount
    type: DOUBLE
  - name: congestion_surcharge
    type: DOUBLE

@bruin"""

import os
import json
import pandas as pd
import requests
from io import BytesIO
from datetime import datetime
import pandas as pd

def materialize():
    start_date = os.environ["BRUIN_START_DATE"]
    end_date = os.environ["BRUIN_END_DATE"]
    taxi_types = json.loads(os.environ["BRUIN_VARS"]).get("taxi_types", ["yellow"])

    # Generate list of months between start and end dates
    start = datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.strptime(end_date, "%Y-%m-%d")
    # Fetch parquet files from:
    # https://d37ci6vzurychx.cloudfront.net/trip-data/{taxi_type}_tripdata_{year}-{month}.parquet


    all_dfs = []

    # Generate list of months
    current = start.replace(day=1)
    while current <= end:
        year = current.year
        month = f"{current.month:02d}"

        for taxi_type in taxi_types:
            url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/{taxi_type}_tripdata_{year}-{month}.parquet"
            print(f"Fetching {url}")

            try:
                response = requests.get(url)
                response.raise_for_status()
                df = pd.read_parquet(BytesIO(response.content))
                all_dfs.append(df)
            except Exception as e:
                print(f"Failed to fetch {url}: {e}")

        # move to next month
        if current.month == 12:
            current = current.replace(year=current.year + 1, month=1)
        else:
            current = current.replace(month=current.month + 1)

    if not all_dfs:
        raise ValueError("No data fetched!")

    final_dataframe = pd.concat(all_dfs, ignore_index=True)

    return final_dataframe