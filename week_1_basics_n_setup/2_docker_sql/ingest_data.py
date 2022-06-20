#!/usr/bin/env python
# coding: utf-8
import argparse
import chunk
import os
from typing import Generator

import pyarrow.parquet as pq
import pandas as pd
from sqlalchemy import create_engine


def iter_df(df: pd.DataFrame, chunksize: int) -> Generator[pd.DataFrame, None, None]:
    for i in range(0, len(df), chunksize):
        yield df.iloc[i:i+chunksize, :].copy()


def main(params):
    user = params.user
    password = params.password
    host = params.host 
    port = params.port 
    db = params.db
    table_name = params.table_name
    url = params.url
    filename = 'output.parquet'
    
    os.system(f"wget {url} -O {filename}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df = pd.read_parquet(filename)

    total = 0
    for subset in iter_df(df, chunksize=100_000):
        total += len(subset)

        subset.to_sql(name="yellow_taxi_data", con=engine, if_exists='append')
        print(total)
    
    os.system(f"wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv -O lookups.csv")

    # cheating a little bit
    lookups = pd.read_csv('lookups.csv')
    lookups.to_sql(name="lookups", con=engine, if_exists='replace')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest data to Postgres')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True, help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True, help='database name for postgres')
    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--url', required=True, help='url of the parquet file')

    args = parser.parse_args()

    main(args)
