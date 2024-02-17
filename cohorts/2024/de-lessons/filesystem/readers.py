from typing import TYPE_CHECKING, Any, Dict, Iterator, Optional

from dlt.common import json
from dlt.common.typing import copy_sig
from dlt.sources import TDataItems, DltResource, DltSource
from dlt.sources.filesystem import FileItemDict

from .helpers import fetch_arrow, fetch_json


def _read_csv(
    items: Iterator[FileItemDict], chunksize: int = 10000, **pandas_kwargs: Any
) -> Iterator[TDataItems]:
    """Reads csv file with Pandas chunk by chunk.

    Args:
        chunksize (int): Number of records to read in one chunk
        **pandas_kwargs: Additional keyword arguments passed to Pandas.read_csv
    Returns:
        TDataItem: The file content
    """
    import pandas as pd

    # apply defaults to pandas kwargs
    kwargs = {**{"header": "infer", "chunksize": chunksize}, **pandas_kwargs}

    for file_obj in items:
        # Here we use pandas chunksize to read the file in chunks and avoid loading the whole file
        # in memory.
        with file_obj.open() as file:
            for df in pd.read_csv(file, **kwargs):
                yield df.to_dict(orient="records")


def _read_jsonl(
    items: Iterator[FileItemDict], chunksize: int = 1000
) -> Iterator[TDataItems]:
    """Reads jsonl file content and extract the data.

    Args:
        chunksize (int, optional): The number of JSON lines to load and yield at once, defaults to 1000

    Returns:
        TDataItem: The file content
    """
    for file_obj in items:
        with file_obj.open() as f:
            lines_chunk = []
            for line in f:
                lines_chunk.append(json.loadb(line))
                if len(lines_chunk) >= chunksize:
                    yield lines_chunk
                    lines_chunk = []
        if lines_chunk:
            yield lines_chunk


def _read_parquet(
    items: Iterator[FileItemDict],
    chunksize: int = 10,
) -> Iterator[TDataItems]:
    """Reads parquet file content and extract the data.

    Args:
        chunksize (int, optional): The number of files to process at once, defaults to 10.

    Returns:
        TDataItem: The file content
    """
    from pyarrow import parquet as pq

    for file_obj in items:
        with file_obj.open() as f:
            parquet_file = pq.ParquetFile(f)
            for rows in parquet_file.iter_batches(batch_size=chunksize):
                yield rows.to_pylist()


def _read_csv_duckdb(
    items: Iterator[FileItemDict],
    chunk_size: Optional[int] = 5000,
    use_pyarrow: bool = False,
    **duckdb_kwargs: Any
) -> Iterator[TDataItems]:
    """A resource to extract data from the given CSV files.

    Uses DuckDB engine to import and cast CSV data.

    Args:
        items (Iterator[FileItemDict]): CSV files to read.
        chunk_size (Optional[int]):
            The number of rows to read at once. Defaults to 5000.
        use_pyarrow (bool):
            Whether to use `pyarrow` to read the data and designate
            data schema. If set to False (by default), JSON is used.
        duckdb_kwargs (Dict):
            Additional keyword arguments to pass to the `read_csv()`.

    Returns:
        Iterable[TDataItem]: Data items, read from the given CSV files.
    """
    import duckdb

    helper = fetch_arrow if use_pyarrow else fetch_json

    for item in items:
        with item.open() as f:
            file_data = duckdb.from_csv_auto(f, **duckdb_kwargs)  # type: ignore

            yield from helper(file_data, chunk_size)


if TYPE_CHECKING:

    class ReadersSource(DltSource):
        """This is a typing stub that provides docstrings and signatures to the resources in `readers" source"""

        @copy_sig(_read_csv)
        def read_csv(self) -> DltResource:
            ...

        @copy_sig(_read_jsonl)
        def read_jsonl(self) -> DltResource:
            ...

        @copy_sig(_read_parquet)
        def read_parquet(self) -> DltResource:
            ...

        @copy_sig(_read_csv_duckdb)
        def read_csv_duckdb(self) -> DltResource:
            ...

else:
    ReadersSource = DltSource
