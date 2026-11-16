---
video_url: https://www.youtube.com/watch?v=YDUgFeHQzJU
prev_url: ../06-batch/16-connecting-spark-to-bigquery.md
next_url: 02-redpanda.md
---
# PyFlink: Stream Processing Workshop

This workshop is based on the
[2025 stream with Zach Wilson](https://www.youtube.com/watch?v=P2loELMUUeI).

In this workshop, we build a real-time streaming pipeline step by step.
We start with the basics - a message broker, a producer, and a consumer -
then add a database and finally a stream processing framework.

We'll use NYC yellow taxi trip data as our data source.

What we'll build by the end:

```
Producer (Python) -> Kafka (Redpanda) -> Flink -> PostgreSQL
```


*The workshop grows a live event path from production through broker and stream processing to durable relational storage.*

Prerequisites:

- Docker and Docker Compose
- [uv](https://docs.astral.sh/uv/)
- A SQL client - [pgcli](https://www.pgcli.com/) (`uvx pgcli`), DBeaver, pgAdmin, or DataGrip

Code:

- [Reference code](code/) in this module's `code/` directory
- [Code created during the workshop](code/live/) by Alexey

The units that follow walk through building everything from scratch - you can
follow along step by step or study the existing files and run the commands.

<!-- nav:start -->
[← Previous: Connecting Spark to BigQuery](../06-batch/16-connecting-spark-to-bigquery.md) · [Next: Redpanda - a Kafka-compatible broker →](02-redpanda.md)
<!-- nav:end -->
