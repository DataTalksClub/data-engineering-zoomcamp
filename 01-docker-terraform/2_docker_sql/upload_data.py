import argparse
from time import time
import pandas as pd
import os
from sqlalchemy import create_engine


parser = argparse.ArgumentParser(description="Ingest CSV data to Postgres")

#user, port, database,
#url of the csv
parser.add_argument('user', help='username for postgres')
parser.add_argument('pass', help='pass for postgres')
parser.add_argument('host', help='host for postgres')
parser.add_argument('port', help='port for postgres')
parser.add_argument('db', help='db for postgres')
parser.add_argument('table-name', help='table-name for postgres')
parser.add_argument('', help='username for postgres')


parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')
parser.add_argument('--sum', dest='accumulate', action='store_const',\
                    const=sum,default=max,
                    help='sum of integers (default: find the max')


engine = create_engine("postgresql://root:root@localhost:5432/ny_taxi")
engine.connect()

df_iter = pd.read_csv('yellow_tripdata_2021-01.csv.gz', iterator = True, chunksize = 100000)
df = next(df_iter)

df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

df.head(0).to_sql(name = 'yellow_taxi_data', con=engine, if_exists = 'replace')
get_ipython().run_line_magic('time', "df.to_sql(name = 'yellow_taxi_data', con=engine, if_exists = 'append')")

while True:
    t_start = time()
    
    df = next(df_iter)
    
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    
    df.to_sql(name = 'yellow_taxi_data', con=engine, if_exists = 'append')
    
    t_end = time()
    
    print("inserting another chunk...took %.3f second" % (t_end - t_start))

