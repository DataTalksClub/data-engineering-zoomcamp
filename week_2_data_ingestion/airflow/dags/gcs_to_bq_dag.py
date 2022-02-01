import os
import logging

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")

path_to_local_home = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
BIGQUERY_DATASET = os.environ.get("BIGQUERY_DATASET", 'trips_data_all')
BQ_TBL_EXT = "external_table"
BQ_TBL_YELLOW = "yellow_tripdata"
BQ_TBL_GREEN = "green_tripdata"
BQ_DATE_COL = "tpep_pickup_datetime"

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

# NOTE: DAG declaration - using a Context Manager (an implicit way)
with DAG(
    dag_id="gcs_2_bq_dag",
    schedule_interval="@daily",
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=['dtc-de'],
) as dag:

    # TODO: task to re-org from raw part to colour & create 2 ext table (per colour)

    # Create a partitioned table from external table
    CREATE_BQ_TBL_GREEN_QUERY = (
        f"CREATE OR REPLACE TABLE {BIGQUERY_DATASET}.{BQ_TBL_GREEN} \
        PARTITION BY DATE({BQ_DATE_COL}) \
        AS \
        SELECT * FROM {BIGQUERY_DATASET}.{BQ_TBL_EXT};"
    )

    create_bq_tbl_green_job = BigQueryInsertJobOperator(
        task_id=f"bq_create_{BQ_TBL_GREEN}_job",
        configuration={
            "query": {
                "query": CREATE_BQ_TBL_GREEN_QUERY,
                "useLegacySql": False,
            }
        }
    )

    # Create a partitioned table from external table
    CREATE_BQ_TBL_YELLOW_QUERY = (
        f"CREATE OR REPLACE TABLE {BIGQUERY_DATASET}.{BQ_TBL_YELLOW} \
            PARTITION BY DATE({BQ_DATE_COL}) \
            AS \
            SELECT * FROM {BIGQUERY_DATASET}.{BQ_TBL_EXT};"
    )

    create_bq_tbl_yellow_job = BigQueryInsertJobOperator(
        task_id=f"bq_create_{BQ_TBL_YELLOW}_job",
        configuration={
            "query": {
                "query": CREATE_BQ_TBL_YELLOW_QUERY,
                "useLegacySql": False,
            }
        }
    )

    create_bq_tbl_green_job >> create_bq_tbl_yellow_job
