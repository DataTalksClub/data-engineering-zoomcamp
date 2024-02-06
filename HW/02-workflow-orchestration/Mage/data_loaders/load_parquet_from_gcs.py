import pyarrow as pa
import pyarrow
import os

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="/home/src/key.json"
bucket_name="mage-zoomcamp-ems"
project_id="banded-pad-411838"

table_name="green_taxi_data.parquet"
root_path= f'{bucket_name}/{table_name}'

@data_loader
def load_data(*args, **kwargs):
    """
    Template code for loading data from any source.

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Specify your data loading logic here
    #gs = gcsfs.GCSFileSystem()
    gs = pa.fs.GcsFileSystem()
    arrow_df = pyarrow.parquet.ParquetDataset(root_path, filesystem=gs)
    return arrow_df.read_pandas().to_pandas()
    

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'