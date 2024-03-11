import pyspark.sql.types as T

GREEN_TRIP_DATA_PATH = './resources/green_tripdata_2019-10.csv'
FHV_TRIP_DATA_PATH = './resources/fhv_rides.csv' # fhv_tripdata_2019-10.csv
BOOTSTRAP_SERVERS = 'localhost:9092'

RIDES_TOPIC = 'rides_all'
FHV_TAXI_TOPIC = 'fhv_taxi_rides'
GREEN_TAXI_TOPIC = 'green_taxi_rides'
TOPIC_WINDOWED_VENDOR_ID_COUNT = 'vendor_counts_windowed'

RIDE_SCHEMA = T.StructType(
    [
        T.StructField("pickup_datetime", T.TimestampType(), True),
        T.StructField("dropoff_datetime", T.TimestampType(), True),        
        T.StructField("pu_location_id", T.StringType()),
        T.StructField("do_location_id", T.StringType()),
    ]
)
