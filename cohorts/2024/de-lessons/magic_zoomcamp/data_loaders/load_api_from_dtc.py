import io
import pandas as pd
import requests
if 'utils' not in globals():
    from magic_zoomcamp.utils.shared import camel_to_snake
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    - use Pandas to read data for the final quarter of 2020 (months 10, 11, 12)
    - use the same datatypes and date parsing methods shown in the course
    - load the final three months using a for loop and pd.concat
    """

    taxi_dtypes = {
                'VendorID': pd.Int64Dtype(),
                'passenger_count': pd.Int64Dtype(),
                'trip_distance': float,
                'RatecodeID':pd.Int64Dtype(),
                'store_and_fwd_flag':str,
                'PULocationID':pd.Int64Dtype(),
                'DOLocationID':pd.Int64Dtype(),
                'payment_type': pd.Int64Dtype(),
                'fare_amount': float,
                'extra':float,
                'mta_tax':float,
                'tip_amount':float,
                'tolls_amount':float,
                'improvement_surcharge':float,
                'total_amount':float,
                'congestion_surcharge':float
            }

    # native date parsing 
    parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

    # setup the vars
    months = [10, 11, 12]
    year = 2020
    colour = 'green'
    base_url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

    # Create empty list to store DataFrames
    dataframes = []

    # Iterate through months and download data
    for month in months:
        # print(month)
        
        filename = f"{colour}_tripdata_{year}-{month:02d}.csv.gz"
        # print(filename)

        url = f"{base_url}/{colour}/{filename}"
        # print(url)
        
        response = requests.get(url, stream=True)

        if response.status_code == 200:
            df = pd.read_csv(
                url
                , sep=','
                , compression='gzip'
                , dtype=taxi_dtypes
                , parse_dates=parse_dates
            ) 

            # Append DataFrame to the list
            dataframes.append(df)
            print(f"Downloaded {filename} successfully!")
        
        else:
            print(f"Failed to download {filename}. Status code: {response.status_code}")

    # Concatenate DataFrames
    return pd.concat(dataframes, ignore_index=True)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
