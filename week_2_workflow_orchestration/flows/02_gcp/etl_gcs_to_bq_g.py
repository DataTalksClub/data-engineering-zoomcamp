from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(retries=3)
def extract_from_gcs(color: str, year: int, month: int) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"../data/")
    return Path(f"../data/{gcs_path}")

# @task()
# def transform(path: Path) -> pd.DataFrame:
#     """Data cleaning example"""
#     df = pd.read_parquet(path)
#     print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
#     df["passenger_count"].fillna(0, inplace=True)
#     print(f"post: missing passenger count: {df['passenger_count'].isna().sum()}")
#     return df

@task()
def write_bq(path: Path) -> None:
    """Write dataframe to BiqQuery"""
    df = pd.read_parquet(path)
    rows_number = df.shape[0]
    print(f"Rows number in {path} = {rows_number}")

    gcp_credentials_block = GcpCredentials.load("zoom-gcp-creds")

    df.to_gbq(
        destination_table="dezoomcamp.rides",
        project_id="de-trainig", 
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000, 
        if_exists="append"
    )


@flow
def etl_gcs_to_bq(year: int, month: int, color: str):
    """Main ETL flow to load data into Big Query"""
    # color="yellow"
    # year=2021
    # month=1

    path = extract_from_gcs(color, year, month)

#    df = transform(path)

    # write_bq(df)
    write_bq(path)


@flow()
def etl_parent_flow(
    months: list[int] = [1, 2], year: int = 2019, color: str = "yellow"
):
    for month in months:
        etl_gcs_to_bq(year, month, color)

if __name__ == '__main__':
    color = "yellow" 
    months = [2,3]
    year = 2019
    etl_parent_flow(months, year, color)




