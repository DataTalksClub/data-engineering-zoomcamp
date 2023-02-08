#!/usr/bin/env python
# coding: utf-8

import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine
from prefect import flow, task
from prefect.tasks import task_input_hash
from datetime import timedelta
from prefect_sqlalchemy import SqlAlchemyConnector

# Flow is a python object that contains workflow logic, it's a state object


@task(log_prints=True, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def extract_data(url):
    # the backup files are gzipped, and it's important to keep the correct extension
    # for pandas to be able to open the file
    if url.endswith(".csv.gz"):
        csv_name = "output.csv.gz"
    else:
        csv_name = "output.csv"

    os.system(f"wget {url} -O {csv_name}")

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists="replace")

    return df


@task(log_prints=True)
def transform_data(df):
    print(f"pre:missing passenger count {df['passenger_count'].isin([0]).sum()}")
    df = df[df["passenger_count"] != 0]
    print(f"post:missing passenger count {df['passenger_count'].isin([0]).sum()}")

    return df


@task(log_prints=True, retries=3)
def ingest_data(raw_data, table_name):
    connection_block = SqlAlchemyConnector.load("postgres-database")
    with connection_block.get_connection(begin=False) as engine:
        raw_data.to_sql(name=table_name, con=engine, if_exists="append")


@flow(name="Subflow", log_prints=True)
def log_subflow(table_name: str):
    print("Logging subflow for: {table_name}")


@flow(name="Ingest Flow")
def main():
    user = "root"
    password = "root"
    host = "localhost"
    port = "5432"
    db = "ny_taxi"
    table_name = "yellow_taxi_trips"
    url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

    log_subflow(table_name)
    raw_data = extract_data(url)
    raw_data = transform_data(raw_data)
    ingest_data(raw_data, table_name)


if __name__ == "__main__":
    main()
