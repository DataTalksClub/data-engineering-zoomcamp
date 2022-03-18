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


def extract(file_dir: os.path, raw_file_path: os.path) -> None:
    url = "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv"
    if not os.path.exists(raw_file_path):    
        os.makedirs(os.path.dirname(raw_file_path), exist_ok=True)
        urlretrieve(url=url, filename=raw_file_path)
    else:
        print("Already downloaded that data :)")

def transform(df: pd.DataFrame) -> pd.DataFrame:
    df = set_datetime_col_dtypes_for_taxi_data(df)
    return df

def load(raw_file_path: os.path, engine: Engine) -> None:
    already_loaded_first_chunk = False
    start_time = time()
    chunk_loaded_times = [start_time]
    taxi_df_iter = pd.read_csv(raw_file_path, iterator=True, chunksize=100000)
    for taxi_df_chunk in taxi_df_iter:
        taxi_df_chunk = transform(taxi_df_chunk)
        if not already_loaded_first_chunk:
            taxi_df_chunk.head(0).to_sql(name="yellow_taxi_data", con=engine, if_exists="replace")
            already_loaded_first_chunk = True
        taxi_df_chunk.to_sql(name="yellow_taxi_data", con=engine, if_exists="append")
        chunk_loaded_times.append(time())
        print(
            f"Chunks loaded: {len(chunk_loaded_times)-1:2}, " + 
            f"time to load last chunk: {chunk_loaded_times[-1] - chunk_loaded_times[-2]:3}s")
    print("Successfully loaded the chunks")


def main():
    file_dir = os.path.dirname(os.path.abspath(__file__))
    raw_file_path = os.path.join(
        file_dir, "ny_taxi_postgres_data_raw", "yellow_tripdata_2021-01.csv"
    )
    engine = create_engine("postgresql://root:root@localhost:5432/ny_taxi")
    extract(file_dir, raw_file_path)
    load(raw_file_path, engine)


if __name__ == "__main__":
    main()    