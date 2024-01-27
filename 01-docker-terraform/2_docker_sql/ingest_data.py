import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name_trip = params.table_name_trip
    table_name_zones = params.table_name_zones
    parquet_url = params.url_parquet
    csv_url = params.url_csv

    parquet_name = "output.parquet"
    csv_name = "output.csv"

    os.system(f"wget {parquet_url} -O {parquet_name}")
    os.system(f"wget {csv_url} -O {csv_name}")

    engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")

    df_trip = pd.read_parquet(parquet_name)
    df_trip.lpep_pickup_datetime = pd.to_datetime(df_trip.lpep_pickup_datetime)
    df_trip.lpep_dropoff_datetime = pd.to_datetime(df_trip.lpep_dropoff_datetime)
    df_trip.head(n=0).to_sql(name=table_name_trip, con=engine, if_exists="replace")
    df_trip.to_sql(name=table_name_trip, con=engine, if_exists="append")

    df_zone = pd.read_csv(csv_name)
    df_zone.head(n=0).to_sql(name=table_name_zones, con=engine, if_exists="replace")
    df_zone.to_sql(name=table_name_zones, con=engine, if_exists="append")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Ingest Parquet data to Postgres")

    parser.add_argument("--user", required=True, help="user name for postgres")
    parser.add_argument("--password", required=True, help="password for postgres")
    parser.add_argument("--host", required=True, help="host for postgres")
    parser.add_argument("--port", required=True, help="port for postgres")
    parser.add_argument("--db", required=True, help="database name for postgres")
    parser.add_argument(
        "--table_name_trip",
        required=True,
        help="name of the table where we will write the results to",
    )
    parser.add_argument(
        "--table_name_zones",
        required=True,
        help="name of the table where we will write the results to",
    )
    parser.add_argument("--url_parquet", required=True, help="url of the parquet file")
    parser.add_argument("--url_csv", required=True, help="url of the csv file")

    args = parser.parse_args()

    main(args)
