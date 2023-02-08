from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(log_prints=True)
def extract_from_gcs(color: str, year: int, month: int) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load('prefect-gsc-bucket')
    gcs_block.get_directory(from_path=gcs_path, local_path = f"data/")
    return Path(f"{gcs_path}")

@task(log_prints=True)
def transform(path: Path) -> pd.DataFrame:
    """Apply a small transformation to the df"""
    df = pd.read_parquet(path)
    print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    df['passenger_count'].fillna(0, inplace=True)
    print(f"post: missing passenger count: {df['passenger_count'].isna().sum()}")
    return df


@task(log_prints=True)
def write_bq(df: pd.DataFrame) -> None:
    """Write dataframe to bigquery"""

    gcp_creds = GcpCredentials.load("gcs-bucket")

    df.to_gbq(
        destination_table='dtc-de-course-375921.trips_data_all.rides',
        project_id="dtc-de-course-375921",
        credentials=gcp_creds.get_credentials_from_service_account(),
        chunksize=500_000, 
        if_exists="append"
    )


@flow(name="ETL GCS to BigQuery") 
def etl_gcs_to_bq():
    """ Main ETL flow to load data into Big Query """
    color = "green"
    year = 2020
    month = 1

    path = extract_from_gcs(color, year, month)
    df = transform(path)
    write_bq(df)


if __name__ == "__main__":
    etl_gcs_to_bq()