import os
from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from random import randint


from typing import Union
import argparse
import yaml

from google.cloud import storage

from pygments.lexer import default
BUCKET = os.environ.get("GCP_GCS_BUCKET", "prefect-de-zoomcamp_magnetic-energy-375219")

DEFAULT_BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"


@task(log_prints=True)
def enforce_schema(df: pd.DataFrame, color: str, dir='/home/michal/Projects/data-engineering-zoomcamp/cohorts/2023/week_2_workflow_orchestration/code/schemas/data_schemas.yaml') -> pd.DataFrame:
    df.columns = df.columns.str.lower()

    with open(dir, 'rb') as f:
        color_schema = yaml.safe_load(f)[color]
        color_schema_lower = {k.lower(): v for k, v in color_schema.items()}
        color_schema_lower

    print(f'columns present in dataframe before enforcing schema: {df.dtypes}')
    print(f'Working with schema for dataset {color}')
    print(color_schema_lower)

    enforced_df = df.astype(color_schema_lower)
    if color == 'yellow':
        enforced_df = enforced_df.drop(columns=['airport_fee'], errors='ignore')
    return enforced_df

@task(retries=3)
def fetch(dataset_url: str, encoding='utf-8') -> pd.DataFrame:
    """Read taxi data from web into pandas DataFrame"""
    # if randint(0, 1) > 0:
    #     raise Exception

    df = pd.read_csv(dataset_url, encoding=encoding)
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
def write_local(df: pd.DataFrame, color: str, dataset_file: str, output_format: str) -> Path:
    """Write DataFrame out locally as csv/parquet file"""
    if output_format not in ('csv', 'parquet'):
        raise ValueError(f"Format: {output_format} not supported.")

    os.makedirs(f"data/{color}", exist_ok=True)
    path = Path(f"data/{color}/{dataset_file}.{output_format}")
    if output_format == 'csv':
        df.to_csv(path, compression="gzip", index=False)
    elif output_format == 'parquet':
        df.to_parquet(path, compression="gzip", index=False)
    else:
        # should have been raised earlier
        raise ValueError(f"Format: {output_format} not supported.")

    return path


@task()
def write_gcs(path: Path, color: str) -> None:
    """Upload local parquet file to GCS"""
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.upload_from_path(from_path=path, to_path=path)
    return


@task()
def write_gcs_without_gcs_block(path: Path, color: str) -> None:
    """Upload local parquet file to GCS"""
    #object_name = f"{color}/{path}"
    object_name = f"{path}"

    storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(BUCKET)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(path)

    return


@flow(log_prints=True)
def etl_web_to_gcs(base_url: str , encoding: str="utf-8", color: str = "yellow", year: int = 2021, month: int = 1,
                   input_format: str ='csv.gz', output_format: str ='csv', fast_upload: bool =True) -> None:
    """The main ETL function"""

    #print(f"datetime_columns: {datetime_columns}")
    #datetime_columns_splitted = [x for x in datetime_columns.split(",") if x]  # to filter out empty strings
    #print(f"datetime_columns_splitted: {datetime_columns_splitted}")

    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"{DEFAULT_BASE_URL}/{color}/{dataset_file}.{input_format}"

    df = fetch(dataset_url, encoding=encoding)
    enforced_df = enforce_schema(df, color)
    # df_clean = clean(df, datetime_columns)
    path = write_local(enforced_df, color, dataset_file, output_format)
    if fast_upload:
        write_gcs(path, color)
    else:
        write_gcs_without_gcs_block(path, color)


@flow(name="etl_parent_flow_web_to_gcs", log_prints=True)
def etl_parent_flow(
    base_url: str = DEFAULT_BASE_URL,
    months: Union[list[int], str] = [1, 2], encoding: str = "utf-8", year: int = 2021, color: str = "yellow",
    input_format: str ='csv.gz', output_format: str ='csv', fast_upload: bool = True
):
    if months == "*":
        months = list(range(1, 13))
    for month in months:
        etl_web_to_gcs(base_url, encoding, color, year, month, input_format, output_format, fast_upload)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')


    parser.add_argument('--base_url', required=False, help='Base url for getting the data',
                        default=DEFAULT_BASE_URL)
    parser.add_argument('--encoding', required=False, help='Encoding of loaded files',
                        default='utf-8')
    parser.add_argument('--color', required=False, help='color of the taxi dataset', default="yellow")
    parser.add_argument('--year', type=int, required=False, help='year of taxi data', default=2021)
    parser.add_argument('--month', type=int, required=False, help='month of taxi data', default=1)
    parser.add_argument('--output_format', type=str, required=False, help='Output format to save data', default='csv')

    args = parser.parse_args()

    base_url = args.base_url
    encoding = args.encoding
    color = args.color
    year = args.year
    month = args.month
    output_format = args.output_format

    etl_web_to_gcs(base_url, encoding, color, year, month, output_format)
