from google.cloud import storage
import os
import pandas as pd
#write bash script to upload to GCS
URL="https://nyc-tlc.s3.amazonaws.com/trip+data/fhv_tripdata_2019-07.csv"
path_to_current_dir = os.path.dirname(os.path.abspath(__file__))
GCP_PROJECT_ID= 'valiant-vault-340721'
GCP_GCS_BUCKET= 'dtc_data_lake_valiant-vault-340721'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = r"C:\Users\german.granados\.google\credentials\google_credentials.json"
color='fhv'
date_file = '2020-02'
#dtc_data_lake_valiant-vault-340721/fhv/fhv_tripdata/2019
object_name = f"{color}/{color}_tripdata/{date_file[:4]}/{color}_tripdata_{date_file}.parquet"
def download_to_parquet(URL):
    table=pd.read_csv(URL)
    print("download finished")
    table.to_parquet('file.parquet', engine='pyarrow',index=False)
    print("parquet finished")

def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    :param bucket: GCS bucket name
    :param object_name: target path & file-name
    :param local_file: source path & file-name
    :return:
    """
    # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # (Ref: https://github.com/googleapis/python-storage/issues/74)
    storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB
    # End of Workaround

    client = storage.Client()
    bucket = client.bucket(bucket)

    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)
    print("upload finished")
download_to_parquet(URL)
#upload_to_gcs(GCP_GCS_BUCKET, object_name, 'file.parquet')