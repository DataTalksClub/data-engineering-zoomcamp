import pandas as pd
from pathlib import Path
from prefect import flow, task 
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(retries=3)
def extract_from_gcs(color:str, year:int, month: int) -> Path:
    """"Download Trip data from GCS"""
    gcs_path =  f'data/{color}/{color}_tripdata_{year}-{month:02}.parquet'
    gcs_block = GcsBucket.load("dezoomcamp")
    gcs_block.get_directory(from_path=gcs_path, local_path='./')
    return Path(gcs_path)

@task(log_prints=True)
def transform(path: Path) -> pd.DataFrame:
    df = pd.read_parquet(path)
    print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    df["passenger_count"].fillna(0, inplace = True)
    print(f"post: missing passenger count: {df['passenger_count'].isna().sum()} ")
    return df

@task()
def write_bq(df: pd.DataFrame) -> None:
    """Write the data into bigquery"""
    gcp_credentials_block = GcpCredentials.load("dezoomcampcreds")
    df.to_gbq(
        destination_table= "de_zoomcamp.rides",
        project_id= 'dtc-de-375821',
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=5000,
        if_exists="append",     
    )

@flow()
def etl_gcs_to_bq():
    """THis is our main etl flow to load data from cloud storage to big query"""
    color = "yellow"
    year=2021
    month=2
    path = extract_from_gcs(color, year, month)
    df = transform(path)
    write_bq(df)



if __name__ == "__main__":
    etl_gcs_to_bq()
