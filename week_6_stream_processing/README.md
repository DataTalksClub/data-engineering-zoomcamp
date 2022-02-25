## Stream processing with Kafka
[Slides](https://docs.google.com/presentation/d/1bCtdCba8v1HxJ_uMm9pwjRUC-NAMeB-6nOG2ng3KujA/edit?usp=sharing)


### Configuration
Please take a look at all configuration from kafka [here](https://docs.confluent.io/platform/current/installation/configuration/).

### Docker
#### Starting cluster
```bash
docker-compose up
```

### Command line for Kafka
#### Create topic
```bash
./bin/kafka-topics.sh --create --topic demo_1 --bootstrap-server localhost:9092 --partitions 2
```

### KStreams
* [Slides](https://docs.google.com/presentation/d/1fVi9sFa7fL2ZW3ynS5MAZm0bRSZ4jO10fymPmrfTUjE/edit?usp=sharing)
* [Concepts](https://docs.confluent.io/platform/current/streams/concepts.html)

#### Python Faust
* [Faust Doc](https://faust.readthedocs.io/en/latest/index.html)
* [KStream vs Faust](https://faust.readthedocs.io/en/latest/playbooks/vskafka.html)

#### JVM library
* [Confluent Kafka Stream](https://kafka.apache.org/documentation/streams/)
* [Example](https://github.com/AnkushKhanna/kafka-helper/tree/master/src/main/scala/kafka/schematest)

### Kafka connect
* [Blog post](https://medium.com/analytics-vidhya/making-sense-of-stream-data-b74c1252a8f5)