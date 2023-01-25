import pandas as pd
import os
from sqlalchemy import create_engine
import numpy as np
from time import time
import argparse



def main(params):
    
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db 
    table_name = params.table_name
    url = params.url
    file_name = 'output.parquet'
    
    os.system(f"wget {url} -O {file_name}")
    
    df = pd.read_parquet(file_name)
    
    pd.to_datetime(df.tpep_pickup_datetime)
    pd.to_datetime(df.tpep_dropoff_datetime)

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()

    statement = pd.io.sql.get_schema(df, name=table_name)

    for chunk in np.array_split(df, 100000):
        t_start = time()
        chunk.to_sql(name=table_name, con=engine, if_exists='append')
        t_end = time()
        
        print('inserted chunk, took %.3f seconds' % (t_end-t_start))
        

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








