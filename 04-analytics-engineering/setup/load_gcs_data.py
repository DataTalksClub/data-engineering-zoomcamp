#!/usr/bin/env python3

import argparse
import os
import requests
import pandas as pd
from google.cloud import storage
from pathlib import Path

"""
Script to download NYC Taxi data and upload to Google Cloud Storage (GCS).

Pre-reqs:
1. `pip install pandas pyarrow google-cloud-storage`
2. Authenticated with GCP (e.g. `gcloud auth application-default login` or `GOOGLE_APPLICATION_CREDENTIALS`)
3. `GCP_GCS_BUCKET` env var set (or passed via --bucket)
"""

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"


def parse_years(value: str) -> list[int]:
    years: list[int] = []
    for chunk in value.split(","):
        chunk = chunk.strip()
        if not chunk:
            continue
        if "-" in chunk:
            start_str, end_str = chunk.split("-", 1)
            start, end = int(start_str), int(end_str)
            years.extend(range(start, end + 1))
        else:
            years.append(int(chunk))
    return sorted(set(years))


def upload_to_gcs(bucket_name: str, object_name: str, local_file: Path):
    print(f"Uploading {local_file} to gs://{bucket_name}/{object_name} ...")
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(str(local_file))


def process_and_upload(
    taxi_types: list[str],
    years: list[int],
    months: list[int],
    bucket_name: str,
    data_dir: Path,
) -> None:
    data_dir.mkdir(parents=True, exist_ok=True)

    for taxi_type in taxi_types:
        for year in years:
            for month in months:
                # Source file name (CSV.gz)
                csv_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
                url = f"{BASE_URL}/{taxi_type}/{csv_filename}"
                
                # Local download path
                csv_path = data_dir / csv_filename

                # Destination Parquet file name
                parquet_filename = csv_filename.replace('.csv.gz', '.parquet')
                parquet_path = data_dir / parquet_filename
                
                # GCS Object Path
                gcs_path = f"{taxi_type}/{parquet_filename}"

                try:
                    # 1. Download
                    if not csv_path.exists() and not parquet_path.exists():
                        print(f"Downloading {url}...")
                        with requests.get(url, stream=True, timeout=60) as r:
                            r.raise_for_status()
                            with open(csv_path, 'wb') as f:
                                for chunk in r.iter_content(chunk_size=1024*1024):
                                    f.write(chunk)
                    
                    # 2. Convert to Parquet (if not already done)
                    if not parquet_path.exists():
                        print(f"Converting {csv_filename} to Parquet...")
                        # Use pandas chunks to handle memory better? Or just pyarrow?
                        # Using pandas read_csv with chunks might be safer for memory but read_csv -> to_parquet is easiest
                        # Note: FHV data has some schema issues sometimes, specifying dtype can help
                        df = pd.read_csv(csv_path, compression='gzip', low_memory=False)
                        
                        # Normalize column names if needed? (Usually dataset is clean enough for this course)
                        
                        df.to_parquet(parquet_path, engine='pyarrow')
                        
                        # Clean up CSV to save space
                        csv_path.unlink(missing_ok=True)
                    
                    # 3. Upload to GCS
                    upload_to_gcs(bucket_name, gcs_path, parquet_path)
                    
                    # Optional: Clean up parquet to save space?
                    # parquet_path.unlink(missing_ok=True) 

                except Exception as e:
                    print(f"Failed to process {csv_filename}: {e}")
                    continue

    print("All done!")


def main():
    parser = argparse.ArgumentParser(description="Download NYC Taxi data and upload to GCS.")
    parser.add_argument("--taxi-types", default="yellow,green", help="Comma-separated taxi types (e.g. yellow,green,fhv)")
    parser.add_argument("--years", default="2019-2020", help="Years (e.g. 2019,2020 or 2019-2020)")
    parser.add_argument("--months", default="1-12", help="Months (e.g. 1-12)")
    parser.add_argument("--bucket", help="GCS Bucket Name (defaults to env GCP_GCS_BUCKET)")
    parser.add_argument("--data-dir", default="data_tmp", help="Temporary local directory")

    args = parser.parse_args()

    bucket_name = args.bucket or os.environ.get("GCP_GCS_BUCKET")
    if not bucket_name:
        raise ValueError("GCS Bucket must be provided via --bucket or GCP_GCS_BUCKET env var.")

    taxi_types = [t.strip() for t in args.taxi_types.split(",") if t.strip()]
    years = parse_years(args.years)
    months = parse_years(args.months)
    months = [m for m in months if 1 <= m <= 12]

    process_and_upload(
        taxi_types=taxi_types,
        years=years,
        months=months,
        bucket_name=bucket_name,
        data_dir=Path(args.data_dir),
    )


if __name__ == "__main__":
    main()
