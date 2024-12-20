#question 1
#yellow taxi data for 2019 and 2020
import os
import logging

from datetime import datetime

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

from google.cloud import storage
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateExternalTableOperator
import pyarrow.csv as pv
import pyarrow.parquet as pq

#PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
#BUCKET = os.environ.get("GCP_GCS_BUCKET")
PROJECT_ID = 'dtc-de-course-439003'
BUCKET = 'dtc-de-course-439003-gcs-bucket'
AIRFLOW_HOME = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")


URL_PREFIX = 'https://d37ci6vzurychx.cloudfront.net/trip-data'
URL_TEMPLATE = URL_PREFIX + '/yellow_tripdata_{{ execution_date.strftime(\'%Y-%m\') }}.parquet'
OUTPUT_FILE_TEMPLATE = AIRFLOW_HOME + '/output_{{ execution_date.strftime(\'%Y-%m\') }}.parquet'
dataset_file = "output_{{ execution_date.strftime(\'%Y-%m\') }}.parquet"

#samples of the URLs
#https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2019-01.parquet
#https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2020-09.parquet
     

# NOTE: takes 20 mins, at an upload speed of 800kbps. Faster if your internet has a better upload speed
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


default_args = {
    "owner": "airflow",
    #"start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

# NOTE: DAG declaration - using a Context Manager (an implicit way)
with DAG(
    dag_id="data_ingestion_yellow_2019_2020",
    start_date=datetime(2019, 1, 1),
    end_date=datetime(2020, 12, 31),
    schedule_interval="@monthly",
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=['dtc-de'],
) as dag:

    download_dataset_task = BashOperator(
        task_id="download_dataset_task",
        bash_command=f"curl -sSL {URL_TEMPLATE} > {AIRFLOW_HOME}/{dataset_file}"
    )

    ingest_task = PythonOperator(
        task_id="ingest_task",
        python_callable=upload_to_gcs,
        op_kwargs={
            "bucket": BUCKET,
            "object_name": f"raw/{dataset_file}",
            "local_file": f"{AIRFLOW_HOME}/{dataset_file}",
        },
    )
    

    download_dataset_task >> ingest_task