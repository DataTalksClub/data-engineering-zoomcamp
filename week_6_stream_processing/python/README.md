### Stream-Processing with Python

In this document, you will be finding information about stream processing 
using different Python libraries (`kafka-python`,`confluent-kafka`,`pyspark`, `faust`).

This Python module can be seperated in following modules.

####  1. Docker
Docker module includes, Dockerfiles and docker-compose definitions 
to run Kafka and Spark in a docker container. Setting up required services is
the prerequsite step for running following modules.

#### 2. Kafka Producer - Consumer Examples
- [Json Producer-Consumer Example](json_example) using `kafka-python` library
- [Avro Producer-Consumer Example](avro_example) using `confluent-kafka` library

Both of these examples require, up-and running Kafka services, therefore please ensure
following steps under [docker-README](docker/README.md)

To run the producer-consumer examples in the respective example folder, run following commands
```bash
# Start producer script
python3 producer.py
# Start consumer script
python3 consumer.py
```





