# 2023-python-gsg
This repository contains the sample code related to Redpanda and Python getting started guide.

## Prerequisites
- Python 3 with pip
- Docker

Install `kafka-python` package by running:

```
pip install kafka-python
```

## Start a single-node Redpanda cluster

```
docker compose up -d
```

## Producing and consuming string messages

Run the `string_producer.py` to produce 10 messages to the `orders` topic. Run the `string_consumer.py` to consume them back.

## Producing and consuming JSON messages

Run the `json_producer.py` to produce 10 JSON messages to the `orders` topic. Run the `json_consumer.py` to consume them back.

## Cleaning up

Clean up the containers by running:

```
docker compose down
```

