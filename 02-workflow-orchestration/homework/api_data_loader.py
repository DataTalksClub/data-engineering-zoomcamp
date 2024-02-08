import pandas as pd

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Load data from API for months 10, 11, and 12 of 2020 and create lpep_pickup_date column.
    """
    # Initialize an empty list to store data for each month
    data_list = []

    # Loop through months 10, 11, and 12
    for i in [10, 11, 12]:
        url_green_taxi = f'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2020-{i}.csv.gz'

        taxi_dtypes = {
            'VendorID': 'Int64',
            'store_and_fwd_flag': 'str',
            'RatecodeID': 'Int64',
            'PULocationID': 'Int64',
            'DOLocationID': 'Int64',
            'passenger_count': 'Int64',
            'trip_distance': 'float64',
            'fare_amount': 'float64',
            'extra': 'float64',
            'mta_tax': 'float64',
            'tip_amount': 'float64',
            'tolls_amount': 'float64',
            'ehail_fee': 'float64',
            'improvement_surcharge': 'float64',
            'total_amount': 'float64',
            'payment_type': 'float64',
            'trip_type': 'float64',
            'congestion_surcharge': 'float64'
        }
        
        # Read data for the current month
        data_month = pd.read_csv(url_green_taxi, sep=',', compression='gzip', dtype=taxi_dtypes)
        # Append data for the current month to the list
        data_list.append(data_month)

    # Concatenate data for all months
    data = pd.concat(data_list)
    print(len(data))

    return data

