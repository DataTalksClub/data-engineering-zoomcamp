import io
import os
import requests
import pandas as pd
import pyarrow.parquet as pq
from google.cloud import storage

# switch out the bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "dtc-data-lake-bucketname")
print(BUCKET)

def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)

def web_to_gcs(year, service):
    for i in range(12):
        # sets the month part of the file_name string
        month = '0'+str(i+1)
        month = month[-2:]

        # csv file_name
        file_name = f"{service}_tripdata_{year}-{month}.parquet"
        # request url for week 3 homework
        request_url = f'https://d37ci6vzurychx.cloudfront.net/trip-data/{service}_tripdata_{year}-{month}.parquet'
        print(request_url)
        #request_url = f"{init_url}{service}/{file_name}"
        r = requests.get(request_url)
        open(file_name, 'wb').write(r.content)
        print(f"Local: {file_name}")

        df = pq.read_table(file_name)
        #df.to_parquet(file_name, engine='pyarrow')
        print(f"Parquet: {file_name}")
        # upload it to gcs 
        upload_to_gcs(BUCKET, f"{service}/{file_name}", file_name)
        print(f"GCS: {service}/{file_name}")

# The following two datasets are used in the Week 3 Video Modules
web_to_gcs('2019', 'yellow')
web_to_gcs('2020', 'yellow')

# The following dataset is necessary to complete the Week 3 Homework Questions
web_to_gcs('2022', 'green')
