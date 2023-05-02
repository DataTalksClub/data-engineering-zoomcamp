# Import necessary packages to create a DAG from Airflow ingesting data from a website and storing it in S3
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.decorators import task, dag
from datetime import datetime, timedelta
import requests
import pandas as pd
import boto3
import json
import os

# Define default arguments for the DAG
default_args = {
    "owner": "gluonhiggs",
    "depends_on_past": False,
    "start_date": datetime(2021, 8, 1),
    "email": ["love.fiziks@gmail.com"],
    "email_on_failure": True,
    "email_on_retry": True,
    "retries": 1,
    "retry_delay": timedelta(seconds=30)
}
schedule = timedelta(seconds=300)
description = "A simple DAG to ingest data from a website and store it in S3"




# Define the DAG with dag decorator
@dag(default_args=default_args, 
    schedule=schedule,
    catchup=False,
    description=description)
def etl_web_to_s3()->None:
    """
    Ingest green taxi data in January 2020
    """
    color = "green"
    year = 2020
    month = 1
    dataset_filename = f"{color}_tripdata_{year}-{month:2d}.csv.gz"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/{color}/downloads/{dataset_filename}"


    @task()
    def fetch_data(dataset_url:str)->pd.DataFrame:
        """
        Fetch data from a website
        """
        # response = requests.get(dataset_url)
        # if response.status_code == 200:
        #     return response.content
        # else:
        #     raise Exception(f"Could not fetch data from {dataset_url}")
        # return pandas df otherwise raise exception
        response = requests.get(dataset_url)
        if response.status_code == 200:
            return pd.read_csv(dataset_url)
        else:
            raise Exception(f"Could not fetch data from {dataset_url}")
    fetch_data

dag = etl_web_to_s3()
