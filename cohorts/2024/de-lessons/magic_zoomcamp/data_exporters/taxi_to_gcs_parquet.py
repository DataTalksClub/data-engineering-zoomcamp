from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_green_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """

    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    bucket_name = 'mage-zoomcamp-ellacharmed'
    object_key = 'nyc_taxi_data.parquet'
    where = f'{bucket_name}/{object_key}'

    # gcs = pa.fs.GcsFileSystem()
    print(df.shape)
    # table = pa.Table.from_pandas(df, preserve_index=False)

    # def coerce_timestamps(data):
    #     data['lpep_pickup_date'] = pd.to_datetime(data['lpep_pickup_datetime'])
    #     data['lpep_dropoff_date'] = pd.to_datetime(data['lpep_dropoff_datetime'])
    #     return data

    GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df, #.apply(coerce_timestamps, axis=1),
        bucket_name,
        object_key,
    )

    # pq.write_table(
    #     table,
    #     where,
    #     # Convert integer columns in Epoch milliseconds
    #     # to Timestamp columns in microseconds ('us') so
    #     # they can be loaded into BigQuery with the right
    #     # data type
    #     coerce_timestamps='us',
    #     filesystem=gcs
    # )

    # print(df.shape)
