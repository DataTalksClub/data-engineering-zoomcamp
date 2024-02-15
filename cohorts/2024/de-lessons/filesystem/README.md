# Readers Source & Filesystem

This verified source easily streams files from AWS S3, GCS, Azure, or local filesystem using the reader source.

Sources and resources that can be used with this verified source are:


| Name            | Type                 | Description                                                               |
|-----------------|----------------------|---------------------------------------------------------------------------|
| readers         | Source               | Lists and reads files with resource `filesystem` and readers transformers |
| filesystem      | Resource             | Lists files in `bucket_url` using `file_glob` pattern                     |
| read_csv        | Resource-transformer | Reads CSV file with "Pandas" chunk by chunk                               |
| read_csv_duckdb | Resource-transformer | Reads CSV file with DuckDB engine chunk by chunk                          |
| read_jsonl      | Resource-transformer | Reads JSONL file content and extracts the data                            |
| read_parquet    | Resource-transformer | Reads Parquet file content and extracts the data with "Pyarrow"           |


## Initialize the source

```shell
dlt init filesystem duckdb
```

Here, we chose `duckdb` as the destination. Alternatively, you can also choose `redshift`, `bigquery`, or
any of the other [destinations.](https://dlthub.com/docs/dlt-ecosystem/destinations/)

## Setup verified source

To grab the credentials for AWS S3, Google Cloud Storage, Azure cloud storage and initialize the
pipeline, please refer to the
[full documentation here.](https://dlthub.com/docs/dlt-ecosystem/verified-sources/filesystem)

## Add credentials

1. In the `.dlt` folder, there's a file called `secrets.toml`. It's where you store sensitive
   information securely, like access tokens. Keep this file safe. Here's its format for service
   account authentication:

   ```toml
   [sources.filesystem.credentials] # use [sources.readers.credentials] for the "readers" source
   # For AWS S3 access:
   aws_access_key_id="Please set me up!"
   aws_secret_access_key="Please set me up!"

   # For GCS storage bucket access:
   client_email="Please set me up!"
   private_key="Please set me up!"
   project_id="Please set me up!"

   # For Azure blob storage access:
   azure_storage_account_name="Please set me up!"
   azure_storage_account_key="Please set me up!"
   ```

1. Finally, enter credentials for your chosen destination as per the [docs](../destinations/).

1. You can pass the bucket URL and glob pattern or use `config.toml`. For local filesystems, use
   `file://` or skip the schema.

   ```toml
   [sources.filesystem] # use [sources.readers.credentials] for the "readers" source
   bucket_url="~/Documents/csv_files/"
   file_glob="*"
   ```

   For remote file systems you need to add the schema, it will be used to get the protocol being
   used, for example:

   ```toml
   [sources.filesystem] # use [sources.readers.credentials] for the "readers" source
   bucket_url="s3://my-bucket/csv_files/"
   ```

## Usage

Use `filesystem` as a
[standalone resource](https://dlthub.com/docs/general-usage/resource#declare-a-standalone-resource),
to enumerate S3, GCS, and Azure bucket files.

```python
files = filesystem(bucket_url="s3://my_bucket/data", file_glob="csv_folder/*.csv")
pipeline.run(files)
```

Use `readers` source to enumerate and **read** chunked
`csv`, `jsonl` and `parquet`  bucket files.

```python
files = readers(
    bucket_url="s3://my_bucket/data", file_glob="csv_folder/*.csv"
).read_csv()
pipeline.run(files.with_name("table_name"))
```

We advise that you give each resource a specific name (`with_name` in the example above)
before loading with `pipeline.run`.
This will make sure that data goes to a table with the name you
want and that each pipeline uses a
separate state for incremental loading.

> To add a new file reader is straightforward. For demos, see
[filesystem_pipeline.py](../filesystem_pipeline.py). We welcome contributions for any file types,
including PDFs and Excel files.

💡 To explore additional customizations for this pipeline,
we recommend referring to the official `dlt` [Readers Source & Filesystem verified
source](https://dlthub.com/docs/dlt-ecosystem/verified-sources/filesystem) documentation. It provides comprehensive information
and guidance on how to further customize and tailor the
pipeline to suit your specific needs.