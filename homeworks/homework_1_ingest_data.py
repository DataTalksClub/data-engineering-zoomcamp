#!/usr/bin/env python
# coding: utf-8

import argparse
import os
from unicodedata import name
import pandas as pd
from time import time
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    green_taxi_table_name = params.green_taxi_table_name
    green_taxi_url = params.green_taxi_url
    zones_table_name = params.zones_table_name
    zones_url = params.zones_url

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # the backup files are gzipped, and it's important to keep the correct extension
    # for pandas to be able to open the file
    if green_taxi_url.endswith('.csv.gz'):
        yt_csv_name = 'yt_data.csv.gz'
    else:
        yt_csv_name = 'yt_data.csv'

    os.system(f"wget {green_taxi_url} -O {yt_csv_name}")

    zones_csv_name = 'zones.csv'
    os.system(f'wget {zones_url} -O {zones_csv_name}')


    zone_lookup = pd.read_csv(zones_csv_name)
    zone_lookup.columns = [c.lower() for c in zone_lookup.columns]
    zone_lookup.to_sql(name=zones_table_name, con=engine, if_exists='replace')
    print('inserted zone data')


    df_iter = pd.read_csv(yt_csv_name, iterator=True, chunksize=100_000)
    df = next(df_iter)
    df = df.assign(lpep_pickup_datetime=lambda df_: pd.to_datetime(df_['lpep_pickup_datetime']),
                lpep_dropoff_datetime=lambda df_: pd.to_datetime(df_['lpep_dropoff_datetime'])
                )
  
    df.columns = [c.lower() for c in df.columns]

    df.head(0).to_sql(name=green_taxi_table_name, con=engine, if_exists='replace')
    df.to_sql(name='green_taxi_data', con=engine, if_exists='append')

    while True:
        t_start = time()
        df = next(df_iter)
        df = df.assign(lpep_pickup_datetime=lambda df_: pd.to_datetime(df_['lpep_pickup_datetime']),
                    lpep_dropoff_datetime=lambda df_: pd.to_datetime(df_['lpep_dropoff_datetime'])
                    )
        df.columns = [c.lower() for c in df.columns]
        df.to_sql(name=green_taxi_table_name, con=engine, if_exists='append')

        t_end = time() 

        print(f'inserted another chunk..., took {t_end-t_start: .2f} seconds')
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Ingest CSV Data to Postgres")
    parser.add_argument('--user', help='username for postgres')
    parser.add_argument('--password', help='password for posgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--green_taxi_table_name', help='name of table to write the taxi data to')
    parser.add_argument('--green_taxi_url', help='url of the csv file')
    parser.add_argument('--zones_table_name', help='name of table to write the zones to')
    parser.add_argument('--zones_url', help='url of the zones data')

    args = parser.parse_args()

    main(args)
