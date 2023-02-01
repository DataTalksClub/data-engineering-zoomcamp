import pandas as pd
from sqlalchemy import create_engine
import argparse
import os

# Needed arguments: user, password, host, port, database name, table name,
# url of the csv

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db_name = params.db_name
    table_name = params.table_name

    csv_name = 'output.parquet'

    os.system(f"wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet -O {csv_name}")
    df = pd.read_parquet(csv_name, engine='pyarrow')
    df.to_csv('output.csv', index=False)
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db_name}')

    df_iter = pd.read_csv('output.csv', iterator=True, chunksize=100000)
    df = next(df_iter)
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
    df.to_sql(name=table_name, con=engine, if_exists='append')

    while True:

        try:
            df_novo = next(df_iter)
            df_novo['tpep_pickup_datetime'] = pd.to_datetime(df_novo['tpep_pickup_datetime'])
            df_novo['tpep_dropoff_datetime'] = pd.to_datetime(df_novo['tpep_dropoff_datetime'])
            df_novo.to_sql(name=table_name, con=engine, if_exists='append')
            print('inserted another chunck ...')

        except StopIteration:
            print('Done')
            break



if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Ingest CSV data to postgres')

    parser.add_argument('user', type = str, help='user name for postgres')
    parser.add_argument('password', type = str, help='password for postgres')
    parser.add_argument('host', type = str, help='host for postgres')
    parser.add_argument('port', type = str, help='port for postgres')
    parser.add_argument('db_name', type = str, help='database name for postgres')
    parser.add_argument('table_name', type = str, help='table name for postgres')

    args = parser.parse_args()

    main(args)
