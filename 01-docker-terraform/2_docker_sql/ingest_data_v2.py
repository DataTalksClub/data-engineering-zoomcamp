import pandas as pd
import os
from sqlalchemy import create_engine
from time import time
import argparse

def main(params):
    user = params.user
    pwd = params.pwd
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    csv_name = 'output.csv.gz'
    
    def _set_dtypes(df):
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)    
        return df

    #download file
    os.system(f"wget {url} -O {csv_name}")

    engine = create_engine(f'postgresql://{user}:{pwd}@{host}:{port}/{db}')

    df_iter = pd.read_csv(csv_name, compression="gzip", iterator=True, chunksize=100000)
    df = next(df_iter)

    df = _set_dtypes(df)    

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    while True: 
        t_start = time()

        df = _set_dtypes(df)    
        
        df.to_sql(name=table_name, con=engine, if_exists='append')

        t_end = time()

        print('inserted another chunk, took %.3f second' % (t_end - t_start))
        df = next(df_iter)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data into postgress')
    parser.add_argument('--user', help='username for postgres')
    parser.add_argument('--pwd', help='password for postgres')
    parser.add_argument('--host', help='hostname for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name to output the csv to')
    parser.add_argument('--table_name', help='table name to output the csv to')
    parser.add_argument('--url', help='URL leading to the csv-file')

    args = parser.parse_args()

    main(args)



