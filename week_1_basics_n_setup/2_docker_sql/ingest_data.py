#!/usr/bin/env python
# coding: utf-8

import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import urlparse


class IngestData(object):
    """Ingestion data pipeline

    Args:
        object (_type_): _description_
    """

    def __init__(self, params):
        # self.params = params
        self.user = params.user
        self.password = params.password
        self.host = params.host
        self.port = params.port
        self.db = params.db
        self.table_name = params.table_name
        self.url = params.url
        self.df_iter = self.download_read_csv()
        self.engine = self.create_db_conn()

    def download_read_csv(self):
        """Download CSV file read and return dataframe iter"""
        # the backup files are gzipped, and it's important to keep the correct extension
        # for pandas to be able to open the file
        file_url = urlparse(self.url)
        if self.url.endswith(".csv.gz"):
            csv_name = "output.csv.gz"
        else:
            csv_name = "output.csv"

        os.system(f"wget {self.url} -o {csv_name}")
        csv_name = os.path.basename(file_url.path)
        print(csv_name)
        return pd.read_csv(csv_name, iterator=True, chunksize=100000)

    def transformation(self, df):
        """dataframe transformation."""
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
        return df

    def create_db_conn(self):
        """Create DB connection

        Returns:
            _type_: postgresql DB connection
        """
        engine = create_engine(
            f"postgresql://{self.user}:{self.password}@{self.host}:{self.port}/{self.db}"
        )
        return engine

    def create_schema(self):
        """Create SQL DB schema"""
        df = next(self.df_iter)
        df = self.transformation(df)
        df.head(n=0).to_sql(name=self.table_name, con=self.engine, if_exists="replace")
        # df.to_sql(name=self.table_name, con=self.engine, if_exists="append")

    def pipeline(self, df):
        """Data Ingestion Pipeline

        Args:
            df (_type_): _description_
        """
        while True:
            try:
                t_start = time()
                df = next(self.df_iter)

                df = self.transformation(df)

                df.to_sql(name=self.table_name, con=self.engine, if_exists="append")

                t_end = time()

                print("inserted another chuck, took %.3f second" % (t_end - t_start))

            except StopIteration:
                print("Finished ingesting data into the postgres database")
                break


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Ingest CSV data to Postgres")

    parser.add_argument("--user", required=True, help="user name for postgres")
    parser.add_argument("--password", required=True, help="password for postgres")
    parser.add_argument("--host", required=True, help="host for postgres")
    parser.add_argument("--port", required=True, help="port for post")
    parser.add_argument("--db", required=True, help="database name for postgres")
    parser.add_argument(
        "--table_name",
        required=True,
        help="name of table where we will write the results to",
    )
    parser.add_argument("--url", required=True, help="url of the csv file")

    args = parser.parse_args()

    # main(args)
    ingestion_pipeline = IngestData(args)  # .pipeline()
    ingestion_pipeline.create_schema()
    ingestion_pipeline.pipeline(ingestion_pipeline.df_iter)
