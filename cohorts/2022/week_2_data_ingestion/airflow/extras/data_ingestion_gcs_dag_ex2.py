import os
from datetime import datetime

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from google.cloud import storage

PROJECT_ID = os.environ.get("GCP_PROJECT_ID", "pivotal-surfer-336713")
BUCKET = os.environ.get("GCP_GCS_BUCKET", "dtc_data_lake_pivotal-surfer-336713")

dataset_file = "yellow_tripdata_2021-01.csv"
dataset_url = f"https://s3.amazonaws.com/nyc-tlc/trip+data/{dataset_file}"
path_to_local_home = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
path_to_creds = f"{path_to_local_home}/google_credentials.json"

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}


# # Takes 15-20 mins to run. Good case for using Spark (distributed processing, in place of chunks)
# def upload_to_gcs(bucket, object_name, local_file):
#     """
#     Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
#     :param bucket: GCS bucket name
#     :param object_name: target path & file-name
#     :param local_file: source path & file-name
#     :return:
#     """
#     # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload link.
#     # (Ref: https://github.com/googleapis/python-storage/issues/74)
#     storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
#     storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB
#
#     client = storage.Client()
#     bucket = client.bucket(bucket)
#
#     blob = bucket.blob(object_name)
#     # blob.chunk_size = 5 * 1024 * 1024
#     blob.upload_from_filename(local_file)


with DAG(
    dag_id="data_ingestion_gcs_dag",
    schedule_interval="@daily",
    default_args=default_args,
    catchup=True,
    max_active_runs=1,
) as dag:

    # Takes ~2 mins, depending upon your internet's download speed
    download_dataset_task = BashOperator(
        task_id="download_dataset_task",
        bash_command=f"curl -sS {dataset_url} > {path_to_local_home}/{dataset_file}"    # "&& unzip {zip_file} && rm {zip_file}"
    )

    # # APPROACH 1: (takes 20 mins, at an upload speed of 800Kbps. Faster if your internet has a better upload speed)
    # upload_to_gcs_task = PythonOperator(
    #     task_id="upload_to_gcs_task",
    #     python_callable=upload_to_gcs,
    #     op_kwargs={
    #         "bucket": BUCKET,
    #         "object_name": f"raw/{dataset_file}",
    #         "local_file": f"{path_to_local_home}/{dataset_file}",
    #
    #     },
    # )

    # OR APPROACH 2: (takes 20 mins, at an upload speed of 800Kbps. Faster if your internet has a better upload speed)
    # Ref: https://cloud.google.com/blog/products/gcp/optimizing-your-cloud-storage-performance-google-cloud-performance-atlas
    upload_to_gcs_task = BashOperator(
        task_id="upload_to_gcs_task",
        bash_command=f"gcloud auth activate-service-account --key-file={path_to_creds} && \
        gsutil -m cp {path_to_local_home}/{dataset_file} gs://{BUCKET}",

    )

    download_dataset_task >> upload_to_gcs_task