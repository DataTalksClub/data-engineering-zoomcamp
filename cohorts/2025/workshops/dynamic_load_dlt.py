import json
import os
import toml
import requests
import dlt
from dlt.sources.filesystem import filesystem, read_parquet
from google.cloud import storage

# Load the TOML file
# the TOML file should follow below format:
#[credentials]
#project_id = "your project id"
#private_key = "your sevice account key"
#client_email = "email"
config = toml.load("secrets.toml")

# Set environment variables
os.environ["CREDENTIALS__PROJECT_ID"] = config["credentials"]["project_id"]
os.environ["CREDENTIALS__PRIVATE_KEY"] = config["credentials"]["private_key"]
os.environ["CREDENTIALS__CLIENT_EMAIL"] = config["credentials"]["client_email"]

# Initialize GCS client
storage_client = storage.Client.from_service_account_json("google_credentials.json")
bucket_name = "dlt_bucket_test"  # Replace with your GCS bucket name
bucket = storage_client.bucket(bucket_name)

# Function to generate URLs based on user input for the date range and trip color
def generate_urls(color, start_year, end_year, start_month, end_month):
    base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/"
    urls = []

# Generate the list of URLs based on the specified date range and color

    for year in range(start_year, end_year + 1):
        for month in range(start_month, end_month + 1):
            # Format the month to ensure two digits
            month_str = f"{month:02d}"
            url = f"{base_url}{color}_tripdata_{year}-{month_str}.parquet"
            #https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2020-01.parquet
            urls.append(url)

    return urls

# User input for time range and trip color
color = input("Enter color (green, yellow): ").lower()  
start_year = int(input("Enter the start year (e.g., 2019): "))
end_year = int(input("Enter the end year (e.g., 2022): "))
start_month = int(input("Enter the start month (1-12): "))
end_month = int(input("Enter the end month (1-12): "))

# Generate URLs based on user input
urls = generate_urls(color, start_year, end_year, start_month, end_month)


# Debug: Print generated URLs
print("Generated URLs:")
for url in urls:
    print(url)

# Download files and upload them to GCS
gcs_files = []
for url in urls:
    file_name = url.split("/")[-1]  # Extract the file name from the URL
    gcs_blob = bucket.blob(file_name)

    print(f"Downloading {url} and uploading to GCS as {file_name}")
    response = requests.get(url)
    gcs_blob.upload_from_string(response.content)
    gcs_files.append(f"gs://{bucket_name}/{file_name}")

@dlt.resource(name="rides", write_disposition="replace")
def parquet_source():
    # Use filesystem to load files from GCS and apply read_parquet transformation
    files = filesystem(bucket_url="gs://dlt_bucket_test/", file_glob="*.parquet")
    reader = (files | read_parquet()).with_name("tripdata")

    # Iterate through the rows from the reader and yield them
    row_count = 0
    for row in reader:
        row_count += 1
        if row_count <= 5:  # debugging
            print(f"Yielding row: {row}")
        yield row
    print(f"Total rows yielded: {row_count}")

# Create the pipeline
pipeline = dlt.pipeline(
    pipeline_name="test_taxi",
    dataset_name="taxi_data",
    destination="bigquery"
)

# Run the pipeline
info = pipeline.run(parquet_source())
print(info)


# Another approach without downloading the parquet. It would directly load to bigquery.

import dlt
import requests
import pandas as pd
import pyarrow.parquet as pq
import io
import os
from google.cloud import bigquery

# set the GOOGLE_APPLICATION_CREDENTIALS environment variable in your system.  

# Base URL for the Parquet files
BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-"
MONTHS = [f"{i:02d}" for i in range(1, 7)]

# Define a dlt resource for fetching Parquet data
@dlt.resource(name="ny_taxi_dlt", write_disposition="replace")
def paginated_getter():
    """Fetches and yields monthly Parquet data as Pandas DataFrames."""

    for month in MONTHS:
        url = f"{BASE_URL}{month}.parquet"
        
        try:
            # Fetch the Parquet file in streaming mode
            with requests.get(url, stream=True) as response:
                response.raise_for_status()  # Raise an error for failed requests

                # Read file in chunks and store in a buffer
                buffer = io.BytesIO()
                for chunk in response.iter_content(chunk_size=1024 * 1024):  # Read in 1MB chunks
                    buffer.write(chunk)

                buffer.seek(0)  # Reset buffer position

                # Read Parquet file using pyarrow and convert to Pandas DataFrame
                table = pq.read_table(buffer)

                print(f'Got month {month} with {len(table)} records')

                if table.num_rows > 0:  # If data exists, yield it
                    yield table
                else:
                    break  # Stop if no more data

        except Exception as e:
            print(f"Failed to fetch data for month {month}: {e}")

# Create and configure the dlt pipeline
pipeline = dlt.pipeline(
    pipeline_name="ny_taxi_pipeline_dlt",
    destination="bigquery",
    dataset_name="ny_taxi_parquet_dlt_8",
    dev_mode=True
)

# Run the pipeline and load data into BigQuery
load_info = pipeline.run(paginated_getter())

# Print load info and normalization details
print(load_info)