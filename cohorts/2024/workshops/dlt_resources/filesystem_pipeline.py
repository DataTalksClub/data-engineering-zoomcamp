import os
import posixpath
from typing import Iterator

import dlt
from dlt.sources import TDataItems

try:
    from .filesystem import FileItemDict, filesystem, readers, read_csv  # type: ignore
except ImportError:
    from filesystem import (
        FileItemDict,
        filesystem,
        readers,
        read_csv,
    )


TESTS_BUCKET_URL = posixpath.abspath("../tests/filesystem/samples/")


def stream_and_merge_csv() -> None:
    """Demonstrates how to scan folder with csv files, load them in chunk and merge on date column with the previous load"""
    pipeline = dlt.pipeline(
        pipeline_name="standard_filesystem_csv",
        destination='duckdb',
        dataset_name="met_data",
    )
    # met_data contains 3 columns, where "date" column contain a date on which we want to merge
    # load all csvs in A801
    met_files = readers(
        bucket_url=TESTS_BUCKET_URL, file_glob="met_csv/A801/*.csv"
    ).read_csv()
    # tell dlt to merge on date
    met_files.apply_hints(write_disposition="merge", merge_key="date")
    # NOTE: we load to met_csv table
    load_info = pipeline.run(met_files.with_name("met_csv"))
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)

    # now let's simulate loading on next day. not only current data appears but also updated record for the previous day are present
    # all the records for previous day will be replaced with new records
    met_files = readers(
        bucket_url=TESTS_BUCKET_URL, file_glob="met_csv/A801/*.csv"
    ).read_csv()
    met_files.apply_hints(write_disposition="merge", merge_key="date")
    load_info = pipeline.run(met_files.with_name("met_csv"))

    # you can also do dlt pipeline standard_filesystem_csv show to confirm that all A801 were replaced with A803 records for overlapping day
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


def read_csv_with_duckdb() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="standard_filesystem",
        destination='duckdb',
        dataset_name="met_data_duckdb",
    )

    # load all the CSV data, excluding headers
    met_files = readers(
        bucket_url=TESTS_BUCKET_URL, file_glob="met_csv/A801/*.csv"
    ).read_csv_duckdb(chunk_size=1000, header=True)

    load_info = pipeline.run(met_files)

    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


def read_csv_duckdb_compressed() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="standard_filesystem",
        destination='duckdb',
        dataset_name="taxi_data",
        full_refresh=True,
    )

    met_files = readers(
        bucket_url=TESTS_BUCKET_URL,
        file_glob="gzip/*",
    ).read_csv_duckdb()

    load_info = pipeline.run(met_files)
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


def read_parquet_and_jsonl_chunked() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="standard_filesystem",
        destination='duckdb',
        dataset_name="teams_data",
    )
    # When using the readers resource, you can specify a filter to select only the files you
    # want to load including a glob pattern. If you use a recursive glob pattern, the filenames
    # will include the path to the file inside the bucket_url.

    # JSONL reading (in large chunks!)
    jsonl_reader = readers(TESTS_BUCKET_URL, file_glob="**/*.jsonl").read_jsonl(
        chunksize=10000
    )
    # PARQUET reading
    parquet_reader = readers(TESTS_BUCKET_URL, file_glob="**/*.parquet").read_parquet()
    # load both folders together to specified tables
    load_info = pipeline.run(
        [
            jsonl_reader.with_name("jsonl_team_data"),
            parquet_reader.with_name("parquet_team_data"),
        ]
    )
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


def read_custom_file_type_excel() -> None:
    """Here we create an extract pipeline using filesystem resource and read_csv transformer"""

    # instantiate filesystem directly to get list of files (FileItems) and then use read_excel transformer to get
    # content of excel via pandas

    @dlt.transformer(standalone=True)
    def read_excel(
        items: Iterator[FileItemDict], sheet_name: str
    ) -> Iterator[TDataItems]:
        import pandas as pd

        for file_obj in items:
            with file_obj.open() as file:
                yield pd.read_excel(file, sheet_name).to_dict(orient="records")

    freshman_xls = filesystem(
        bucket_url=TESTS_BUCKET_URL, file_glob="../custom/freshman_kgs.xlsx"
    ) | read_excel("freshman_table")

    load_info = dlt.run(
        freshman_xls.with_name("freshman"),
        destination='duckdb',
        dataset_name="freshman_data",
    )
    print(load_info)


def copy_files_resource(local_folder: str) -> None:
    """Demonstrates how to copy files locally by adding a step to filesystem resource and the to load the download listing to db"""
    pipeline = dlt.pipeline(
        pipeline_name="standard_filesystem_copy",
        destination='duckdb',
        dataset_name="standard_filesystem_data",
    )

    # a step that copies files into test storage
    def _copy(item: FileItemDict) -> FileItemDict:
        # instantiate fsspec and copy file
        dest_file = os.path.join(local_folder, item["file_name"])
        # create dest folder
        os.makedirs(os.path.dirname(dest_file), exist_ok=True)
        # download file
        item.fsspec.download(item["file_url"], dest_file)
        # return file item unchanged
        return item

    # use recursive glob pattern and add file copy step
    downloader = filesystem(TESTS_BUCKET_URL, file_glob="**").add_map(_copy)

    # NOTE: you do not need to load any data to execute extract, below we obtain
    # a list of files in a bucket and also copy them locally
    listing = list(downloader)
    print(listing)

    # download to table "listing"
    # downloader = filesystem(TESTS_BUCKET_URL, file_glob="**").add_map(_copy)
    load_info = pipeline.run(
        downloader.with_name("listing"), write_disposition="replace"
    )
    # pretty print the information on data that was loaded
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


def read_files_incrementally_mtime() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="standard_filesystem_incremental",
        destination='duckdb',
        dataset_name="file_tracker",
    )

    # here we modify filesystem resource so it will track only new csv files
    # such resource may be then combined with transformer doing further processing
    new_files = filesystem(bucket_url=TESTS_BUCKET_URL, file_glob="csv/*")
    # add incremental on modification time
    new_files.apply_hints(incremental=dlt.sources.incremental("modification_date"))
    load_info = pipeline.run((new_files | read_csv()).with_name("csv_files"))
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)

    # load again - no new files!
    new_files = filesystem(bucket_url=TESTS_BUCKET_URL, file_glob="csv/*")
    # add incremental on modification time
    new_files.apply_hints(incremental=dlt.sources.incremental("modification_date"))
    load_info = pipeline.run((new_files | read_csv()).with_name("csv_files"))
    print(load_info)
    print(pipeline.last_trace.last_normalize_info)


if __name__ == "__main__":
    copy_files_resource("_storage")
    stream_and_merge_csv()
    read_parquet_and_jsonl_chunked()
    read_custom_file_type_excel()
    read_files_incrementally_mtime()
    read_csv_with_duckdb()
    read_csv_duckdb_compressed()
