import pandas as pd


def get_sample_taxi_data():
    """Sample taxi data for testing"""
    return pd.DataFrame({
        'tpep_pickup_datetime': [
            '2021-01-01 00:30:10',
            '2021-01-01 00:51:20',
            '2021-01-01 00:09:00'
        ],
        'tpep_dropoff_datetime': [
            '2021-01-01 00:45:39',
            '2021-01-01 01:07:15',
            '2021-01-01 00:18:12'
        ],
        'passenger_count': [1, 1, 1],
        'trip_distance': [2.10, 0.20, 1.60],
        'fare_amount': [8.0, 3.0, 7.0]
    })


def get_sample_csv_content():
    """Sample CSV content as string"""
    return """tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,fare_amount
2021-01-01 00:30:10,2021-01-01 00:45:39,1,2.10,8.0
2021-01-01 00:51:20,2021-01-01 01:07:15,1,0.20,3.0
2021-01-01 00:09:00,2021-01-01 00:18:12,1,1.60,7.0"""
