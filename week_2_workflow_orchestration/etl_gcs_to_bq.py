import pandas as pd
from pathlib import Path
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect.tasks import task_input_hash
from datetime import timedelta
from prefect_gcp import GcpCredentials


@task(log_prints=True)
def write_bq(df):
    #block criado com credentials
    gcp_credentials_block = GcpCredentials.load("zoom-gcp-creds")
    #função do dataframe para enviar para o big query
    df.to_gbq(
        destination_table="deteste.rides", #nomedoconjuntodedados.nomedatabela
        project_id="nytaxi-376623", #id ao criar o projeto no google
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append" #caso já exista tabela, será appended
    )


@task(log_prints=True, retries=3)
def extract_from_gcs(color,year,month):
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.get_directory(from_path=gcs_path)
    #gcs_block.download_object_to_path(from_path=gcs_path, to_path=f"{gcs_path}")
    #O primeiro (get.directory) copia todo o folder do GCS, enquanto o último um arquivo
    return Path(f"{gcs_path}")


@task(log_prints=True)
def transform(path):
    df = pd.read_parquet(path)
    print(f"pre missing values: {df['passenger_count'].isna().sum()}")
    df['passenger_count'].fillna(0, inplace=True)
    #df['passenger_count'] = df['passenger_count'].fillna(0)
    print(f"post missing values: {df['passenger_count'].isna().sum()}")
    return df


@flow()
def etl_gcs_to_bq():
    color = "yellow"
    year = 2021
    month = 2
    path = extract_from_gcs(color,year,month)
    df = transform(path)
    write_bq(df)


if __name__ == "__main__":
    etl_gcs_to_bq()
