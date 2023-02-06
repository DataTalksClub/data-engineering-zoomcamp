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
    return df

@task(log_prints=True)
def clean(df=pd.DataFrame) -> pd.DataFrame:
    """Fix dtype issues"""
    df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
    df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])
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
def write_gcs(path: Path, color: str) -> None:
    """Upload parquet file to GCS"""
 
    gcs_block = GcsBucket.load("zoom-gcs")    
    gcs_block.upload_from_path(from_path=f"/home/gosha/data/yellow_tripdata_2021-01.parquet", to_path="data/{color}/yellow_tripdata_2021-01.parquet")
    return

@flow()
def etl_web_to_gcs() -> None:
    """Main ETL function"""
    color = "green"
    year = 2020
    month = 1
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"

    df = fetch(dataset_url)
    df_clean = clean(df)
    path = write_local(df_clean, color, dataset_file)
    write_gcs(path, color)

if __name__ == '__main__':
    etl_web_to_gcs()

