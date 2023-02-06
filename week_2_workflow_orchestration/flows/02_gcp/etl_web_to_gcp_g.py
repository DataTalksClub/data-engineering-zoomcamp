from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from random import randint
import os



@task(retries=3)
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read taxi data fro web into pandas DataFrame"""
    # if randint(0, 1) > 0:
    #     raise Exception

    df = pd.read_csv(dataset_url)
    rows_number = df.shape[0]
    print(f"Rows number = {rows_number}")

    return df

@task(log_prints=True)
def clean(color: str, df=pd.DataFrame) -> pd.DataFrame:
    """Fix dtype issues"""
    if color == "yellow":
        df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
        df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])
    elif color == "green":
        df["lpep_pickup_datetime"] = pd.to_datetime(df["lpep_pickup_datetime"])
        df["lpep_dropoff_datetime"] = pd.to_datetime(df["lpep_dropoff_datetime"])

    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    return df

@task()
def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
    """Write DataFrame out locally as parquet file"""
#    path = Path(f"~/data-engineering-zoomcamp/week_2_workflow_orchestration/data/{color}/{dataset_file}.parquet")
    path = Path(f"~/data/{dataset_file}.parquet")
    df.to_parquet(path, compression="gzip")
    return path

@task()
def write_gcs(path: Path, color: str, year: int, month: int) -> None:
    """Upload parquet file to GCS"""
 
    gcs_block = GcsBucket.load("zoom-gcs")    
    gcs_block.upload_from_path(from_path=f"/home/gosha/data/{color}_tripdata_{year}-{month:02}.parquet", to_path=f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet")
    return

@flow()
def etl_web_to_gcs() -> None:
    """Main ETL function"""
    color = "green"
    year = 2019
    month = 4
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"

    df = fetch(dataset_url)
    df_clean = clean(color, df)
    path = write_local(df_clean, color, dataset_file)
    write_gcs(path, color, year, month)

if __name__ == '__main__':
    etl_web_to_gcs()

