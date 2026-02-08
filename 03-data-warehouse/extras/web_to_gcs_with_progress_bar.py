import os
import requests
import pandas as pd
from google.cloud import storage
from dotenv import load_dotenv
from tqdm import tqdm
import gzip
import pyarrow as pa
import pyarrow.parquet as pq


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


def download_with_progress(url: str, local_path: str, desc: str = "Downloading"):
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        total = int(r.headers.get("content-length", 0))
        # Configure tqdm for bytes
        with (
            open(local_path, "wb") as f,
            tqdm(
                total=total,
                unit="B",
                unit_scale=True,
                unit_divisor=1024,
                desc=desc,
            ) as bar,
        ):
            for chunk in r.iter_content(chunk_size=1024 * 1024):  # 1 MB
                if not chunk:
                    continue
                size = f.write(chunk)
                bar.update(size)


def csv_to_parquet_with_progress(
    csv_path: str, parquet_path: str, service_color: str, chunksize: int = 100_000
):
    # 1) Count rows (gzip-aware)
    with gzip.open(csv_path, mode="rt") as f:
        total_rows = sum(1 for _ in f) - 1  # minus header
    if total_rows <= 0:
        raise ValueError("CSV appears to be empty")

    # 2) Read in chunks with fixed dtypes so parquet columns will directly have good types
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

    if service_color == "yellow":
        parse_dates = ["tpep_pickup_datetime", "tpep_dropoff_datetime"]
    else:
        parse_dates = ["lpep_pickup_datetime", "lpep_dropoff_datetime"]

    reader = pd.read_csv(
        csv_path,
        dtype=dtypes,
        parse_dates=parse_dates,
        compression="gzip",
        chunksize=chunksize,
        low_memory=False,
    )

    writer = None

    with tqdm(total=total_rows, unit="rows", desc=f"Parquet {csv_path}") as bar:
        for chunk in reader:
            table = pa.Table.from_pandas(chunk)
            if writer is None:
                writer = pq.ParquetWriter(parquet_path, table.schema)
            else:
                # Optional safety: align to first schema
                table = table.cast(writer.schema)
            writer.write_table(table)
            bar.update(len(chunk))

    if writer is not None:
        writer.close()


def upload_to_gcs_with_progress(bucket: str, object_name: str, local_file: str):
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # Optional: tune chunk size (must be multiple of 256 KiB)
    storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket_obj = client.bucket(bucket)
    blob = bucket_obj.blob(object_name)

    if blob.exists(client):
        print(f"Skipping upload, already in GCS: gs://{bucket}/{object_name}")
        return

    file_size = os.path.getsize(local_file)

    with open(local_file, "rb") as f:
        with tqdm.wrapattr(
            f,
            "read",
            total=file_size,
            miniters=1,
            unit="B",
            unit_scale=True,
            unit_divisor=1024,
            desc=f"Uploading {os.path.basename(local_file)}",
        ) as wrapped_file:
            blob.upload_from_file(
                wrapped_file,
                size=file_size,  # important so the library knows total bytes
            )

    print(f"Uploaded to GCS: gs://{bucket}/{object_name}")


def web_to_gcs(year, service):
    client = storage.Client()
    bucket_obj = client.bucket(BUCKET)

    for i in tqdm(range(12), desc=f"{service} {year}", unit="month"):
        month = f"{i + 1:02d}"

        csv_file_name = f"{service}_tripdata_{year}-{month}.csv.gz"
        parquet_file_name = csv_file_name.replace(".csv.gz", ".parquet")
        object_name = f"{service}/{parquet_file_name}"

        # 1) Check if parquet already in GCS
        blob = bucket_obj.blob(object_name)
        if blob.exists(client):
            print(f"Already in GCS, skipping: gs://{BUCKET}/{object_name}")
            continue

        # 2) Check if CSV already downloaded locally
        if os.path.exists(csv_file_name):
            print(f"CSV already exists locally, skipping download: {csv_file_name}")
        else:
            request_url = f"{init_url}{service}/{csv_file_name}"
            download_with_progress(
                request_url, csv_file_name, desc=f"Downloading {csv_file_name}"
            )

        # 3) Check if Parquet already exists locally
        if os.path.exists(parquet_file_name):
            print(
                f"Parquet already exists locally, skipping conversion: {parquet_file_name}"
            )
        else:
            csv_to_parquet_with_progress(csv_file_name, parquet_file_name, service)
            print(f"Parquet: {parquet_file_name}")

        # 4) Upload with per-byte progress bar
        upload_to_gcs_with_progress(BUCKET, object_name, parquet_file_name)


web_to_gcs("2019", "green")
web_to_gcs("2020", "green")
web_to_gcs(
    "2021", "green"
)  # will fail when reaching 08 (normal, file does not exists in github :)
# web_to_gcs("2019", "yellow")
# web_to_gcs("2020", "yellow")
# web_to_gcs("2021", "yellow") # will fail when reaching 08 (normal, file does not exists in github :)
