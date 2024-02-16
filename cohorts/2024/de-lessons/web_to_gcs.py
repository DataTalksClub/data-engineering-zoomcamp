import io
import os
import requests
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import fsspec

from google.cloud import storage

"""
Pre-reqs: 
1. `pip install pandas pyarrow google-cloud-storage`
2. Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account key
3. Set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
"""

# services = ['fhv','green','yellow']
base_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
# switch out the bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "mage-zoomcamp-ellacharmed")
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

def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    # storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)


def web_to_gcs(year, service):
    """
    - read in one csv.gz file at a time from DTC source
    - save into one .parquet file per month for the service
    - iterate over the full year for the service
    - save to bucket in datasets by service
    """

    for month in range(1,13):

        # csv file_name
        file_name = f"{service}_tripdata_{year}-{month:02d}.csv.gz"

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

        # download it using requests via a pandas df
        request_url = f"{base_url}{service}/{file_name}"

        r = requests.get(request_url)
        open(file_name, 'wb').write(r.content)
        print(f"Local: {file_name}")

        # read it back into a parquet file
        df = pd.read_csv(
            file_name
            , sep=','
            , compression='gzip'
            , parse_dates=parse_dates
            , low_memory=False
            , dtype_backend="pyarrow"
        ) 
        
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
        file_name = file_name.replace('.csv.gz', '.parquet')
        df.to_parquet(
            file_name, 
            engine='pyarrow',
            coerce_timestamps='us' 
        )
        print(f"Parquet: {file_name}")

        # upload it to gcs 
        upload_to_gcs(BUCKET, f"{service}/{file_name}", file_name)
        print(f"GCS: {service}/{file_name}")


if __name__ == '__main__':
    web_to_gcs('2019', 'green')
    web_to_gcs('2020', 'green')
    web_to_gcs('2019', 'yellow')
    web_to_gcs('2020', 'yellow')
    web_to_gcs('2019', 'fhv')

