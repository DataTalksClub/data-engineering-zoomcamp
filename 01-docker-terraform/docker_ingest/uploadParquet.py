#!/usr/bin/env python
# coding: utf-8

import os
import argparse
import io
import requests
import pandas as pd
from sqlalchemy import create_engine, text
import pyarrow.parquet as pq

def main(params):
    # Extract parameters
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    # Download the parquet file directly into memory
    print(f"Downloading parquet data from {url}")
    response = requests.get(url, stream=True)
    response.raise_for_status()  # Check for errors

    parquet_file = io.BytesIO(response.content)

    # Read the Parquet file into a pandas DataFrame
    print("Reading parquet file into pandas DataFrame")
    table = pq.read_table(parquet_file)
    df = table.to_pandas()

    # Debug info (optional)
    print("DataFrame columns:", df.columns)
    print("First few rows:\n", df.head())
    print("DataFrame shape:", df.shape)

    # Connect to PostgreSQL
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Always overwrite the table
    print(f"Writing dataframe to table {table_name} (will replace any existing data)")
    df.to_sql(name=table_name, con=engine, if_exists='replace')
    print("Data ingestion complete.")

    # Verify number of rows inserted
    with engine.connect() as conn:
        # Wrap raw SQL in text() for compatibility with SQLAlchemy >=1.4
        result = conn.execute(text(f"SELECT COUNT(*) FROM {table_name}"))
        row_count = result.scalar()
        print(f"Number of rows in {table_name}: {row_count}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Download Parquet file from URL and ingest into PostgreSQL')
    parser.add_argument('--user', required=True, help='Postgres user')
    parser.add_argument('--password', required=True, help='Postgres password')
    parser.add_argument('--host', required=True, help='Postgres host')
    parser.add_argument('--port', required=True, help='Postgres port')
    parser.add_argument('--db', required=True, help='Postgres database')
    parser.add_argument('--table_name', required=True, help='Target table name')
    parser.add_argument('--url', required=True, help='URL of the Parquet file')

    args = parser.parse_args()
    main(args)
