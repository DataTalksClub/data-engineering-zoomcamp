import io
import os
import requests
import pandas as pd

"""
Pre-reqs:
1. `pip install pandas pyarrow`
"""

init_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
init_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'

def download_parquet_locally(year, service, target_folder):
    """
    Downloads Parquet files from the specified URL and stores them in a local folder.

    Args:
        year (str): The year of the data to download.
        service (str): The type of taxi service (e.g., "green", "yellow").
        target_folder (str): The folder path where to store the downloaded files.
    """

    for i in range(12):
        # Construct parquet file name
        month = str(i+1).zfill(2)  # Zero-pad month for consistent naming
        parquet_file_name = f"{service}_tripdata_{year}-{month}.parquet"

        # Create target folder if it doesn't exist
        os.makedirs(target_folder, exist_ok=True)  # Ensures folders are created recursively

        # Build absolute file path
        full_file_path = os.path.join(init_url, parquet_file_name)

        # Download parquet file (if necessary)
        if not os.path.exists(full_file_path):
            os.system(f"wget {full_file_path} -O {parquet_file_name}")
            print(f"Downloaded Parquet: {full_file_path}")

        print(f"Local Parquet: {full_file_path}")  # Indicate local storage

# Example usage:

# Ejecuta el script con el argumento `--target_folder`

target_folder = "./parquet/"  # Replace with your desired folder path
download_parquet_locally('2019', 'fhv', target_folder)

