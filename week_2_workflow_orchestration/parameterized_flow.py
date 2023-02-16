import pandas as pd
from pathlib import Path
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect.tasks import task_input_hash
from datetime import timedelta


@task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def write_gcs(path):
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.upload_from_path(from_path=f"{path}",to_path=path)
    return


@task(log_prints=True)
def write_local(df, color, dataset_file):
    path = Path(f"data/{color}/{dataset_file}.parquet")
    df.to_parquet(path, compression="gzip")
    return path


@task(log_prints=True)
def clean_data(df):
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
    return df


@task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def fetch(dataset_url):
    """Read taxi data from web into dataframe"""
    df = pd.read_csv(dataset_url, dtype={'passenger_count': 'float32',
       'trip_distance': 'float32',
       'RatecodeID': 'float32',
       'payment_type': 'float32',
       'fare_amount': 'float32',
       'extra': 'float32',
       'mta_tax': 'float32',
       'tip_amount': 'float32',
       'improvement_surcharge': 'float32',
       'total_amount': 'float32',
       'congestion_surcharge': 'float32',
       'PULocationID': 'int32',
       'DOLocationID': 'int32',
       'VendorID': 'float32',
       'tolls_amount': 'float32',})
    df.info()
    return df


@flow()
def etl_web_to_gcs(color,month,year):
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
    df = fetch(dataset_url)
    clean_df = clean_data(df)
    del[df]
    path_file = write_local(clean_df,color,dataset_file)
    del[clean_df]
    write_gcs(path_file)
    del[path_file]


@flow()
def etl_parameters(color="yellow",month=[1,2],year=2021):
    for month in month:
        etl_web_to_gcs(color,month,year)


if __name__ == "__main__":
    color = "yellow"
    month = [1,2]
    year = 2021
    etl_parameters(color,month,year)
