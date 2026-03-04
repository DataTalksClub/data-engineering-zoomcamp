# Supplementary streaming examples

Additional stream processing examples from previous course years. These are
not part of the main workshop but may be useful as reference material.


## python/

Python Kafka examples by Irem Erturk, using various libraries.

- [json_example/](python/json_example) - producer and consumer using
  `kafka-python` with JSON serialization
- [avro_example/](python/avro_example) - producer and consumer using
  `confluent-kafka` with Avro serialization and Schema Registry
- [redpanda_example/](python/redpanda_example) - same as the JSON example
  but running against Redpanda instead of Kafka, with a local
  docker-compose setup
- [streams-example/faust/](python/streams-example/faust) - stream processing
  with [Faust](https://faust-streaming.github.io/faust/), a Python library
  for Kafka Streams. Includes windowing, branching, and counting examples.
- [streams-example/pyspark/](python/streams-example/pyspark) - Spark
  Structured Streaming consuming from Kafka, with a Jupyter notebook
- [streams-example/redpanda/](python/streams-example/redpanda) - same as
  the PySpark example but using Redpanda as the broker
- [docker/](python/docker) - Docker Compose files for running Kafka and
  Spark clusters locally
- [resources/](python/resources) - sample data (rides.csv) and Avro schemas


## pyflink/

PyFlink workshop by Irem Erturk. Uses Apache Flink 1.x with a
Makefile-based workflow, PostgreSQL sink, and Docker Compose setup. The
[2025 stream with Zach Wilson](https://www.youtube.com/watch?v=P2loELMUUeI)
was rewritten into the current [2026 workshop](../workshop/) by Alexey,
using Flink 2.2, uv, and a step-by-step README.


## ksqldb/

[commands.md](ksqldb/commands.md) - example ksqlDB queries for creating
streams, filtering, grouping, and windowed aggregations over Kafka topics.
Companion to the [ksqlDB and Connect video](../theory/#kafka-streams) in
the theory section.
