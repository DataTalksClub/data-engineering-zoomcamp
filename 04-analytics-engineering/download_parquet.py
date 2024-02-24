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
#download_parquet_locally('2019', 'fhv', target_folder)




import os
import pandas as pd

def transform_parquet_data_types(input_folder, output_folder):
    """
    Reads Parquet files from the input folder, transforms data types, and stores them in the output folder.

    Args:
        input_folder (str): Path to the folder containing input Parquet files.
        output_folder (str): Path to the folder where the transformed Parquet files will be stored.
    """

    # Get list of Parquet files in the input folder
    parquet_files = [file for file in os.listdir(input_folder) if file.endswith('.parquet')]

    for file_name in parquet_files:
        # Read Parquet file
        file_path = os.path.join(input_folder, file_name)
        df = pd.read_parquet(file_path)

        # Define data types
        taxi_dtypes = {
            'dispatching_base_num': 'str',
            'PUlocationID': pd.Int64Dtype(),
            'DOlocationID': pd.Int64Dtype(),
            'SR_Flag': 'str',
            'Affiliated_base_number': 'str'
        }

        # Parse dates

        # Apply data types and parse dates
        df = df.astype(taxi_dtypes)

        # Define output file path
        output_file_path = os.path.join(output_folder, file_name)

        # Write modified DataFrame to Parquet
        df.to_parquet(output_file_path, index=False)

        print(f"Modified Parquet saved: {output_file_path}")

# Example usage:

input_folder = "./parquet"  # Replace with the path to your input Parquet files
output_folder = "./output_parquet/"  # Replace with the path where you want to store the modified Parquet files
transform_parquet_data_types(input_folder, output_folder)
