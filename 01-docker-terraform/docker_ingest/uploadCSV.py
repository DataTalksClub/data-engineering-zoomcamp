#!/usr/bin/env python
# coding: utf-8

import argparse
import pandas as pd
from sqlalchemy import create_engine, text

def main(args):
    # Read CSV from URL
    print(f"Downloading CSV from {args.url}")
    df = pd.read_csv(args.url)
    print(f"Loaded {len(df)} rows.")

    # Connect to PostgreSQL
    engine = create_engine(f'postgresql://{args.user}:{args.password}@{args.host}:{args.port}/{args.db}')

    # Load data into table (replace the table)
    print(f"Writing to table {args.table_name} (replacing if exists)")
    df.to_sql(name=args.table_name, con=engine, if_exists='replace', index=False)

    # Verify insertion
    with engine.connect() as conn:
        count = conn.execute(text(f"SELECT COUNT(*) FROM {args.table_name}")).scalar()
        print(f"Rows in {args.table_name}: {count}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Upload CSV to PostgreSQL")
    parser.add_argument('--user', required=True, help='Postgres user')
    parser.add_argument('--password', required=True, help='Postgres password')
    parser.add_argument('--host', required=True, help='Postgres host')
    parser.add_argument('--port', required=True, help='Postgres port')
    parser.add_argument('--db', required=True, help='Postgres database')
    parser.add_argument('--table_name', required=True, help='Target table name')
    parser.add_argument('--url', required=True, help='CSV file URL or local path')
    args = parser.parse_args()
    main(args)
