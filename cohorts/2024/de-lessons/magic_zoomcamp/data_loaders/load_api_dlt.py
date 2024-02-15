import io
import pandas as pd
import pyarrow.parquet as pq
import requests
import dlt
import duckdb
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    url = ''
    response = requests.get(url)
    # define the connection to load to.
    # We now use duckdb, but you can switch to Bigquery later
    pipeline = dlt.pipeline(destination='duckdb', dataset_name='taxi_rides')

    # run the pipeline with default settings, and capture the outcome
    info = pipeline.run(data,
                        table_name="rides",
                        write_disposition="merge",
                        primary_key='record_hash')

    
    # trips = pq.read_table('trips.parquet')
    # trips = trips.to_pandas()

    return pd.read_csv(io.StringIO(response.text), sep=',')


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
