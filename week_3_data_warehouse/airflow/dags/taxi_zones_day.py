import os
import logging

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateExternalTableOperator, BigQueryInsertJobOperator
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator

PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")

path_to_local_home = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
BIGQUERY_DATASET = os.environ.get("BIGQUERY_DATASET", 'trips_data_all')

DATASET = "tripdata"
COLOUR_RANGE = {'yellow': 'tpep_pickup_datetime', 
                'green': 'lpep_pickup_datetime','fhv':'asdf'}
INPUT_PART = "raw"
INPUT_FILETYPE = "parquet"

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

with DAG(
    dag_id="taxi_zones",
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=['dtc-de'],
) as dag:

    move_files_gcs_task = GCSToGCSOperator(
            task_id='move_taxi_zone_files_task',
            source_bucket=BUCKET,
            source_object=f'{INPUT_PART}/taxi_zone*.{INPUT_FILETYPE}',
            destination_bucket=BUCKET,
            destination_object=f'taxi_zone/taxi_zone_{DATASET}',
            move_object=True
        )
    
    bigquery_external_table_task = BigQueryCreateExternalTableOperator(
            task_id="taxi_zone_external_table_task",
            table_resource={
                "tableReference": {
                    "projectId": PROJECT_ID,
                    "datasetId": BIGQUERY_DATASET,
                    "tableId": "taxi_zone_external_table",
                },
                "externalDataConfiguration": {
                    "autodetect": "True",
                    "sourceFormat": "PARQUET",
                    "sourceUris": [f"gs://{BUCKET}/taxi_zone/*"],
                },
            },
        )

    move_files_gcs_task >> bigquery_external_table_task
