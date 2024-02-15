import io
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import requests
import fsspec
import dlt
import duckdb

if 'utils' not in globals():
    from magic_zoomcamp.utils.shared import camel_to_snake
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

# obeserve the pattern
# - https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-01.parquet
# - https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-02.parquet
# - https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-11.parquet
# - https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-12.parquet

@data_loader
def load_data_from_api(*args, **kwargs):
    """

    """
    # setup the vars
    taxi_schema = pa.schema([
            ('VendorID', pa.int64()),
            ('lpep_pickup_datetime', pa.timestamp('us', tz='America/New_York')),
            ('lpep_dropoff_datetime', pa.timestamp('us', tz='America/New_York')),            
            ('passenger_count', pa.int64()),
            ('trip_distance', pa.float64()),
            ('RatecodeID', pa.int64()),
            ('store_and_fwd_flag', pa.string()),
            ('PULocationID', pa.int64()),
            ('DOLocationID', pa.int64()),
            ('payment_type', pa.int64()),
            ('fare_amount', pa.float64()),
            ('extra', pa.float64()),
            ('mta_tax', pa.float64()),
            ('tip_amount', pa.float64()),
            ('tolls_amount', pa.float64()),
            ('improvement_surcharge', pa.float64()),
            ('total_amount', pa.float64()),
            ('congestion_surcharge', pa.float64())
    ])

    months = range(1,13)
    year = 2022
    colour = 'green' # 'yellow'
    base_url="https://d37ci6vzurychx.cloudfront.net/trip-data"
    # dtc source for 2019-2021 does not have 2022 data 
    # ends at 2021-07 and only for csv.gz files, no parquet
    # base_url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

    # Create empty list to store DataFrames
    dataframes = []

    # Connect to local DuckDB
    # conn = duckdb.connect(database='ny_taxi_rides', read_only=False)

    # Iterate through months and download data
    for month in months:
        # print(month)
        
        filename = f"{colour}_tripdata_{year}-{month:02d}.parquet" # .csv.gz / parquet
        # print(filename)

        url = f"{base_url}/{filename}"
        # print(url)

        response = requests.get(url, stream=True)
        if response.status_code == 200:
            fs = fsspec.filesystem("http")
            with fs.open(url) as f:
                table = pq.read_table(f, schema=taxi_schema)

                # Append DataFrame to the list
                dataframes.append(table.to_pandas())
                print(f"Downloaded {filename} successfully!")
        
        else:
            print(f"Failed to download {filename}. Status code: {response.status_code}")

    # Concatenate DataFrames
    return pd.concat(dataframes, ignore_index=True)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
