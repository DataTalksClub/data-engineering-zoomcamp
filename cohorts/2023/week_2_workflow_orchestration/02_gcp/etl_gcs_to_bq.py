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
    gcs_block.get_directory(from_path=gcs_path, local_path="cohorts/2023/week_2_workflow_orchestration/02_gcp")
    return Path(f"{gcs_path}")


@task(log_prints=True)
def write_bq(df: pd.DataFrame) -> None:
    """Write dataframe to bigquery"""

    gcp_creds = GcpCredentials.load("gcs-bucket")

    df.to_gbq(
        destination_table='dtc-de-course-375921.trips_data_all.rides', # rides == yellow!
        project_id="dtc-de-course-375921",
        credentials=gcp_creds.get_credentials_from_service_account(),
        chunksize=500_000, 
        if_exists="append"
    )


@flow(name="ETL GCS to BigQuery") 
def etl_gcs_to_bq(year: int, month: int, color: str) -> None:
    """ Main ETL flow to load data into Big Query """
    path = extract_from_gcs(color, year, month)
    df = pd.read_parquet(path)
    write_bq(df)

@flow(name="GCS to BQ Parent flow")
def etl_parent_flow(months: list[int] = [2,3], year: int = 2019, color: str = "yellow"):
    for month in months: 
        etl_gcs_to_bq(year, month, color)


if __name__ == "__main__":
    color= "yellow"
    months = [2,3]
    etl_gcs_to_bq(months)