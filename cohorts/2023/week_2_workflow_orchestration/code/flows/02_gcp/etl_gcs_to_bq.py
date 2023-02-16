import os
from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials

from typing import Union

GCP_PROJECT = os.getenv("PROJECT_ID", default="magnetic-energy-375219")


@task(retries=3)
def extract_from_gcs(color: str, year: int, month: int, input_format: str = "csv" ) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.{input_format}"
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"../data/")
    return Path(f"../data/{gcs_path}")


@task()
def transform(path: Path, input_format, input_encoding='utf-8') -> pd.DataFrame:
    """Data cleaning example"""

    if input_format == 'csv':
        df = pd.read_csv(path, encoding=input_encoding)
    elif input_format == 'parquet':
        df = pd.read_parquet(path, encoding=input_encoding)
    else:
        # should have been raised earlier
        raise ValueError(f"Format: {input_format} not supported.")

    #df = pd.read_parquet(path)
    print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    # df["passenger_count"].fillna(0, inplace=True)
    # print(f"post: missing passenger count: {df['passenger_count'].isna().sum()}")
    return df


@task()
def write_bq(df: pd.DataFrame, schema: str = "dezoomcamp", table_name: str = "yellow_tripdata") -> None:
    """Write DataFrame to BiqQuery"""

    gcp_credentials_block = GcpCredentials.load("zoom-gcp-creds")

    df.to_gbq(
        destination_table=f"{schema}.{table_name}",
        project_id=GCP_PROJECT,
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append",
    )


@flow(log_prints=True)
def etl_gcs_to_bq(year: int, month: int, color: str, dataset_schema: str = "dezoomcamp",
                  input_format: str = 'csv', input_encoding: str = "utf-8"
                  ) -> int:
    """Main ETL flow to load data into Big Query"""
    path = extract_from_gcs(color, year, month, input_format=input_format)
    df: pd.DataFrame = transform(path, input_format=input_format, input_encoding=input_encoding)
    write_bq(df, schema=dataset_schema, table_name=f"{color}_tripdata")
    df_len = df.shape[0]
    print(f"[year={year}, month={month}, color={color}] Rows processed: {df_len}")
    return df_len


@flow(log_prints=True)
def etl_gcs_to_bq_parent_flow(
        months: Union[list[int], str] = [1, 2], year: int = 2021, color: str = "yellow",
        dataset_schema: str = "dezoomcamp", input_format: str = 'csv', input_encoding: str = "utf-8"
):
    if months == "*":
        months = list(range(1, 13))
    total_rows_processed = 0
    for month in months:
        total_rows_processed += etl_gcs_to_bq(year, month, color, dataset_schema,
                                              input_format=input_format, input_encoding=input_encoding)
    print(f":Total rows processed: {total_rows_processed}")


if __name__ == "__main__":
    etl_gcs_to_bq()
