import json
import os
import toml
import requests
import dlt
from dlt.sources.filesystem import filesystem, read_parquet
from google.cloud import storage
import io
import pyarrow.parquet as pq

# Load the TOML file
# the TOML file should follow below format:
#[credentials]
#project_id = "your project id"
#private_key = "your sevice account key"
#client_email = "email"
config = toml.load("./.dlt/secrets.toml")

# Set environment variables
os.environ["CREDENTIALS__PROJECT_ID"] = config["credentials"]["project_id"]
os.environ["CREDENTIALS__PRIVATE_KEY"] = config["credentials"]["private_key"]
os.environ["CREDENTIALS__CLIENT_EMAIL"] = config["credentials"]["client_email"]

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


dlt_method = input("Choose loading method: 1 for GCS -> Bigquery, 2 for Direct Web -> Bigquery: ")

if dlt_method == "1":

    # Initialize GCS client
    storage_client = storage.Client.from_service_account_json("gcs.json")
    bucket_name = input("Enter the GCS bucket name: ")  # Replace with your GCS bucket name
    bucket = storage_client.bucket(bucket_name)

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
        files = filesystem(bucket_url=f"gs://{bucket_name}/", file_glob="*.parquet")
        reader = (files | read_parquet()).with_name("tripdata")

        # Iterate through the rows from the reader and yield them
        row_count = 0
        for row in reader:
            row_count += 1
            yield row
        print(f"Total rows yielded: {row_count}")

elif dlt_method == "2":
    # Alternative method: Streaming Parquet files directly from the web
    @dlt.resource(name="ny_taxi_dlt", write_disposition="replace")
    def paginated_getter():
        for url in urls:
            try:
                with requests.get(url, stream=True) as response:
                    response.raise_for_status()
                    buffer = io.BytesIO()
                    for chunk in response.iter_content(chunk_size=1024 * 1024):  # 1MB chunks
                        buffer.write(chunk)
                    buffer.seek(0)
                    table = pq.read_table(buffer)
                    print(f'Got data from {url} with {table.num_rows} records')
                    if table.num_rows > 0:
                        yield table
            except Exception as e:
                print(f"Failed to fetch data from {url}: {e}")

# Create the pipeline
pipeline = dlt.pipeline(
    pipeline_name="test_taxi",
    dataset_name=input("Enter the dataset name: "),
    destination="bigquery"
   # dev_mode=True
)

# Run the pipeline with either method
if dlt_method == "1":
    info = pipeline.run(parquet_source())
elif dlt_method == "2":
    info = pipeline.run(paginated_getter())
else:
    print("Invalid selection")
    exit()

print(info)