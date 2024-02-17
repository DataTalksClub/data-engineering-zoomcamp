"""Helpers for the filesystem resource."""
from typing import TYPE_CHECKING, Any, Dict, Iterable, List, Optional, Type, Union
from fsspec import AbstractFileSystem  # type: ignore

from dlt.common.configuration import resolve_type
from dlt.common.typing import TDataItem

from dlt.sources import DltResource
from dlt.sources.filesystem import fsspec_filesystem
from dlt.sources.config import configspec, with_config
from dlt.sources.credentials import (
    CredentialsConfiguration,
    FilesystemConfiguration,
    FileSystemCredentials,
)

from .settings import DEFAULT_CHUNK_SIZE


@configspec
class FilesystemConfigurationResource(FilesystemConfiguration):
    credentials: Union[FileSystemCredentials, AbstractFileSystem]
    file_glob: Optional[str] = "*"
    files_per_page: int = DEFAULT_CHUNK_SIZE
    extract_content: bool = False

    @resolve_type("credentials")
    def resolve_credentials_type(self) -> Type[CredentialsConfiguration]:
        # use known credentials or empty credentials for unknown protocol
        return Union[self.PROTOCOL_CREDENTIALS.get(self.protocol) or Optional[CredentialsConfiguration], AbstractFileSystem]  # type: ignore[return-value]


def fsspec_from_resource(filesystem_instance: DltResource) -> AbstractFileSystem:
    """Extract authorized fsspec client from a filesystem resource"""

    @with_config(
        spec=FilesystemConfiguration,
        sections=("sources", filesystem_instance.section, filesystem_instance.name),
    )
    def _get_fsspec(
        bucket_url: str, credentials: FileSystemCredentials
    ) -> AbstractFileSystem:
        print(bucket_url)
        return fsspec_filesystem(bucket_url, credentials)[0]

    return _get_fsspec(
        filesystem_instance.explicit_args.get("bucket_url", None),
        filesystem_instance.explicit_args.get("credentials", None),
    )


def add_columns(columns: List[str], rows: List[List[Any]]) -> List[Dict[str, Any]]:
    """Adds column names to the given rows.

    Args:
        columns (List[str]): The column names.
        rows (List[List[Any]]): The rows.

    Returns:
        List[Dict[str, Any]]: The rows with column names.
    """
    result = []
    for row in rows:
        result.append(dict(zip(columns, row)))

    return result


def fetch_arrow(file_data, chunk_size: int) -> Iterable[TDataItem]:  # type: ignore
    """Fetches data from the given CSV file.

    Args:
        file_data (DuckDBPyRelation): The CSV file data.
        chunk_size (int): The number of rows to read at once.

    Yields:
        Iterable[TDataItem]: Data items, read from the given CSV file.
    """
    batcher = file_data.fetch_arrow_reader(batch_size=chunk_size)
    yield from batcher


def fetch_json(file_data, chunk_size: int) -> List[Dict[str, Any]]:  # type: ignore
    """Fetches data from the given CSV file.

    Args:
        file_data (DuckDBPyRelation): The CSV file data.
        chunk_size (int): The number of rows to read at once.

    Yields:
        Iterable[TDataItem]: Data items, read from the given CSV file.
    """
    while True:
        batch = file_data.fetchmany(chunk_size)
        if not batch:
            break

        yield add_columns(file_data.columns, batch)
