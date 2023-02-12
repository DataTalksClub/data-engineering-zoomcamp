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

@task()
def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
    """Write DataFrame out locally as csv file"""
    path = Path(f"~/data/{dataset_file}.csv.gz")
    df.to_csv(path, compression="gzip")
    return path

@task()
def write_gcs(path: Path, color: str, year: int, month: int) -> None:
    """Upload csv file to GCS"""
 
    gcs_block = GcsBucket.load("zoom-gcs")    
    gcs_block.upload_from_path(from_path=f"/home/gosha/data/{color}_tripdata_{year}-{month:02}.csv.gz", to_path=f"data/{color}/{color}_tripdata_{year}-{month:02}.csv.gz")
    return

@flow
def etl_web_to_gcs() -> None:
    """Main ETL function"""
    color = "fhv"
    year = 2019
    months = list(range(1,13))
    
    for month in months:
        dataset_file = f"{color}_tripdata_{year}-{month:02}"
        dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
        df = fetch(dataset_url)
        path = write_local(df, color, dataset_file)
    # df_clean = clean(color, df)

        write_gcs(path, color, year, month)

if __name__ == '__main__':
    etl_web_to_gcs()