import pandas as pd
from pathlib import Path
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket

@task(retries = 3)
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read taxi data from web into pandas DataFrame"""
     # simulating failure to test retries
    # if randint(0, 1) == 1:
    #     raise Exception()
    df = pd.read_csv(dataset_url)
    return df

@task(log_prints = True)
def clean(df = pd.DataFrame) -> pd.DataFrame:
    """Fix some dtype issues"""
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
    print(df.head(2))
    print(f" Columns: {df.dtypes}")
    print(f"rows: {len(df) }")
    return df

@task(log_prints=True)
def write_local(df:pd.DataFrame, color:str, dataset_file: str) -> Path:
    """"write the dataframe out locally as a parquet file"""
    data_dir = f'data/{color}'
    Path(data_dir).mkdir(parents=True, exist_ok=True)
    path = Path(f'{data_dir}/{dataset_file}.parquet')
    df.to_parquet(path, compression='gzip')
    return path

@task(log_prints=True)
def write_gcs(path: Path) -> None:
    """Upload loacal parquet file to GCP"""
    gcs_block = GcsBucket.load("dezoomcamp")
    gcs_block.upload_from_path(from_path=path, to_path=path)
    return



@flow()
def etl_web_to_gcs() -> None:
    """The main ETL function"""
    color = 'yellow'
    year = 2021
    month = 2
    dataset_file = f'{color}_tripdata_{year}-{month:02}'
    dataset_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-02.csv.gz'
    
    #f'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz'

    df = fetch(dataset_url)
    df_clean = clean(df)
    path = write_local(df_clean, color, dataset_file)
    write_gcs(path)

if __name__ == '__main__':
    etl_web_to_gcs()

