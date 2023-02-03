import os
from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from random import randint

import argparse

from pygments.lexer import default


@task(retries=3)
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read taxi data from web into pandas DataFrame"""
    # if randint(0, 1) > 0:
    #     raise Exception

    df = pd.read_csv(dataset_url)
    return df


@task(log_prints=True)
def clean(df: pd.DataFrame, datetime_columns_splitted) -> pd.DataFrame:
    """Fix dtype issues"""
    for col in datetime_columns_splitted:
        df[col] = pd.to_datetime(df[col])

    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    return df


@task()
def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
    """Write DataFrame out locally as parquet file"""
    os.makedirs(f"data/{color}")
    path = Path(f"data/{color}/{dataset_file}.parquet")
    df.to_parquet(path, compression="gzip")
    return path


@task()
def write_gcs(path: Path) -> None:
    """Upload local parquet file to GCS"""
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.upload_from_path(from_path=path, to_path=path)
    return


@flow()
def etl_web_to_gcs(params) -> None:
    """The main ETL function"""
    #color = "yellow"
    #year = 2021
    #month = 1

    color = params.color
    year = params.year
    month = params.month

    datetime_columns = params.datetime_columns

    datetime_columns_splitted = [x for x in datetime_columns.split(",") if x]  # to filter out empty strings

    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"

    df = fetch(dataset_url)
    df_clean = clean(df, datetime_columns_splitted)
    path = write_local(df_clean, color, dataset_file)
    write_gcs(path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--color', required=False, help='color of the taxi dataset', default="yellow")
    parser.add_argument('--year', type=int, required=False, help='year of taxi data', default=2021)
    parser.add_argument('--month',type=int, required=False, help='month of taxi data', default=1)
    parser.add_argument('--datetime_columns',type=str, required=False, help='datetime columns to convert to datetime ',
                        default="tpep_pickup_datetime,tpep_dropoff_datetime")

    args = parser.parse_args()

    etl_web_to_gcs(args)
