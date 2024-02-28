import io
import pandas as pd
import requests
from tqdm import tqdm
from tqdm.gui import tqdm as tqdm_gui
tqdm.pandas(desc="Concatenating DataFrames")
from time import time
if 'utils' not in globals():
    from magic_zoomcamp.utils.shared import camel_to_snake
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

taxi_dtypes = {
    'VendorID':str,
    'passenger_count':str,
    'trip_distance': str,
    'RatecodeID':str,
    'store_and_fwd_flag':str,
    'PULocationID':str,
    'DOLocationID':str,
    'payment_type':str,
    'fare_amount': str,
    'extra':str,
    'mta_tax':str,
    'tip_amount':str,
    'tolls_amount':str,
    'improvement_surcharge':str,
    'total_amount':str,
    'congestion_surcharge':str
    }

fhv_dtypes = {
    'dispatching_base_num':str,
    'Affiliated_base_number':str,
    'PUlocationID':str,
    'DOlocationID':str,
    'SR_Flag':str
}

service_dataframes = []
df_final = pd.DataFrame()

@data_loader
def get_year_service(*args, **kwargs):
    
    service = 'yellow'
    for year in ['2019', '2020']:
        service_dataframes.append(load_data_from_api(year, service))
        print()
    # load_data_from_api('2020', 'green')
    # load_data_from_api('2019', 'yellow')
    # load_data_from_api('2020', 'yellow')
    # load_data_from_api('2019', 'fhv')
    tqdm.pandas(desc="Concatenating DataFrames")
    df_final = pd.concat(service_dataframes, ignore_index=True)
    print()
    print(f"Final dataframe's shape for service {service}: {df_final.shape}")
    print(f'-----------SERVICE DONE ---------------------------')
    print()
    return df_final


def match_dates_column_names(service, df):

    match service:
        case 'green':
            df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
            df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])
        case 'yellow':
            df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
            df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
        case 'fhv':
            df['pickup_datetime'] = pd.to_datetime(df['pickup_datetime'])
            df['dropOff_datetime'] = pd.to_datetime(df['dropOff_datetime']) 
    
    return df


def load_data_from_api(year, service, *args, **kwargs):
    """

    """
    # setup the vars
    # Create empty list to store DataFrames
    year_dataframes = []

    print(f'----------- YEAR {year} STARTs ---------------------------')
    print(f'Reading {year} and {service}')
    if service == 'fhv':
        service_dtypes=fhv_dtypes
    else:
        service_dtypes=taxi_dtypes
    
    print(f'Reading year: {year}\tservice: {service}\tservice_dtypes: {service_dtypes}')

    base_url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

    # Iterate through months and download data
    for month in range(1,3):
        print(month)

        # build the csv filename and url
        filename = f"{service}_tripdata_{year}-{month:02d}.csv.gz"
        print(filename)
        url = f"{base_url}/{service}/{filename}"
        # print(url)
        print()

        # native date parsing 
        match service:
            case 'green':
                parse_dates = [
                    'lpep_pickup_datetime', 
                    'lpep_dropoff_datetime'
                ]
            case 'yellow':
                parse_dates = [
                    'tpep_pickup_datetime', 
                    'tpep_dropoff_datetime'
                ]
            case 'fhv':
                parse_dates = [
                    'pickup_datetime', 
                    'dropOff_datetime'
                ]

        response = requests.get(url, stream=True)

        if response.status_code == 200:
            # if url is good, start the process
            results = []
            mth_df = pd.DataFrame()  # Initialize empty DataFrame
            
            with pd.read_csv(
                    url,
                    sep=',',
                    compression='gzip',
                    dtype=service_dtypes,
                    parse_dates=parse_dates,
                    low_memory=False,
                    iterator=True,
                    chunksize=450000) as df_iter:

                for chunk in tqdm(df_iter, desc="Reading & Appending Chunks"):
                    start_time = time()  # Use more accurate perf_counter

                    results.append(chunk)
                    mth_df = pd.concat(results, ignore_index=True)

                    end_time = time()
                    elapsed_time = end_time - start_time
                    print(f"Chunk {len(results)}: processed {chunk.shape[0]} rows in {elapsed_time:.3f} seconds")
            
            # fixes mth_df's dates datatypes to dt.datetime
            mth_df = match_dates_column_names(service=service, df=mth_df)
            # Append monthly DataFrame to the list
            print(f"Year {year} Monthly dataframe's shape: {mth_df.shape}")
            year_dataframes.append(mth_df)
            print(f'Length of year_dataframes: {len(year_dataframes)}')
            print(f"Dataframe from {filename} appended!")
            print(f'----------- MONTH {month} DONE ---------------------------')
            print()
        
        else:
            print(f"Failed to download {filename}. Status code: {response.status_code}")
        

    # Concatenate DataFrames for the year and loop another year, if exist
    combined_df = pd.concat(year_dataframes, ignore_index=True)
    print(f"Year {year} dataframe's shape for service {service}: {combined_df.shape}")
    print(f'----------- YEAR {year} DONE ---------------------------')
    print()
    return combined_df



@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
