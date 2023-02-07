
import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine
from prefect import flow, task
from prefect.tasks import task_input_hash # lets us used cached data from previous task/runs
from datetime import timedelta
from prefect_sqlalchemy import SqlAlchemyConnector


@task(log_prints=True, retries=3)
def transform_data(df):
    """Transform data.
    
    Args:
        df (pandas.DataFrame): dataframe to transform
    """
    print(f'pre: missing passenger count: {df["passenger_count"].isin([0]).sum()}')
    df = df[df['passenger_count'] > 0]
    print(f'post: missing passenger count: {df["passenger_count"].isin([0]).sum()}')
    
    return df

@task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def extract_data(url):
    """Extract data from url.
    
    Args:
        url (str): csv url
    """
    if url.endswith('.csv.gz'):
        csv_name = 'yellow_tripdata_2021-01.csv.gz'
    else:
        csv_name = 'output.csv'
    
    os.system(f'wget {url} -O {csv_name}')
    
    df_iter = pd.read_csv(csv_name, chunksize=100000, iterator=True)
    
    df = next(df_iter)    
    
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    return df


@task(log_prints=True, retries=3)
def ingest_data(table_name, df):
    """Ingest data from url into a postgres database table.
    
    Args:
        user (str): postgres username
        password (str): postgres password
        host (str): postgres host
        port (str): postgres port
        db (str): postgres database
        table_name (str): postgres table name
        url (str): csv url
    """
    connection_block = SqlAlchemyConnector.load('postgres')
    
    with connection_block.get_connection(begin=False) as engine: 
        df.head(n=0).to_sql(table_name, con=engine, if_exists='replace')
        df.to_sql(table_name, con=engine, if_exists='append')
    

@flow(name="Subflow", log_prints=True)
def log_subflow(table_name:str):
    print(f'Logging subflow for: {table_name}')
    


@flow(name="Ingest Flow")
def main(table_name:str, csv_url:str, db:str): 
    log_subflow(table_name)
   
    raw_data = extract_data(csv_url)
    data = transform_data(raw_data)
    ingest_data(table_name, data)



if __name__ == '__main__':
    table_name = 'yellow_taxi_trips'
    csv_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz'
    db = 'nytaxi'
    main(table_name, csv_url, db)