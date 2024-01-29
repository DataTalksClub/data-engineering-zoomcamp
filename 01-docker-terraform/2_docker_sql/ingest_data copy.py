#!/usr/bin/env python
# coding: utf-8
#%%
import os
import argparse

from time import time

import pandas as pd
from sqlalchemy import create_engine





user = "root"
password = "root"
host = "pg-database" 
port = "5432" 
db = "ny_tax"
table_name = "green_taxi_trip"
url = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-09.parquet"

# the backup files are gzipped, and it's important to keep the correct extension
# for pandas to be able to open the file
if url.endswith('.parquet'):
    csv_name = 'output.parquet'
else:
    csv_name = 'output.parquet'

os.system(f"wget {url} -O {csv_name}")

df = pd.read_parquet(csv_name,)
#%%
print("lenght df:", len(df))

df.to_csv('output.csv')


print('read, parquet file ')

engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

df_iter = pd.read_csv('output.csv', iterator=True, chunksize=100000)

df = next(df_iter)

df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

df.to_sql(name=table_name, con=engine, if_exists='append')

while True: 

    try:
        t_start = time()
        
        df = next(df_iter)

        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

        df.to_sql(name=table_name, con=engine, if_exists='append')

        t_end = time()

        print('inserted another chunk, took %.3f second' % (t_end - t_start))

    except StopIteration:
        print("Finished ingesting data into the postgres database")
        break

