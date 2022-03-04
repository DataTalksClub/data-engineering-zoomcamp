# https://s3.amazonaws.com/nyc-tlc/trip+data/green_tripdata_2021-01.csv
from distutils import errors
import os
import logging
import numpy as np
import pyarrow as pa
import pyarrow.parquet as pq

from datetime import datetime

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

from google.cloud import storage

#import pyarrow.csv as pv
#import pyarrow.parquet as pq
import pandas as pd
from dateutil.relativedelta import relativedelta


PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")
AIRFLOW_HOME = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")


def format_to_parquet(src_file, dest_file):
    if not src_file.endswith('.csv'):
        logging.error("Can only accept source files in CSV format, for the moment")
        return
    table = pd.read_csv(src_file,low_memory=False,keep_default_na=False,encoding='latin-1')
    for col in table:
        if col=='pickup_datetime':
                table[col]=pd.to_datetime(table[col],format='%Y-%m-%d %H:%M:%S')
        else:
                table[col]=table[col].astype(str)
    table=pa.Table.from_pandas(table)
    pq.write_table(table,dest_file)


def upload_to_gcs(bucket, object_name, local_file):
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
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

execution_date = datetime(2019, 1, 2)
end_date = datetime(2021, 7, 2)
execution_date_t=execution_date.strftime("%Y-%m")

URL_PREFIX = 'https://s3.amazonaws.com/nyc-tlc/trip+data'
    
with DAG(
    dag_id="FHV_data",
    default_args=default_args,
    catchup=True,
    max_active_runs=3,
    concurrency=4,
    tags=['dtc-de'],
) as dag:
    while execution_date <= end_date:

        execution_date_t=execution_date.strftime("%Y-%m")
        url_template = f"{URL_PREFIX}/fhv_tripdata_{execution_date_t}.csv"
        local_csv_path_template= f"{AIRFLOW_HOME}/fhv_tripdata_{execution_date_t}.csv"
        local_parquet_path_template = f"{AIRFLOW_HOME}/fhv_tripdata_{execution_date_t}.parquet"
        gcs_path_template = f"raw/fhv_tripdata/{execution_date_t[:4]}/fhv_tripdata_{execution_date_t}.parquet"

        download_dataset_task = BashOperator(
            task_id=f"download_dataset_task_{execution_date_t}",
            bash_command=f"curl -sSLf {url_template} > {local_csv_path_template}"
        )

        format_to_parquet_task = PythonOperator(
            task_id=f"format_to_parquet_task_{execution_date_t}",
            python_callable=format_to_parquet,
            op_kwargs={
                "src_file": local_csv_path_template,
                "dest_file": local_parquet_path_template
            },
        )

        local_to_gcs_task = PythonOperator(
            task_id=f"local_to_gcs_task_{execution_date_t}",
            python_callable=upload_to_gcs,
            op_kwargs={
                "bucket": BUCKET,
                "object_name": gcs_path_template,
                "local_file": local_parquet_path_template,
            },
        )

        rm_task = BashOperator(
            task_id=f"rm_task_{execution_date_t}",
            bash_command=f"rm {local_csv_path_template} {local_parquet_path_template}"
        )
        download_dataset_task >> format_to_parquet_task >> local_to_gcs_task >> rm_task
        execution_date += relativedelta(months=1)
