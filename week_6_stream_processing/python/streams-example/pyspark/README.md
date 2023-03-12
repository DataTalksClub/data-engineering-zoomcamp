
# Running PySpark Streaming 

#### Prerequisite

Ensure your Kafka and Spark services up and running by following the [docker setup readme](./../docker/README.md). 
It is important to create network and volume as described in the document. Therefore please ensure, your volume and network are created correctly

```bash
docker volume ls # should list hadoop-distributed-file-system
docker network ls # should list kafka-spark-network 
```


### Running Producer and Consumer
```bash
# Run producer
python3 producer.py

# Run consumer with default settings
python3 consumer.py
# Run consumer for specific topic
python3 consumer.py --topic <topic-name>
```

### Running Streaming Script

spark-submit script ensures installation of necessary jars before running the streaming.py

```bash
./spark-submit.sh streaming.py 
```

### Additional Resources
- [Structured Streaming Programming Guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#structured-streaming-programming-guide)
- [Structured Streaming + Kafka Integration](https://spark.apache.org/docs/latest/structured-streaming-kafka-integration.html#structured-streaming-kafka-integration-guide-kafka-broker-versio)
