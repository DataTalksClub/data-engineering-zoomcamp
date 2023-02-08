import pandas as pd
from sqlalchemy import create_engine
import os
from prefect import flow, task
from prefect.tasks import task_input_hash
from time import time
from datetime import timedelta
from prefect_sqlalchemy import SqlAlchemyConnector


# Needed arguments: user, password, host, port, database name, table name,
# url of the csv

#uso do cache_key_fn e task_input_hash
@task(log_prints=True,retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def extract_data(url):

    csv_name = 'output.parquet'
    os.system(f"wget {url} -O {csv_name}")
    df = pd.read_parquet(csv_name, engine='pyarrow')
    df.to_csv('output.csv', index=False)
    df = pd.read_csv("output.csv")
    df_iter = pd.read_csv('output.csv', iterator=True, chunksize=100000)
    df = next(df_iter)
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
    return df


@task(log_prints=True)
def transform_data(df):

    print(f"pre:missing passenger count: {(df['passenger_count']==0).sum()}")
    df = df[df['passenger_count'] != 0]
    print(f"post:missing passenger count: {(df['passenger_count']==0).sum()}")
    return df


@task(log_prints=True, retries=3)
def ingest_data(table_name, data):
    #criação do block para conexão ao database, sem precisar passar os dados de host user etc
    connection_block = SqlAlchemyConnector.load("pgconnector")
    with connection_block.get_connection(begin=False) as engine:
        data.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
        data.to_sql(name=table_name, con=engine, if_exists='append')

#criação do subflow
@flow(name='Subflow', log_prints=True)
def log_subflow(table_name: str):
    print(f'Logging subflow for {table_name}')


@flow(name="Ingest flow")
def main_flow(table_name: str):
    url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"
    log_subflow(table_name)
    raw_data = extract_data(url)
    data = transform_data(raw_data)
    ingest_data(table_name,data)


if __name__ == "__main__":
    main_flow("yellow_taxi_driver_2022")
