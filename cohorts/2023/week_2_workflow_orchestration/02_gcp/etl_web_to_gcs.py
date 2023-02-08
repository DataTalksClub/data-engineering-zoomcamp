from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect.tasks import task_input_hash


@task(retries=3, cache_key_fn=task_input_hash)
def fetch(url: str) -> pd.DataFrame:
    """Read data from the web into pandas df"""
    df = pd.read_csv(url)
    return df


@task(log_prints=True)
def clean(df: pd.DataFrame) -> pd.DataFrame:
    """Clean up a dataframe"""
    try:
        df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
        df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])
    except Exception as e: 
        print("No tpep")

    try: 
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
    except Exception as e:
        print("No lpep")
        
    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    return df


@task()
def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
    """Write dataframe out as local parquet file"""

    path = f"data/{color}/{dataset_file}.parquet"
    df.to_parquet(path, compression="gzip")
    return path


@task()
def write_gcs(path: Path) -> None:
    """Upload parquet files to GCS"""
    gcs_block = GcsBucket.load("prefect-gsc-bucket")
    gcs_block.upload_from_path(from_path=path, to_path=path)


@flow()
def etl_to_gcs():
    """
    The main ETL
    """

    color = "green"
    year = 2020
    month = 1
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"

    df = fetch(dataset_url)
    df = clean(df)
    path = write_local(df, color, dataset_file)
    write_gcs(path)


if __name__ == "__main__":
    etl_to_gcs()
