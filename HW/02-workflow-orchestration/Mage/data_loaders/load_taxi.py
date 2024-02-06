import pandas as pd

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader

if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

taxi_dtypes = {
    'VendorID': pd.Int64Dtype(),
    'passenger_count': pd.Int64Dtype(),
    'trip_distance': float,
    'RatecodeID': pd.Int64Dtype(),
    'store_and_fwd_flag': str,
    'PULocationID': pd.Int64Dtype(),
    'DOLocationID': pd.Int64Dtype(),
    'payment_type': pd.Int64Dtype(),
    'fare_amount': float,
    'extra': float,
    'mta_tax': float,
    'tip_amount':float,
    'tolls_amount': float,
    'improvement_surcharge': float,
    'total_amount': float,
    'congestion_surcharge': float
    }


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    This function loads data from the specified API urls and returns a concatenated dataframe.
    It uses the data_loader decorator to handle any errors that may occur during the loading process.
    The data is parsed using the specified data types and dates. The output is a pandas dataframe.
    """
    
    urls = [
        'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2020-10.csv.gz'
        ,
        'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2020-11.csv.gz'
        ,
        'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2020-12.csv.gz'
        ]

    parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

    return pd.concat([pd.read_csv(url, sep=',', compression='gzip', dtype=
        taxi_dtypes, parse_dates=parse_dates) for url in urls], axis=0,
        ignore_index=True)


@test
def test_output(output, *args) ->None:
    """This function is used for testing the output of a block of code. It takes in the output and any additional arguments and checks if the output is defined. It uses the test decorator to handle any errors that may occur during the testing process. The output is a None type.
Template code for testing the output of the block.

    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
