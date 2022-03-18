import argparse
import os
from urllib.request import urlretrieve
from time import time

import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine.base import Engine


def set_datetime_col_dtypes_for_taxi_data(taxi_df: pd.DataFrame) -> pd.DataFrame:
    date_cols = ["tpep_pickup_datetime", "tpep_dropoff_datetime"]
    for date_col in date_cols:
        taxi_df[date_col] = pd.to_datetime(taxi_df[date_col], format="%Y-%m-%d %H:%M:%S")
    return taxi_df


def extract(url: str, file_dir: os.path, raw_file_path: os.path) -> None:
    if not os.path.exists(raw_file_path):    
        os.makedirs(os.path.dirname(raw_file_path), exist_ok=True)
        urlretrieve(url=url, filename=raw_file_path)
    else:
        print("Already downloaded that data :)")

def transform(df: pd.DataFrame) -> pd.DataFrame:
    df = set_datetime_col_dtypes_for_taxi_data(df)
    return df

def load(raw_file_path: os.path, engine: Engine, table_name: str) -> None:
    already_loaded_first_chunk = False
    start_time = time()
    chunk_loaded_times = [start_time]
    taxi_df_iter = pd.read_csv(raw_file_path, iterator=True, chunksize=100000)
    for taxi_df_chunk in taxi_df_iter:
        taxi_df_chunk = transform(taxi_df_chunk)
        if not already_loaded_first_chunk:
            taxi_df_chunk.head(0).to_sql(name=table_name, con=engine, if_exists="replace")
            already_loaded_first_chunk = True
        taxi_df_chunk.to_sql(name=table_name, con=engine, if_exists="append")
        chunk_loaded_times.append(time())
        print(
            f"Chunks loaded: {len(chunk_loaded_times)-1:2}, " + 
            f"time to load last chunk: {chunk_loaded_times[-1] - chunk_loaded_times[-2]:3}s")
    print("Successfully loaded the chunks")


def get_db_engine(user: str, password: str, host: str, port: str, db_name: str) -> Engine:
	engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db_name}")
	return engine

def main(args: argparse.Namespace):
	if args.raw_file_path is None:
	    file_dir = os.path.dirname(os.path.abspath(__file__))
	    args.raw_file_path = os.path.join(
	    	file_dir, "data_raw", f"{args.table_name}.csv"
	    )
	else:
		file_dir = os.path.dirname(args.raw_file_path)
	engine = get_db_engine(
		user=args.user, password=args.password, host=args.host, port=args.port,
		db_name=args.db_name
	)
	extract(url=args.url, file_dir=file_dir, raw_file_path=args.raw_file_path)
	load(raw_file_path=args.raw_file_path, engine=engine, table_name=args.table_name)


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Ingest CSV data to Postgres")
	parser.add_argument("--user", required=True, help="user name for postgres")
	parser.add_argument("--password", required=True, help="password for postgres")
	parser.add_argument("--host", required=True, help="host for postgres")
	parser.add_argument("--port", required=True, help="port for postgres")
	parser.add_argument("--db_name", required=True, help="database name")
	parser.add_argument("--table_name", required=True, help="name of the db table")
	parser.add_argument("--url", required=True, help="url of the data file")
	parser.add_argument("--raw_file_path", required=True, help="Location to store raw csv file", default=None)
	args = parser.parse_args()

	main(args)
