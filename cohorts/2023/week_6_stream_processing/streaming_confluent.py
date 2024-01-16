from pyspark.sql import SparkSession
import pyspark.sql.functions as F

from settings import CONFLUENT_CLOUD_CONFIG, GREEN_TAXI_TOPIC, FHV_TAXI_TOPIC, RIDES_TOPIC, ALL_RIDE_SCHEMA


def read_from_kafka(consume_topic: str):
    # Spark Streaming DataFrame, connect to Kafka topic served at host in bootrap.servers option

    df_stream = spark \
        .readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", CONFLUENT_CLOUD_CONFIG['bootstrap.servers']) \
        .option("subscribe", consume_topic) \
        .option("startingOffsets", "earliest") \
        .option("checkpointLocation", "checkpoint") \
        .option("kafka.security.protocol", "SASL_SSL") \
        .option("kafka.sasl.mechanism", "PLAIN") \
        .option("kafka.sasl.jaas.config",
                f"""org.apache.kafka.common.security.plain.PlainLoginModule required username="{CONFLUENT_CLOUD_CONFIG['sasl.username']}" password="{CONFLUENT_CLOUD_CONFIG['sasl.password']}";""") \
        .option("failOnDataLoss", False) \
        .load()

    return df_stream


def parse_rides(df, schema):
    """ take a Spark Streaming df and parse value col based on <schema>, return streaming df cols in schema """
    assert df.isStreaming is True, "DataFrame doesn't receive streaming data"

    df = df.selectExpr("CAST(key AS STRING)", "CAST(value AS STRING)")
    # split attributes to nested array in one Column
    col = F.split(df['value'], ', ')

    # expand col to multiple top-level columns
    for idx, field in enumerate(schema):
        df = df.withColumn(field.name, col.getItem(idx).cast(field.dataType))

    df = df.na.drop()

    df.printSchema()

    return df.select([field.name for field in schema])


def sink_console(df, output_mode: str = 'complete', processing_time: str = '5 seconds'):
    query = df.writeStream \
        .outputMode(output_mode) \
        .trigger(processingTime=processing_time) \
        .format("console") \
        .option("truncate", False) \
        .start() \
        .awaitTermination()
    return query  # pyspark.sql.streaming.StreamingQuery


def sink_kafka(df, topic, output_mode: str = 'complete'):
    query = df.writeStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092") \
        .outputMode(output_mode) \
        .option("topic", topic) \
        .option("checkpointLocation", "checkpoint") \
        .option("kafka.security.protocol", "SASL_SSL") \
        .option("kafka.sasl.mechanism", "PLAIN") \
        .option("kafka.sasl.jaas.config",
                f"""org.apache.kafka.common.security.plain.PlainLoginModule required username="{CONFLUENT_CLOUD_CONFIG['sasl.username']}" password="{CONFLUENT_CLOUD_CONFIG['sasl.password']}";""") \
        .option("failOnDataLoss", False) \
        .start()
    return query


def op_groupby(df, column_names):
    df_aggregation = df.groupBy(column_names).count()
    return df_aggregation


if __name__ == "__main__":
    spark = SparkSession.builder.appName('streaming-homework').getOrCreate()
    spark.sparkContext.setLogLevel('WARN')

    # Step 1: Consume GREEN_TAXI_TOPIC and FHV_TAXI_TOPIC
    df_green_rides = read_from_kafka(consume_topic=GREEN_TAXI_TOPIC)
    df_fhv_rides = read_from_kafka(consume_topic=FHV_TAXI_TOPIC)

    # Step 2: Publish green and fhv rides to RIDES_TOPIC
    kafka_sink_green_query = sink_kafka(df=df_green_rides, topic=RIDES_TOPIC, output_mode='append')
    kafka_sink_fhv_query = sink_kafka(df=df_fhv_rides, topic=RIDES_TOPIC, output_mode='append')

    # Step 3: Read RIDES_TOPIC and parse it in ALL_RIDE_SCHEMA
    df_all_rides = read_from_kafka(consume_topic=RIDES_TOPIC)
    df_all_rides = parse_rides(df_all_rides, ALL_RIDE_SCHEMA)

    # Step 4: Apply Aggregation on the all_rides
    df_pu_location_count = op_groupby(df_all_rides, ['PULocationID'])
    df_pu_location_count = df_pu_location_count.sort(F.col('count').desc())

    # Step 5: Sink Aggregation Streams to Console
    console_sink_pu_location = sink_console(df_pu_location_count, output_mode='complete')
