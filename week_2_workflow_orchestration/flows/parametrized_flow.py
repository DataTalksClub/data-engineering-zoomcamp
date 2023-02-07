from pathlib import Path
import pandas as pd
from prefect import task, flow
from prefect_gcp.cloud_storage import GcsBucket
from random import randint
from prefect.tasks import task_input_hash
from datetime import timedelta


@task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def fetch(url:str) -> pd.DataFrame:
    """Fetch data from url.
    
    Args:
        url (str): csv url
    """
    
    print(f'fetching data from {url}...')
    df = pd.read_csv(url)
    
    return df


@task(log_prints=True)
def clean(df: pd.DataFrame) -> pd.DataFrame:
    """Transform data.
    
    Args:
        df (pandas.DataFrame): dataframe to transform
    """
    
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
    
    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    
    return df


@task(log_prints=True)
def write_local(df: pd.DataFrame, color:str, dataset_file:str) -> Path:
    """Write data to local file in parquet format.
    
    Args:
        df (pandas.DataFrame): dataframe to write
    """
    path = Path(f'data/{color}/{dataset_file}.parquet')
    
    df.to_parquet(path, compression='gzip')
    
    return path


@task(log_prints=True, retries=3)
def write_gcs(path: Path) -> None:
    """Write data to GCS.
    
    Args:
        path (Path): path to file to write
    """
    gcs_block = GcsBucket.load("nytaxi-zoomcap")
    gcs_block.upload_from_path(
        from_path=path,
        to_path=path
    )
        
    print(f'uploaded {path.name} to GCS')
    return 


@flow(name='ETL Web to GCS', log_prints=True)
def etl_web_to_gcs(year:int, month:int, color:str) -> None:
    """ETL data from web to GCS. Main ETL function"""
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
    
    df = fetch(dataset_url)
    data = clean(df)
    path = write_local(data, color, dataset_file)
    write_gcs(path)
   

@flow()
def etl_parent_flow(
    months: list[int] = [1,2],
    year: int = 2021,
    color:str = "yellow"
):
    for month in months:
        print(f"Running ETL for month {month}...")
        etl_web_to_gcs(year, month, color)
    


if __name__ == '__main__':
    months = [1,2,3]
    color = "yellow"
    year = 2021
    etl_parent_flow(months, year, color) 