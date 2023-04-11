import pyspark.sql.types as T

GREEN_TRIP_DATA_PATH = './resources/green_tripdata/green_tripdata_2019-01.csv'
FHV_TRIP_DATA_PATH = './resources/fhv_tripdata/fhv_tripdata_2019-01.csv'
BOOTSTRAP_SERVERS = 'localhost:9092'

RIDES_TOPIC = 'all_rides'
FHV_TAXI_TOPIC = 'fhv_taxi_rides'
GREEN_TAXI_TOPIC = 'green_taxi_rides'

ALL_RIDE_SCHEMA = T.StructType(
    [T.StructField("PUlocationID", T.StringType()),
     T.StructField("DOlocationID", T.StringType()),
     ])


def read_ccloud_config(config_file):
    conf = {}
    with open(config_file) as fh:
        for line in fh:
            line = line.strip()
            if len(line) != 0 and line[0] != "#":
                parameter, value = line.strip().split('=', 1)
                conf[parameter] = value.strip()
    return conf


CONFLUENT_CLOUD_CONFIG = read_ccloud_config('client_original.properties')
