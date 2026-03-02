# PyFlink: Stream Processing Workshop

- Video: [link](https://www.youtube.com/watch?v=P2loELMUUeI)
- Code: [07-streaming/workshop/](.)

In this workshop, we build a real-time streaming pipeline step by step.
We start simple — producing and consuming Kafka messages with plain Python —
then introduce Apache Flink to see what a stream processing framework gives us.

What we'll build:

```
Producer (Python) → Kafka (Redpanda) → Flink → PostgreSQL
```

Prerequisites:

- Docker and Docker Compose
- Python 3 with [uv](https://docs.astral.sh/uv/) installed
- A SQL client — [pgcli](https://www.pgcli.com/), DBeaver, pgAdmin, or DataGrip


## Step 1: Start the infrastructure

TODO


## Step 2: Set up PostgreSQL

TODO


## Step 3: Produce messages to Kafka

TODO


## Step 4: Consume messages with plain Python

TODO


## Step 5: Write a consumer that saves to PostgreSQL

TODO


## Step 6: Why Flink?

TODO


## Step 7: The custom Flink image

TODO


## Step 8: The pass-through Flink job

TODO


## Step 9: Real-time streaming

TODO


## Step 10: Offsets — earliest vs latest

TODO


## Step 11: Aggregation with tumbling windows

TODO


## Step 12: Understanding window types

TODO


## Step 13: When to use streaming vs batch

TODO


## Cleanup

TODO
