from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

df = spark.read \
   .option("header", "true") \
   .csv('fhvhv_tripdata_2021-06.csv.gz')

df.registerTempTable('trips')

"""
Out[2]: StructType([
        StructField('dispatching_base_num', StringType(), True), 
        StructField('pickup_datetime', StringType(), True), 
        StructField('dropoff_datetime', StringType(), True), 
        StructField('PULocationID', StringType(), True), 
        StructField('DOLocationID', StringType(), True), 
        StructField('SR_Flag', StringType(), True), 
        StructField('Affiliated_base_number', StringType(), True)        
])"""

spark.sql("""
SELECT
    DATEDIFF(minute, CAST(dropoff_datetime AS DATE), CAST(pickup_datetime AS DATE)) AS trip_duration
FROM
    trips
ORDER BY
    1 DESC
""").show()

"""
The longest trip lasted 3.32 hours
"""
