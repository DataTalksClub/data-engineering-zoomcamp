from pathlib import Path
import pandas as pd
from prefect import task, flow
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(log_prints=True, retries=3)
def extract_from_gcs(color:str, year:int, month:int) -> Path:
    """Extract data from GCS and download."""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load("nytaxi-zoomcap")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"data/download")
    return Path(f"data/download")


@task(log_prints=True)
def transform(path: Path) -> pd.DataFrame:
    """Transform data.
    
    Args:
        path (Path): path to file to transform
    """
    print(f"\n\n Getting data from path: {path}...\n\n")
    df = pd.read_parquet(path)
    
    print(f"rows: {len(df)}")
    
    #print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    
    #df["passenger_count"].fillna(0, inplace=True)
    
    #print(f"post: missing passenger count: {df['passenger_count'].isna().sum()}")
    
    return df


@task(log_prints=True, retries=3)
def write_to_bq(df: pd.DataFrame) -> None:
    """Write data to BigQuery.
    
    Args:
        df (pandas.DataFrame): dataframe to write
    """
    credentials = GcpCredentials.load("nytaxi-gcp-creds")
    
    df.to_gbq(
        destination_table="nytaxi_zoomcamp.rides",
        project_id="intense-jet-375817",
        if_exists="append",
        credentials=credentials.get_credentials_from_service_account(),
        chunksize=100000
    )


@flow(name='ETL GCS to BQ', log_prints=True)
def etl_gcs_to_bq( 
    month: int = 1,
    year: int = 2021,
    color:str = "yellow"):
    """ETL data from GCS to BigQuery."""
    path = extract_from_gcs(color, year, month)
    df = transform(path)
    write_to_bq(df)
    
@flow()
def etl_parent_flow(
    months: list[int] = [1,2],
    year: int = 2021,
    color:str = "yellow"
):
    for month in months:
        print(f"Running ETL for month {month}...")
        etl_gcs_to_bq(year, month, color)


if __name__ == "__main__":
    color='yellow'
    year=2021
    months = [1,2]
    etl_parent_flow(months, year, color)