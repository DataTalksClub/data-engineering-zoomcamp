
# Running PySpark Streaming with Redpanda

### 1. Prerequisite

It is important to create network and volume as described in the document. Therefore please ensure, your volume and network are created correctly.

```bash
docker volume ls # should list hadoop-distributed-file-system
docker network ls # should list kafka-spark-network 
```

### 2. Create Docker Network & Volume

If you have not followed any other examples, and above `ls` steps shows no output, create them now.

```bash
# Create Network
docker network create kafka-spark-network

# Create Volume
docker volume create --name=hadoop-distributed-file-system
```

### Running Producer and Consumer
```bash
# Run producer
python producer.py

# Run consumer with default settings
python consumer.py
# Run consumer for specific topic
python consumer.py --topic <topic-name>
```

### Running Streaming Script

spark-submit script ensures installation of necessary jars before running the streaming.py

```bash
./spark-submit.sh streaming.py 
```

### Additional Resources
- [Structured Streaming Programming Guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#structured-streaming-programming-guide)
- [Structured Streaming + Kafka Integration](https://spark.apache.org/docs/latest/structured-streaming-kafka-integration.html#structured-streaming-kafka-integration-guide-kafka-broker-versio)
