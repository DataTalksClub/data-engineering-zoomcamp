import os
import subprocess
from pathlib import Path
import duckdb
from concurrent.futures import ThreadPoolExecutor

BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data"
DATA_DIR = Path("/tmp/taxi_data")
DB_PATH = Path("/opt/data/taxi_rides_ny.duckdb")

# Yellow (2019-2020), Green (2019-2020), FHV (2019)
tasks = [
    ("yellow", 2019, range(1, 13)),
    ("yellow", 2020, range(1, 13)),
    ("green", 2019, range(1, 13)),
    ("green", 2020, range(1, 13)),
    ("fhv", 2019, range(1, 13)),
]

DATA_DIR.mkdir(parents=True, exist_ok=True)
DB_PATH.parent.mkdir(parents=True, exist_ok=True)

# Flatten tasks into a list of individual files to download
files_to_process = []
for service, year, months in tasks:
    for month in months:
        files_to_process.append((service, year, month))

def process_file(file_info):
    service, year, month = file_info
    file_name = f"{service}_tripdata_{year}-{month:02d}.parquet"
    url = f"{BASE_URL}/{file_name}"
    target_path = DATA_DIR / file_name
    
    try:
        # Download
        print(f"Downloading {file_name}...")
        subprocess.run(["wget", "-q", url, "-O", str(target_path)], check=True)
        
        # Ingest into a thread-local connection or use a shared one with locking?
        # DuckDB is best with a single writer. We will download in parallel, ingest in serial.
        return (service, target_path)
    except Exception as e:
        print(f"Error processing {file_name}: {e}")
        return None

# 1. Download files in parallel (fast!)
print(f"Starting parallel download of {len(files_to_process)} files...")
downloaded_files = []
with ThreadPoolExecutor(max_workers=8) as executor:
    downloaded_files = list(executor.map(process_file, files_to_process))

# 2. Ingest files in serial (DuckDB requirement)
print("Starting serial ingestion into DuckDB...")
con = duckdb.connect(str(DB_PATH))
con.execute("CREATE SCHEMA IF NOT EXISTS prod")

for result in downloaded_files:
    if result:
        service, path = result
        print(f"  Ingesting {path.name}...")
        con.execute(f"CREATE TABLE IF NOT EXISTS prod.{service}_tripdata AS SELECT * FROM read_parquet('{path}') LIMIT 0")
        con.execute(f"INSERT INTO prod.{service}_tripdata SELECT * FROM read_parquet('{path}')")
        # Cleanup
        path.unlink()

con.close()
print(f"Data baking complete. Database stored at {DB_PATH}")