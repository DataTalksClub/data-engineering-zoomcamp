# Week 6: Stream Processing

## Code structure
* [Java examples](java)
* [Python examples](python)
* [KSQLD examples](ksqldb)

## Confluent cloud setup
Confluent cloud provides a free 30 days trial for, you can signup [here](https://www.confluent.io/confluent-cloud/tryfree/)

## Introduction to Stream Processing

- [Slides](https://docs.google.com/presentation/d/1bCtdCba8v1HxJ_uMm9pwjRUC-NAMeB-6nOG2ng3KujA/edit?usp=sharing)

### :movie_camera: 6.1 Introduction

[![](https://markdown-videos-api.jorgenkh.no/youtube/hfvju3iOIP0)](https://youtu.be/hfvju3iOIP0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=67)

### :movie_camera: 6.2 What is stream processing

[![](https://markdown-videos-api.jorgenkh.no/youtube/WxTxKGcfA-k)](https://youtu.be/WxTxKGcfA-k&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=68)

#### --- EllaNotes ---
- data exchange: 
  - postal service, there's a sender and recipient
  - notice boards, there's a informant attach a flyer and consumer consumes and react on the messages
- consumer subscribes to a topic and only the subscriber gets the information when the producer sends/broadcast the news re:topic
- data exchange happens in real-time
- real-time means almost instantanous, at least faster than in batch mode



## Introduction to Kafka

### :movie_camera: 6.3  What is kafka?

[![](https://markdown-videos-api.jorgenkh.no/youtube/zPLZUDPi4AY)](https://youtu.be/zPLZUDPi4AY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=69)

#### --- EllaNotes ---

- what is a topic?
  - a kafka nomenclature
  - container for a stream of events
    - eg collection of room's temp has timestamp and the temp at that point of time
    - a set of these streams is a topic
    - also include logs
- what is an event
  - consists of message made up of key-value pair and a timestamp
- kafka properties: robust, flexible, scalable 
- once read by a consumer does not mean other consumers cannot also register to be a subscriber
- monoliths vs micro-services
- because of micro-services, these need to talk to each other via APIs or messages
- these messages need to be streamlined
- there could still be a central monolith database for micro-services
- CDC: change data capture


### :movie_camera: 6.4 Confluent cloud

[![](https://markdown-videos-api.jorgenkh.no/youtube/ZnEZFEYKppw)](https://youtu.be/ZnEZFEYKppw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=70)

#### --- EllaNotes ---

- sign-up for a free 30day $400 credit account at confluent.io
- no need to input card details for this one
- go to API keys and create a `Global` api key
- create topic `tutorial topic` with 2 `partitions` and one day retention
- produce a new 'dummy' message, and it already comes with some metadata
- create a `Datagen` source, continue and select global api key
- for connector, select JSON & Orders
- name the connector `OrdersConnector_tutorial` and accept defaults for everything else and click Create


### :movie_camera: 6.5 Kafka producer consumer

#### --- EllaNotes ---

- doing the same with code
- examples from this point in Java
- 

[![](https://markdown-videos-api.jorgenkh.no/youtube/aegTuyxX7Yg)](https://youtu.be/aegTuyxX7Yg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=71)

## Kafka Configuration

### :movie_camera: 6.6 Kafka configuration

[![](https://markdown-videos-api.jorgenkh.no/youtube/SXQtWyRpMKs)](https://youtu.be/SXQtWyRpMKs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=72)

#### --- EllaNotes ---

- [Kafka Configuration Reference](https://docs.confluent.io/platform/current/installation/configuration/)

## Kafka Streams

- [Slides](https://docs.google.com/presentation/d/1fVi9sFa7fL2ZW3ynS5MAZm0bRSZ4jO10fymPmrfTUjE/edit?usp=sharing)
  
- [Streams Concepts](https://docs.confluent.io/platform/current/streams/concepts.html)

### :movie_camera: 6.7 Kafka streams basics

[![](https://markdown-videos-api.jorgenkh.no/youtube/dUyA_63eRb0)](https://youtu.be/dUyA_63eRb0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=73)

### :movie_camera: 6.8 Kafka stream join

[![](https://markdown-videos-api.jorgenkh.no/youtube/NcpKlujh34Y)](https://youtu.be/NcpKlujh34Y&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=74)

### :movie_camera: 6.9 Kafka stream testing

[![](https://markdown-videos-api.jorgenkh.no/youtube/TNx5rmLY8Pk)](https://youtu.be/TNx5rmLY8Pk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=75)

### :movie_camera: 6.10 Kafka stream windowing

[![](https://markdown-videos-api.jorgenkh.no/youtube/r1OuLdwxbRc)](https://youtu.be/r1OuLdwxbRc&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=76)

### :movie_camera: 6.11 Kafka ksqldb & Connect

[![](https://markdown-videos-api.jorgenkh.no/youtube/DziQ4a4tn9Y)](https://youtu.be/DziQ4a4tn9Y&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=77)

### :movie_camera: 6.12 Kafka Schema registry

[![](https://markdown-videos-api.jorgenkh.no/youtube/tBY_hBuyzwI)](https://youtu.be/tBY_hBuyzwI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=78)

## Faust - Python Stream Processing

- [Faust Documentation](https://faust.readthedocs.io/en/latest/index.html)
- [Faust vs Kafka Streams](https://faust.readthedocs.io/en/latest/playbooks/vskafka.html)

## Pyspark - Structured Streaming
Please follow the steps described under [pyspark-streaming](python/streams-example/pyspark/README.md)

### :movie_camera: 6.13 Kafka Streaming with Python

[![](https://markdown-videos-api.jorgenkh.no/youtube/BgAlVknDFlQ)](https://youtu.be/BgAlVknDFlQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=79)

### :movie_camera: 6.14 Pyspark Structured Streaming

[![](https://markdown-videos-api.jorgenkh.no/youtube/5hRJ8-6Fpyk)](https://youtu.be/5hRJ8-6Fpyk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=80)

## Kafka Streams with JVM library

- [Confluent Kafka Streams](https://kafka.apache.org/documentation/streams/)
- [Scala Example](https://github.com/AnkushKhanna/kafka-helper/tree/master/src/main/scala/kafka/schematest)

## KSQL and ksqlDB

- [Introducing KSQL: Streaming SQL for Apache Kafka](https://www.confluent.io/blog/ksql-streaming-sql-for-apache-kafka/)
- [ksqlDB](https://ksqldb.io/)

## Kafka Connect

- [Making Sense of Stream Data](https://medium.com/analytics-vidhya/making-sense-of-stream-data-b74c1252a8f5)

## Docker

### Starting cluster

## Command line for Kafka

### Create topic

```bash
./bin/kafka-topics.sh --create --topic demo_1 --bootstrap-server localhost:9092 --partitions 2
```

## Homework

* [2024 Homework](../cohorts/2024/)

## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/6_streaming.md )
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-6-stream-processing/)
* [Notes by Oscar Garcia](https://github.com/ozkary/Data-Engineering-Bootcamp/tree/main/Step6-Streaming)
* Add your notes here (above this line)

## More resources

* [kafka-101 youtube playlist by confluent](https://www.youtube.com/playlist?list=PLa7VYi0yPIH0KbnJQcMv5N9iW8HkZHztH)
* [irem.ertuerk's part 1 blog post](https://medium.com/@irem.ertuerk/stream-processing-with-python-part-1-the-simplest-kafka-producer-consumer-b554ce7f9b71)
  * She's the presenter for the 2 python kafka videos on DTC DE playlist
* 