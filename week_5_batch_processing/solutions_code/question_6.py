from pyspark.sql import SparkSession
from pyspark.sql.functions import desc

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

trips_df = spark.read \
   .option("header", "true") \
   .csv('fhvhv_tripdata_2021-06.csv.gz')

zones_df = spark.read \
    .option("header", "true") \
    .csv("taxi_zone_lookup.csv")

trips_df \
    .join(zones_df, trips_df.PULocationID == zones_df.LocationID, "inner") \
    .groupBy("Zone") \
    .count() \
    .orderBy(desc("count")) \
    .head(5)

"""
Zone with more pickups was Crown Heights North
"""