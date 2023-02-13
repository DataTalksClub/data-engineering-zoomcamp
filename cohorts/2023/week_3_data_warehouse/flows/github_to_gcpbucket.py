import os

# from pathlib import Path
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket


@task()
def create_paths(year: int, month: int) -> tuple:
    """Create path names using year and month inputs"""

    dataset_file = f"fhv_tripdata_{year}-{month:02}.csv.gz"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/{dataset_file}"

    return dataset_url, dataset_file


@task(retries=3)
def fetch(url: str, filename: str) -> None:
    """Read data from the web into pandas df"""
    os.system(f"wget {url} -O {filename}")


@task()
def write_gcs(filename: str, path: str) -> None:
    """Upload parquet files to GCS"""
    gcs_block = GcsBucket.load("prefect-gsc-bucket")
    gcs_block.upload_from_path(from_path=filename, to_path=path)


@flow()
def etl_to_gcs(year: int, month: int) -> None:
    """
    The main ETL
    """
    # https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-01.csv.gz

    url, filename = create_paths(year, month)
    fetch(url, filename)
    write_gcs(filename, f"data/fhv/{filename}")


@flow()
def etl_parent_flow(
    months: list[int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], year: int = 2019
):
    for month in months:
        etl_to_gcs(year, month)


if __name__ == "__main__":
    etl_parent_flow()
