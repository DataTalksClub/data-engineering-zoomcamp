# Import necessary packages to create a DAG from Airflow ingesting data from a website and storing it in S3
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.decorators import task, dag
from datetime import datetime, timedelta
import requests
import pandas as pd
color = "green"
year = 2020
month = 1
dataset_filename = f"{color}_tripdata_{year}-{month:02d}.csv.gz"
dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_filename}"



def fetch_data(dataset_url:str)->pd.DataFrame:
   """
   Fetch data from a website
   """
   response = requests.get(dataset_url)
   if response.status_code == 200:
      df = pd.read_csv(dataset_url)
      return df
   else:
      raise Exception(f"Could not fetch data from {dataset_url}")
a = fetch_data(dataset_url).info()
print(a)