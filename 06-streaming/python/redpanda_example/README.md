# Basic PubSub example with Redpanda

The aim of this module is to have a good grasp on the foundation of these Kafka/Redpanda concepts, to be able to submit a capstone project using streaming:
- clusters
- brokers
- topics
- producers
- consumers and consumer groups
- data serialization and deserialization
- replication and retention
- offsets
- consumer-groups
- 

## 1. Pre-requisites

If you have been following the [module-06](./../../../06-streaming/README.md) videos, you might already have installed the `kafka-python` library, so you can move on to [Docker](#2-docker) section.

If you have not, this is the only package you need to install in your virtual environment for this Redpanda lesson. 

1. activate your environment
2. `pip install kafka-python`

## 2. Docker

Start a Redpanda cluster. Redpanda is a single binary image, so it is very easy to start learning kafka concepts with Redpanda.

```bash
cd 06-streaming/python/redpanda_example/
docker-compose up -d
```

## 3. Set RPK alias

Redpanda has a console command `rpk` which means `Redpanda keeper`, the CLI tool that ships with Redpanda and is already available in the Docker image. 

Set the following `rpk` alias so we can use it from our terminal, without having to open a Docker interactive terminal. We can use this `rpk` alias directly in our terminal. 

```bash
alias rpk="docker exec -ti redpanda-1 rpk"
rpk version
```

At this time, the verion is shown as `v23.2.26 (rev 328d83a06e)`. The important version munber is the major one `v23` following the versioning semantics `major.minor[.build[.revision]]`, to ensure that you get the same results as whatever is shared in this document.

> [!TIP]
> If you're reading this after Mar, 2024 and want to update the Docker file to use the latest Redpanda images, just visit [Docker hub](https://hub.docker.com/r/vectorized/redpanda/tags), and paste the new version number.


## 4. Kafka Producer - Consumer Examples

To run the producer-consumer examples, open 2 shell terminals in 2 side-by-side tabs and run following commands. Be sure to activate your virtual environment in each terminal.

```bash
# Start consumer script, in 1st terminal tab
python -m consumer.py
# Start producer script, in 2nd terminal tab
python -m producer.py
```

Run the `python -m producer.py` command again (and again) to observe that the `consumer` worker tab would automatically consume messages in real-time when new `events` occur

## 5. Redpanda UI

You can also see the clusters, topics, etc from the Redpanda Console UI via your browser at [http://localhost:8080](http://localhost:8080)


## 6. rpk commands glossary

Visit [get-started-rpk blog post](https://redpanda.com/blog/get-started-rpk-manage-streaming-data-clusters) for more.

```bash
# set alias for rpk
alias rpk="docker exec -ti redpanda-1 rpk"

# get info on cluster
rpk cluster info

# create topic_name with m partitions and n replication factor
rpk topic create [topic_name] --partitions m --replicas n

# get list of available topics, without extra details and with details
rpk topic list
rpk topic list --detailed

# inspect topic config
rpk topic describe [topic_name]

# consume [topic_name]
rpk topic consume [topic_name]

# list the consumer groups in a Redpanda cluster
rpk group list

# get additional information about a consumer group, from above listed result
rpk group describe my-group
```

## 7. Additional Resources

Redpanda Univerity (needs a Redpanda account and it is free to enrol and do the course(s))
- [RP101: Getting Started with Redpanda](https://university.redpanda.com/courses/hands-on-redpanda-getting-started)
- [RP102: Stream Processing with Redpanda](https://university.redpanda.com/courses/take/hands-on-redpanda-stream-processing/lessons/37830192-intro)
- [SF101: Streaming Fundamentals](https://university.redpanda.com/courses/streaming-fundamentals)
- [SF102: Kafka building blocks](https://university.redpanda.com/courses/kafka-building-blocks)

If you feel that you already have a good foundational basis on Streaming and Kafka, feel free to skip these supplementary courses.

