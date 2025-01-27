import argparse
import os

import pandas as pd
from sqlalchemy import create_engine


def main(params):
    folder_path = params.folder_path

    engine = create_engine("postgresql://root:root@localhost:5432/ny_taxi")
    engine.connect()

    url = (
        "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"
    )
    file_name = "taxi_zone_lookup.csv"

    if folder_path is not None:
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
        else:
            csv_file_path = f"{folder_path}/{file_name}"

            os.system(f"wget {url} -O {csv_file_path}")

            df_zones = pd.read_csv(csv_file_path)
            df_zones.to_sql(name="zones", con=engine, if_exists="replace")
    else:
        os.system(f"wget {url} -O {file_name}")

        df_zones = pd.read_csv("taxi_zone_lookup.csv")
        df_zones.to_sql(name="zones", con=engine, if_exists="replace")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Ingest with the option to save your csv file to a destination folder"
    )
    parser.add_argument(
        "folder_path", nargs="?", default=None, help="Optional: Insert your destination folder path"
    )
    args = parser.parse_args()
    main(args)
