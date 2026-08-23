import os
import requests
import pandas as pd
from google.cloud import storage
from dotenv import load_dotenv


"""
Pre-reqs: 
1. run `uv sync` from this 'extra' folder (create venv and install dependencies from pyproject.toml)
2. rename .env-example to .env (not commited thanks to .gitignore)
3. in .env, 
    - set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
    - Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account json key 
    (or don't set it if you use google ADC)
"""
# load env vars from .env
load_dotenv()

# services = ['fhv','green','yellow']
init_url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/"
# if not done in .env, switch out the default bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "dtc-data-lake-bucketname")


def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    # storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)


def web_to_gcs(year, service):
    for i in range(12):
        # sets the month part of the file_name string
        month = "0" + str(i + 1)
        month = month[-2:]

        # csv file_name
        file_name = f"{service}_tripdata_{year}-{month}.csv.gz"

        # download it using requests via a pandas df
        request_url = f"{init_url}{service}/{file_name}"
        r = requests.get(request_url)
        open(file_name, "wb").write(r.content)
        print(f"Local: {file_name}")

        # read it back into a parquet file
        # enforce types so parquet columns will directly have good types
        # (as we did in module 1 in ingest.py script)
        dtypes = {
            "VendorID": "Int64",
            "RatecodeID": "Int64",
            "PULocationID": "Int64",
            "DOLocationID": "Int64",
            "passenger_count": "Int64",
            "payment_type": "Int64",
            "trip_type": "Int64",  # only in green but ignored if missing column
            "store_and_fwd_flag": "string",
            "trip_distance": "float64",
            "fare_amount": "float64",
            "extra": "float64",
            "mta_tax": "float64",
            "tip_amount": "float64",
            "tolls_amount": "float64",
            "ehailfee": "float64",  # only in green but ignored if missing column
            "improvement_surcharge": "float64",
            "total_amount": "float64",
            "congestion_surcharge": "float64",
        }

        if service == "yellow":
            parse_dates = ["tpep_pickup_datetime", "tpep_dropoff_datetime"]
        else:
            parse_dates = ["lpep_pickup_datetime", "lpep_dropoff_datetime"]

        df = pd.read_csv(
            file_name, dtype=dtypes, parse_dates=parse_dates, compression="gzip"
        )
        file_name = file_name.replace(".csv.gz", ".parquet")
        df.to_parquet(file_name, engine="pyarrow")
        print(f"Parquet: {file_name}")

        # upload it to gcs
        upload_to_gcs(BUCKET, f"{service}/{file_name}", file_name)
        print(f"GCS: {service}/{file_name}")


web_to_gcs("2019", "green")
web_to_gcs("2020", "green")
web_to_gcs("2021", "green")  # fail when reach 08 (normal, file not in github :)
# web_to_gcs("2019", "yellow")
# web_to_gcs("2020", "yellow")
# web_to_gcs("2021", "yellow") # fail when reach 08 (normal, file not in github :)
