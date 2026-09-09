# Kafka theory (optional)

Video lectures covering Kafka concepts, with code examples in Java.

Code: [java/kafka_examples](java/kafka_examples)


## Stream processing

- [7.0.1 Introduction](https://youtu.be/hfvju3iOIP0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=67)
- [7.0.2 What is stream processing](https://youtu.be/WxTxKGcfA-k&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=68)

![Two source streams pass through separate Kafka and Spark topics before reaching realtime consumers.](images/07-stream-processing-two-topic-flow.png)

- [7.3 What is Kafka?](https://youtu.be/zPLZUDPi4AY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=69)

![One data point fans out into multiple event slots inside a Kafka topic.](images/07-kafka-event-fanout-to-partitions.png)

![A Kafka-backed notice board routes producer messages through separate topics to consumers.](images/07-kafka-notice-board-topics.png)

- [7.4 Confluent Cloud](https://youtu.be/ZnEZFEYKppw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=70)
- [7.5 Kafka producer consumer](https://youtu.be/aegTuyxX7Yg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=71)
- [7.6 Kafka configuration](https://youtu.be/SXQtWyRpMKs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=72)

![A Kafka topic has a leader and follower replicas, with consumers reading from the leader.](images/07-kafka-replication.png)

![Kafka retention keeps recent records inside a retention window and expires older records.](images/07-kafka-retention-window.png)

![The Rides topic is divided into partitions distributed across separate Kafka nodes.](images/07-kafka-partitions-to-nodes.png)

![A consumer group assigns parallel Kafka partition lanes across its consumers.](images/07-kafka-consumer-group-partition-assignment.png)

Links:

- [Slides](https://docs.google.com/presentation/d/1bCtdCba8v1HxJ_uMm9pwjRUC-NAMeB-6nOG2ng3KujA/edit?usp=sharing)
- [Kafka Configuration Reference](https://docs.confluent.io/platform/current/installation/configuration/)
- [Confluent Cloud trial](https://www.confluent.io/confluent-cloud/tryfree/)


## Kafka Streams

- [7.7 Kafka stream basics](https://youtu.be/dUyA_63eRb0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=73)

![Kafka Streams groups records by key, counts each group, and emits keyed output.](images/07-kafka-key-count-flow.png)

- [7.8 Kafka stream join](https://youtu.be/NcpKlujh34Y&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=74)
- [7.9 Kafka stream testing](https://youtu.be/TNx5rmLY8Pk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=75)

![A Kafka Streams test topology joins two input topics and writes to an output topic.](images/07-kafka-testing-topology.png)

- [7.10 Kafka stream windowing](https://youtu.be/r1OuLdwxbRc&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=76)

![A Global KTable replicates partitioned reference data into complete local copies.](images/07-kafka-global-ktable-replication.png)

![Two event streams produce join results inside a bounded join window.](images/07-kafka-stream-join-window.png)

![Tumbling windows divide stream time into equal adjacent non-overlapping intervals.](images/07-kafka-tumbling-window-timeline.png)

- [7.11 Kafka ksqlDB and Connect](https://youtu.be/DziQ4a4tn9Y&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=77)
- [7.12 Kafka Schema registry](https://youtu.be/tBY_hBuyzwI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=78)

![A Schema Registry mediates schemas between producers, topics, and consumers.](images/07-kafka-schema-registry-flow.png)

![Forward compatibility lets a newer consumer expectation work with an older schema through the Schema Registry.](images/07-kafka-schema-forward-compatibility.png)

Links:

- [Slides](https://docs.google.com/presentation/d/1fVi9sFa7fL2ZW3ynS5MAZm0bRSZ4jO10fymPmrfTUjE/edit?usp=sharing)
- [Streams Concepts](https://docs.confluent.io/platform/current/streams/concepts.html)
