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
color_RANGE = {'yellow': 'tpep_pickup_datetime', 
                'green': 'lpep_pickup_datetime',
                'fhv':'pickup_datetime'}
INPUT_PART = "raw"
INPUT_FILETYPE = "PARQUET"

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

# NOTE: DAG declaration - using a Context Manager (an implicit way)
with DAG(
    dag_id="taxi_data",
    default_args=default_args,
    catchup=True,
    max_active_runs=3,
    tags=['dtc-de'],
) as dag:

    for color, ds_col in color_RANGE.items():
        move_files_gcs_task = GCSToGCSOperator(
            task_id=f'move_{color}_{DATASET}_files_task',
            source_bucket=BUCKET,
            source_object=f'{INPUT_PART}/{color}_{DATASET}*.{INPUT_FILETYPE}',
            destination_bucket=BUCKET,
            destination_object=f'{color}/{color}_{DATASET}',
            move_object=True
        )

        bigquery_external_table_task = BigQueryCreateExternalTableOperator(
                task_id=f"bq_{color}_{DATASET}_external_table_task",
                table_resource={
                    "tableReference": {
                        "projectId": PROJECT_ID,
                        "datasetId": BIGQUERY_DATASET,
                        "tableId": f"{color}_{DATASET}_external_table",
                    },
                    "externalDataConfiguration": {
                        "ignoreUnknownValues": "True",
                        "sourceFormat": "PARQUET",
                        "sourceUris": [f"gs://{BUCKET}/{color}/*"],
                    },
                },
            )

        CREATE_BQ_TBL_QUERY = (
                f""" \
                CREATE OR REPLACE TABLE {BIGQUERY_DATASET}.{color}_{DATASET} \
                PARTITION BY DATE({ds_col}) \
                AS \
                SELECT * FROM {BIGQUERY_DATASET}.{color}_{DATASET}_external_table;\
                """
            )

        # Create a partitioned table from external table
        bq_create_partitioned_table_job = BigQueryInsertJobOperator(
            task_id=f"bq_create_{color}_{DATASET}_partitioned_table_task",
            configuration={
                "query": {
                    "query": CREATE_BQ_TBL_QUERY,
                    "useLegacySql": False,
                }
            }
        )
        move_files_gcs_task >> bigquery_external_table_task >> bq_create_partitioned_table_job
