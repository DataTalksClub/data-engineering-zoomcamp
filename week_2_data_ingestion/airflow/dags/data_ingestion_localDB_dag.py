import os
from datetime import datetime

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

path_to_local_file = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
dataset_file = "yellow_tripdata_2021-01.csv"
dataset_url = f"https://s3.amazonaws.com/nyc-tlc/trip+data/{dataset_file}"

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

with DAG(
    dag_id="data_ingestion_localDB_dag",
    schedule_interval="@daily",
    default_args=default_args,
    catchup=True,
    max_active_runs=1,
) as dag:

    download_unzip_task = BashOperator(
        task_id="download_unzip_task",
        bash_command=f"curl -sS {dataset_url} > {path_to_local_file}/{dataset_file}"    # "&& unzip {zip_file} && rm {zip_file}"
    )
    #
    # upload_to_postgres_task = PythonOperator(
    #     task_id="upload_to_postgres_task",
    #     python_callable=,
    #     op_kwargs={
    #         "source_file": f"{path_to_local_file}/{dataset_file}",
    #         "target_file": f"raw/{{ execution_date.year }}/{{ execution_date.month }}/{dataset_file}",
    #     },
    # )
    #
    # download_unzip_task >> upload_to_gcs_task
    #