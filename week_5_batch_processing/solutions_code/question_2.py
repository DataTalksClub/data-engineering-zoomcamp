from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

df = spark.read \
   .option("header", "true") \
   .csv('fhvhv_tripdata_2021-06.csv.gz')

df.head()

df = df.repartition(12)

df.write.parquet('fhvhv_tripdata_2021-06')

"""
Each partition is 25MB
"""