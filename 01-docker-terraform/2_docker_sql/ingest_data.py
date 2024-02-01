#!/usr/bin/env python
# coding: utf-8

import os
import argparse
import time
import pandas as pd
from sqlalchemy import create_engine


def main(params):
    user = params.user
    password = params.password
    host = params.host 
    port = params.port 
    db = params.db
    table_name = params.table_name
    url = params.url
    
    # Check if the file is gzip-compressed
    is_gzip = url.endswith('.gz')

    # Extracting the file name from the URL
    file_name = url.split('/')[-1]

    # Download the file
    os.system(f"wget {url} -O {file_name}")

    # Use pd.read_csv with compression parameter based on the file type
    if is_gzip:
        df_iter = pd.read_csv(file_name, compression='gzip', iterator=True, chunksize=100000)
    else:
        df_iter = pd.read_csv(file_name, iterator=True, chunksize=100000)

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    df.to_sql(name=table_name, con=engine, if_exists='append')

    while True:
        t_start = time.time()

        try:
            df = next(df_iter)
        except StopIteration:
            print("Finished ingesting data into the postgres database")
            break

        df[['tpep_pickup_datetime', 'tpep_dropoff_datetime']] = df[['tpep_pickup_datetime', 'tpep_dropoff_datetime']].apply(pd.to_datetime)

        df.to_sql(name= table_name, con=engine, if_exists='append')

        t_end = time.time()

        print(f'Inserted another chunk, took {t_end - t_start:.3f} seconds')

    # Remove the downloaded file to save sapce
    os.remove(file_name)
    print(f"Downloaded file {file_name} has been removed.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True, help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True, help='database name for postgres')
    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--url', required=True, help='url of the csv file')

    args = parser.parse_args()

    main(args)
