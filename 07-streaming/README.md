# Streaming

## Units

1. [PyFlink: Stream Processing Workshop](01-introduction.md) - Introduce the PyFlink streaming workshop that builds a producer, Kafka-compatible broker, consumer, and Flink pipeline into PostgreSQL.
2. [Redpanda - a Kafka-compatible broker](02-redpanda.md) - Start a Redpanda broker in Docker Compose and learn how its internal and external listener addresses work.
3. [Produce messages to Kafka](03-produce-messages-to-kafka.md) - Produce taxi ride events from a Python script to a Kafka topic using a dataclass and JSON serializer.
4. [Consume messages with Python](04-consume-messages-with-python.md) - Consume taxi ride messages from Kafka in Python and deserialize them back into Ride objects.
5. [Save events to PostgreSQL](05-save-events-to-postgresql.md) - Write consumed ride events into a PostgreSQL table with psycopg2 and see the limits of a plain consumer.
6. [Why Flink?](06-why-flink.md) - Explain what Flink adds over a plain consumer, including windowing, checkpointing, parallelism, and connectors.
7. [The Flink image and services](07-the-flink-image-and-services.md) - Build a PyFlink Docker image and define Flink JobManager and TaskManager services in Docker Compose.
8. [The pass-through Flink job](08-the-pass-through-flink-job.md) - Submit a Flink pass-through job that reads Kafka with Flink SQL and writes rides to PostgreSQL.
9. [Offsets - earliest vs latest](09-offsets-earliest-vs-latest.md) - Compare Flink startup offset modes, earliest-offset and latest-offset, and see why resubmitting creates duplicates.
10. [Aggregation with tumbling windows](10-aggregation-with-tumbling-windows.md) - Count trips and sum revenue per pickup zone in hourly tumbling windows with a Flink job writing to PostgreSQL.
11. [Late events and upserts](11-late-events-and-upserts.md) - Use watermarks and a primary key upsert so late events correct already published window results in PostgreSQL.
12. [Understanding window types](12-understanding-window-types.md) - Compare tumbling, sliding, and session windows and the kinds of questions each one answers.
13. [Cleanup](13-cleanup.md) - Stop the streaming workshop containers and optionally remove the PostgreSQL data volume.
14. [Q&A](14-questions-and-answers.md) - Answer common questions on Flink job recovery, lateness, streaming versus micro-batch, and production job submission.

## Homework


## Workshop code

* [`code/`](code/) — the PyFlink workshop project (Redpanda, Python, Flink, PostgreSQL)

## Optional material

* [Kafka theory](theory/) — video lectures on Kafka concepts with Java examples
* [Extras](extras/) — Python and PyFlink examples from previous years

## Community notes

<details>
<summary>Did you take notes? You can share them here</summary>

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/6_streaming.md )
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-6-stream-processing/)
* [Notes by Oscar Garcia](https://github.com/ozkary/Data-Engineering-Bootcamp/tree/main/Step6-Streaming)
* [Notes by Shayan Shafiee Moghadam](https://github.com/shayansm2/eng-notebook/blob/main/kafka/readme.md)
* Add your notes here (above this line)
</details>
