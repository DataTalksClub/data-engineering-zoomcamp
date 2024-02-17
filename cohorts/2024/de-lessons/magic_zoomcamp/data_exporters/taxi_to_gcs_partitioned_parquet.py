import pyarrow as pa
import pyarrow.parquet as pq
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

# os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "{{ env_var('GOOGLE_SERVICE_ACC_KEY_FILEPATH') }}"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/.secrets/nyc-rides-ella-d8109977b99b.json"

bucket_name = 'mage-zoomcamp-ellacharmed'
project_id = 'nyc-rides-ella'
table_name = 'nyc_taxi_data'

root_path = f'{bucket_name}/{table_name}'

@data_exporter
def export_partitioned_green_data(data, *args, **kwargs):

    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=['tpep_pickup_date'],
        filesystem=gcs
    )