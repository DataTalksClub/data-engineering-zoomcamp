# Basic PubSub example with Redpanda

Sign up and enrol in the courses at Redpanda University. They are free. For this lesson, at minimum, be sure to enrol in

- [RP101: Getting Started with Redpanda](https://university.redpanda.com/courses/hands-on-redpanda-getting-started)
- [RP102: Stream Processing with Redpanda](https://university.redpanda.com/courses/take/hands-on-redpanda-stream-processing/lessons/37830192-intro)

Optional, for foundational concepts. And any others as you like.
- [SF101: Streaming Fundamentals](https://university.redpanda.com/courses/streaming-fundamentals)
- [SF102: Kafka building blocks](https://university.redpanda.com/courses/kafka-building-blocks)

If you feel that you already have a good foundational basis on Streaming and Kafka, feel free to skip these supplementary courses.

The aim from the courses is so that we have a good grasp on the foundation of these Kafka/Redpanda concepts, to be able to submit a capstone project using streaming:
- clusters
- brokers
- topics
- producers
- consumers and consumer groups
- data serialization and deserialization

## 1. Pre-requisites

If you have been following the [module-06](./../../../06-streaming/README.md) videos, you might already have installed the `kafka-python` library, so you can move on to [Docker](#2-docker) section.

If you have not, this is the only package you need to install in your virtual environment for this Redpanda lesson. 

1. activate your environment
2. `pip install kafka-python`

## 2. Docker

If not in the folder, be sure to change directory to this path first, and activate your environment (if previous install step was skipped).

Start a Redpanda cluster. 

```bash
cd 06-streaming/python/redpanda_example/
docker-compose up -d
```

## 3. Set RPK alias

Redpanda has a console command `rpk` which means `Redpanda keeper`, the CLI tool that ships with Redpanda and is already available in the Docker image. 

Set the following `rpk` alias so we can use it from our terminal, without having to open a Docker interactive terminal. We can use this `rpk` alias directly in our terminal.

```bash
alias rpk="docker exec -ti redpanda-1 rpk"
```

## 4. Kafka Producer - Consumer Examples

To run the producer-consumer examples, open 2 shell terminals in 2 side-by-side tabs and run following commands. Be sure to activate your virtual environment in each terminal.

```bash
# Start consumer script
python -m consumer.py
# Start producer script
python -m producer.py

```

## 5. Redpanda UI

You can also see the clusters, topics, etc from the browser UI at [http://localhost:8080](http://localhost:8080)


## 6. rpk commands glossary

```bash
# set alias for rpk
alias rpk="docker exec -ti redpanda-1 rpk"
# 
rpk topic consume rides_json
# list the consumer groups in a Redpanda cluster
rpk group list
# get additional information about a consumer group
rpk group describe my-group
```