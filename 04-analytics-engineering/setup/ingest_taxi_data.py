#!/usr/bin/env python3

import argparse
from pathlib import Path

import duckdb
import requests

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"


def parse_years(value: str) -> list[int]:
    years: list[int] = []
    for chunk in value.split(","):
        chunk = chunk.strip()
        if not chunk:
            continue
        if "-" in chunk:
            start_str, end_str = chunk.split("-", 1)
            start, end = int(start_str), int(end_str)
            years.extend(range(start, end + 1))
        else:
            years.append(int(chunk))
    return sorted(set(years))


def download_csv_gz(url: str, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    with requests.get(url, stream=True, timeout=60) as resp:
        resp.raise_for_status()
        with open(dst, "wb") as f:
            for chunk in resp.iter_content(chunk_size=1024 * 1024):
                if chunk:
                    f.write(chunk)


def convert_csv_gz_to_parquet(csv_gz_path: Path, parquet_path: Path) -> None:
    parquet_path.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect()
    con.execute(
        f"""
        COPY (SELECT * FROM read_csv_auto('{csv_gz_path}'))
        TO '{parquet_path}' (FORMAT PARQUET)
        """
    )
    con.close()


def ingest(
    taxi_types: list[str],
    years: list[int],
    months: list[int],
    data_dir: Path,
    db_path: Path,
    keep_csv_gz: bool,
) -> None:
    for taxi_type in taxi_types:
        for year in years:
            for month in months:
                parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
                parquet_path = data_dir / taxi_type / parquet_filename
                if parquet_path.exists():
                    print(f"Skipping {parquet_filename} (already exists)")
                    continue

                csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
                csv_gz_path = data_dir / taxi_type / csv_gz_filename
                url = f"{BASE_URL}/{taxi_type}/{csv_gz_filename}"

                print(f"Downloading {csv_gz_filename} ...")
                download_csv_gz(url, csv_gz_path)

                print(f"Converting {csv_gz_filename} to Parquet ...")
                convert_csv_gz_to_parquet(csv_gz_path, parquet_path)

                if not keep_csv_gz:
                    csv_gz_path.unlink(missing_ok=True)

    print(f"Loading Parquet files into DuckDB: {db_path}")
    db_path.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(db_path))
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    for taxi_type in taxi_types:
        con.execute(
            f"""
            CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
            SELECT * FROM read_parquet('{(data_dir / taxi_type).as_posix()}/*.parquet', union_by_name=true)
            """
        )

    con.close()
    print("Done.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Download NYC TLC taxi CSV.gz files, convert to Parquet, and load into DuckDB (prod schema)."
    )
    parser.add_argument(
        "--taxi-types",
        default="yellow,green",
        help="Comma-separated taxi types (default: yellow,green).",
    )
    parser.add_argument(
        "--years",
        default="2019-2020",
        help="Years as comma list and/or ranges (default: 2019-2020).",
    )
    parser.add_argument(
        "--months",
        default="1-12",
        help="Months as comma list and/or ranges (default: 1-12).",
    )
    parser.add_argument(
        "--data-dir",
        default="data",
        help="Directory for downloaded/converted files (default: data).",
    )
    parser.add_argument(
        "--db-path",
        default="taxi_rides_ny.duckdb",
        help="DuckDB database file path (default: taxi_rides_ny.duckdb).",
    )
    parser.add_argument(
        "--keep-csv-gz",
        action="store_true",
        help="Keep downloaded .csv.gz files (default: delete after Parquet conversion).",
    )
    args = parser.parse_args()

    taxi_types = [t.strip() for t in args.taxi_types.split(",") if t.strip()]
    years = parse_years(args.years)
    months = parse_years(args.months)
    months = [m for m in months if 1 <= m <= 12]
    if not months:
        raise SystemExit("No valid months parsed (expected 1-12).")

    ingest(
        taxi_types=taxi_types,
        years=years,
        months=months,
        data_dir=Path(args.data_dir),
        db_path=Path(args.db_path),
        keep_csv_gz=bool(args.keep_csv_gz),
    )


if __name__ == "__main__":
    main()

