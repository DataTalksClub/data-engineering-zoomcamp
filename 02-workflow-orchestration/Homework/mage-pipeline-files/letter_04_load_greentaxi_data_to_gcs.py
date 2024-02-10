import pyarrow as pa
import pyarrow.parquet as pq 
import os 


if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOLGE_APPLICATION_CREDENTIALS'] = "/home/src/polished-will-411520-2435381a85a8.json"

bucket_name = 'terraform-demo-terra-bucket-kashif'
table_name ="green_taxi_data"
root_path = f'{bucket_name}/{table_name}'
partition_col = ['lpep_pickup_date']

@data_exporter
def export_data(data, *args, **kwargs):

    table = pa.Table.from_pandas(data)
    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=partition_col,
        filesystem=gcs,
        existing_data_behavior="delete_matching"
    )