## Introduction to Kafka
[Slides](https://docs.google.com/presentation/d/1bCtdCba8v1HxJ_uMm9pwjRUC-NAMeB-6nOG2ng3KujA/edit?usp=sharing)

- [Video: Intro to Kafka](https://www.youtube.com/watch?v=P1u8x3ycqvg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=57)
- [Video: Configuration Terms](https://www.youtube.com/watch?v=Erf1-d1nyMY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=58)
- [Video: Avro and schema registry](https://www.youtube.com/watch?v=bzAsVNE5vOo&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=59)

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

## KStreams
* [Slides](https://docs.google.com/presentation/d/1fVi9sFa7fL2ZW3ynS5MAZm0bRSZ4jO10fymPmrfTUjE/edit?usp=sharing)
* [Concepts](https://docs.confluent.io/platform/current/streams/concepts.html)

- [Video: KStream basics](https://www.youtube.com/watch?v=uuASDjCtv58&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=60)
- [Video: KStream Join and windowing](https://www.youtube.com/watch?v=dTzsDM9myr8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=61)
- [Video: KStream advance features](https://www.youtube.com/watch?v=d8M_-ZbhZls&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=62)

#### Python Faust
* [Faust Doc](https://faust.readthedocs.io/en/latest/index.html)
* [KStream vs Faust](https://faust.readthedocs.io/en/latest/playbooks/vskafka.html)

#### JVM library
* [Confluent Kafka Stream](https://kafka.apache.org/documentation/streams/)
* [Example](https://github.com/AnkushKhanna/kafka-helper/tree/master/src/main/scala/kafka/schematest)

## Kafka Connect and KSQL
- [Video: Kafka connect and KSQL](https://www.youtube.com/watch?v=OgPJiic6xjY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=63)

## Kafka connect
* [Blog post](https://medium.com/analytics-vidhya/making-sense-of-stream-data-b74c1252a8f5)

## Homework
[Form](https://forms.gle/mSzfpPCXskWCabeu5)

The homework is mostly theoretical. In the last question you have to provide working code link, please keep in mind that this 
question is not scored. 

Deadline: 14 March, 22:00 CET

## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/6_streaming.md )
* Add your notes here (above this line)
