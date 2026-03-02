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
- Python 3.12+ with [uv](https://docs.astral.sh/uv/) installed
- A SQL client — [pgcli](https://www.pgcli.com/), DBeaver, pgAdmin, or DataGrip

> Note: The original `kafka-python` library is no longer maintained. This workshop uses `kafka-python-ng` — a maintained drop-in replacement.


## Step 1: Start the infrastructure

We have four services defined in `docker-compose.yml`:

| Service | What it does |
|---|---|
| Redpanda | A Kafka-compatible message broker. Lightweight, no JVM, no ZooKeeper. |
| Flink JobManager | Coordinates Flink jobs, manages checkpoints, assigns work. |
| Flink TaskManager | Executes the actual data processing. Configured with 15 task slots. |
| PostgreSQL | Where we store processed results. |

First, install the Python dependencies:

```bash
cd 07-streaming/workshop
uv sync
```

Then start everything:

```bash
docker compose up --build -d
```

The first build takes a few minutes — it creates a custom Flink image with Python, PyFlink, and connector JARs.

Verify all four services are running:

```bash
docker compose ps
```

```
NAME                IMAGE                            SERVICE       STATUS
flink-jobmanager    pyflink-workshop                 jobmanager    Up
flink-taskmanager   pyflink-workshop                 taskmanager   Up
postgres            postgres:17                      postgres      Up
redpanda-1          redpandadata/redpanda:v24.2.18   redpanda-1    Up
```

Check the Flink dashboard at [http://localhost:8081](http://localhost:8081) — you should see 1 task manager with 15 available slots.


## Step 2: Set up PostgreSQL

Connect to PostgreSQL. You can use any SQL client. With `pgcli`:

```bash
pgcli -h localhost -p 5432 -U postgres -d postgres
# password: postgres
```

Or via Docker:

```bash
docker compose exec postgres psql -U postgres -d postgres
```

Create the table we'll use throughout this workshop:

```sql
CREATE TABLE processed_events (
    test_data INTEGER,
    event_timestamp TIMESTAMP
);
```

Verify:

```sql
\dt
```

```
 Schema |       Name        | Type  |  Owner
--------+-------------------+-------+----------
 public | processed_events  | table | postgres
```


## Step 3: Produce messages to Kafka

Look at `src/producers/producer.py`:

```python
import json
import time
from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)

topic_name = 'test-topic'

for i in range(10, 1000):
    message = {'test_data': i, 'event_timestamp': time.time() * 1000}
    producer.send(topic_name, value=message)
    print(f"Sent: {message}")
    time.sleep(0.05)

producer.flush()
```

Key concepts:
- Bootstrap server (`localhost:9092`): where the Kafka broker (Redpanda) accepts connections
- Topic (`test-topic`): a named stream of messages. Kafka auto-creates it on first use.
- Serializer: Kafka needs bytes, so we serialize Python dicts to JSON
- Messages: each has `test_data` (an integer) and `event_timestamp` (epoch milliseconds)

Run it:

```bash
uv run python3 src/producers/producer.py
```

You'll see 990 messages sent over ~50 seconds:

```
Sent: {'test_data': 10, 'event_timestamp': 1772472345421.216}
Sent: {'test_data': 11, 'event_timestamp': 1772472345832.327}
...
Sent: {'test_data': 999, 'event_timestamp': 1772472395464.049}
took 50.09 seconds
```


## Step 4: Consume messages with plain Python

Before we use Flink, let's read from Kafka with a plain Python consumer. Look at `src/consumers/consumer.py`:

```python
import json
from datetime import datetime

from kafka import KafkaConsumer

server = 'localhost:9092'
topic_name = 'test-topic'

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='test-consumer-group',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print(f"Listening to {topic_name}...")

count = 0
for message in consumer:
    data = message.value
    timestamp = datetime.fromtimestamp(data['event_timestamp'] / 1000)
    print(f"Received: test_data={data['test_data']}, timestamp={timestamp}")
    count += 1
    if count >= 10:
        print(f"\n... received {count} messages so far (stopping after 10 for demo)")
        break

consumer.close()
```

Run it:

```bash
uv run python3 src/consumers/consumer.py
```

```
Listening to test-topic...
Received: test_data=10, timestamp=2026-03-02 18:25:45.421216
Received: test_data=11, timestamp=2026-03-02 18:25:45.832327
...
... received 10 messages so far (stopping after 10 for demo)
```


## Step 5: Write a consumer that saves to PostgreSQL

We can also write a consumer that saves to PostgreSQL. Look at `src/consumers/consumer_postgres.py`:

```python
import json
from datetime import datetime

import psycopg2
from kafka import KafkaConsumer

server = 'localhost:9092'
topic_name = 'test-topic'

conn = psycopg2.connect(
    host='localhost', port=5432,
    database='postgres', user='postgres', password='postgres'
)
conn.autocommit = True
cur = conn.cursor()

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='test-consumer-postgres',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print(f"Listening to {topic_name} and writing to PostgreSQL...")

count = 0
for message in consumer:
    data = message.value
    timestamp = datetime.fromtimestamp(data['event_timestamp'] / 1000)
    cur.execute(
        "INSERT INTO processed_events (test_data, event_timestamp) VALUES (%s, %s)",
        (data['test_data'], timestamp)
    )
    count += 1
    if count % 100 == 0:
        print(f"Inserted {count} rows...")

consumer.close()
cur.close()
conn.close()
```

Run it (press Ctrl+C after it processes the data):

```bash
uv run python3 src/consumers/consumer_postgres.py
```

Check PostgreSQL:

```sql
SELECT count(*) FROM processed_events;
```

```
 count
-------
   990
```

This works, but think about what's missing:
- What if we want to aggregate by time window? We'd need to implement windowing logic ourselves.
- What if the consumer crashes? We'd need to track offsets ourselves to avoid reprocessing or missing data.
- What about parallelism? We'd need to manage multiple consumer instances and partition assignment.
- What about writing to different sinks? We'd need to write connector code for each destination.

This is where Flink comes in. Clear the table and try the same thing with Flink:

```sql
TRUNCATE processed_events;
```


## Step 6: Why Flink?

Flink is a stream processing framework that handles all the hard parts:

- Windowing — built-in tumbling, sliding, and session windows
- Checkpointing — automatic state recovery after failures (no manual offset tracking)
- Parallelism — distribute processing across multiple workers
- Connectors — built-in JDBC, Kafka, filesystem sinks (no psycopg2 code)
- SQL interface — express stream processing with SQL queries

The trade-off is infrastructure complexity — we need the JobManager and TaskManager containers. But for anything beyond simple consume-and-write, Flink pays for itself.


## Step 7: The custom Flink image

Look at `Dockerfile.flink` to understand what goes into our Flink image:

```dockerfile
FROM flink:2.2.0-scala_2.12-java17

USER root

RUN apt-get update -y && \
    apt-get install -y python3 python3-dev python3-venv curl && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"
RUN uv init /opt/pyflink && uv add --project /opt/pyflink apache-flink==2.2.0
ENV PATH="/opt/pyflink/.venv/bin:$PATH"

RUN wget -P /opt/flink/lib/ https://...flink-json-2.2.0.jar; \
    wget -P /opt/flink/lib/ https://...flink-sql-connector-kafka-4.0.1-2.0.jar; \
    wget -P /opt/flink/lib/ https://...flink-connector-jdbc-core-4.0.0-2.0.jar; \
    wget -P /opt/flink/lib/ https://...flink-connector-jdbc-postgres-4.0.0-2.0.jar; \
    wget -P /opt/flink/lib/ https://...postgresql-42.7.4.jar
```

The base Flink image is Java-only. We add:
1. Python 3 — needed for PyFlink
2. uv — to manage Python packages
3. PyFlink (`apache-flink==2.2.0`) — the Python API for Flink
4. Connector JARs — Flink needs these to talk to Kafka, PostgreSQL, and parse JSON


## Step 8: The pass-through Flink job

Now let's do the same thing our Python consumer did, but with Flink. Look at `src/job/start_job.py`.

The Kafka source table:

```python
def create_events_source_kafka(t_env):
    table_name = "events"
    source_ddl = f"""
        CREATE TABLE {table_name} (
            test_data INTEGER,
            event_timestamp BIGINT,
            event_watermark AS TO_TIMESTAMP_LTZ(event_timestamp, 3),
            WATERMARK for event_watermark as event_watermark - INTERVAL '5' SECOND
        ) WITH (
            'connector' = 'kafka',
            'properties.bootstrap.servers' = 'redpanda-1:29092',
            'topic' = 'test-topic',
            'scan.startup.mode' = 'latest-offset',
            'properties.auto.offset.reset' = 'latest',
            'format' = 'json'
        );
        """
    t_env.execute_sql(source_ddl)
    return table_name
```

This is a Flink SQL DDL statement. Breaking it down:

- `test_data INTEGER`, `event_timestamp BIGINT` — the two JSON fields from our producer
- `event_watermark AS TO_TIMESTAMP_LTZ(event_timestamp, 3)` — a computed column that converts epoch milliseconds to a timestamp. The `3` means milliseconds precision.
- `WATERMARK for event_watermark as event_watermark - INTERVAL '5' SECOND` — tells Flink to tolerate events arriving up to 5 seconds late. We don't need this for pass-through, but it's required for windowed aggregation later.
- `'properties.bootstrap.servers' = 'redpanda-1:29092'` — the internal Docker network address (not localhost — Flink runs inside Docker)
- `'scan.startup.mode' = 'latest-offset'` — only read new messages arriving after the job starts
- `'format' = 'json'` — Flink deserializes JSON automatically

The PostgreSQL sink table:

```python
def create_processed_events_sink_postgres(t_env):
    table_name = 'processed_events'
    sink_ddl = f"""
        CREATE TABLE {table_name} (
            test_data INTEGER,
            event_timestamp TIMESTAMP
        ) WITH (
            'connector' = 'jdbc',
            'url' = 'jdbc:postgresql://postgres:5432/postgres',
            'table-name' = '{table_name}',
            'username' = 'postgres',
            'password' = 'postgres',
            'driver' = 'org.postgresql.Driver'
        );
        """
    t_env.execute_sql(sink_ddl)
    return table_name
```

No psycopg2, no INSERT statements — just declare the table and Flink handles the rest.

The execution:

```python
def log_processing():
    env = StreamExecutionEnvironment.get_execution_environment()
    env.enable_checkpointing(10 * 1000)  # checkpoint every 10 seconds

    settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    t_env = StreamTableEnvironment.create(env, environment_settings=settings)

    source_table = create_events_source_kafka(t_env)
    postgres_sink = create_processed_events_sink_postgres(t_env)

    t_env.execute_sql(
        f"""
        INSERT INTO {postgres_sink}
        SELECT
            test_data,
            TO_TIMESTAMP_LTZ(event_timestamp, 3) as event_timestamp
        FROM {source_table}
        """
    ).wait()
```

- Checkpointing every 10 seconds — Flink saves its state (Kafka offsets, in-flight data). If the job crashes, it resumes from the last checkpoint.
- Streaming mode — the job runs continuously, waiting for new data
- The `INSERT INTO ... SELECT` is the pipeline — read from Kafka, convert the timestamp, write to PostgreSQL

Submit the job:

```bash
make job
```

This runs:

```bash
docker compose exec jobmanager ./bin/flink run \
    -py /opt/src/job/start_job.py \
    --pyFiles /opt/src -d
```

```
Job has been submitted with JobID 663cff6811b65e97fc1e068d641401f4
```

Check the Flink UI at [http://localhost:8081](http://localhost:8081) — you should see a running job.

Since the job uses `latest-offset`, it's waiting for new messages. Send data:

```bash
uv run python3 src/producers/producer.py
```

Query PostgreSQL:

```sql
SELECT count(*) FROM processed_events;
```

```
 count
-------
   990
```

```sql
SELECT * FROM processed_events ORDER BY test_data LIMIT 5;
```

```
 test_data |     event_timestamp
-----------+-------------------------
        10 | 2026-03-02 17:31:33.832
        11 | 2026-03-02 17:31:33.882
        12 | 2026-03-02 17:31:33.933
        13 | 2026-03-02 17:31:33.983
        14 | 2026-03-02 17:31:34.033
```

Compare this to our Python consumer approach — same result, but Flink handles checkpointing, offset management, and PostgreSQL writes automatically.


## Step 9: Real-time streaming

The Flink job is still running. Let's prove it processes data in real time.

Open two terminals:
- Terminal 1: Run the producer — `uv run python3 src/producers/producer.py`
- Terminal 2: Repeatedly query `SELECT count(*) FROM processed_events;`

You'll see the count increase live as the producer sends messages. This is continuous stream processing — no batch scheduling, no cron jobs.


## Step 10: Offsets — earliest vs latest

When Flink connects to Kafka, it needs to know where to start reading. This is the `scan.startup.mode` setting:

| Mode | Behavior |
|---|---|
| `latest-offset` | Only read messages arriving after the job starts |
| `earliest-offset` | Read everything from the beginning of the topic |
| `timestamp` | Start from a specific point in time |

Our pass-through job uses `latest-offset`. Let's see what happens with `earliest-offset`:

1. Cancel the running job from the Flink UI (click on the job, then Cancel)
2. Clear the table:
   ```sql
   TRUNCATE processed_events;
   ```
3. Edit `src/job/start_job.py` — change both offset settings:
   ```
   'scan.startup.mode' = 'earliest-offset',
   'properties.auto.offset.reset' = 'earliest',
   ```
4. Resubmit: `make job`
5. Wait 15 seconds, then check:
   ```sql
   SELECT count(*) FROM processed_events;
   ```

Flink reads all messages from the topic — including data from previous producer runs. If you ran the producer twice before, you'll see ~1980 rows (duplicates of everything already processed).

Why duplicates? Checkpoints are scoped to a specific job instance. When you cancel and resubmit, it's a brand new job that knows nothing about previous checkpoints. With `earliest-offset`, it starts from scratch.

> Change the offset back to `latest-offset` when you're done experimenting.


## Step 11: Aggregation with tumbling windows

Now let's do something our plain Python consumer can't easily do — windowed aggregation.

First, cancel any running jobs. Then create the aggregation table in PostgreSQL:

```sql
CREATE TABLE processed_events_aggregated (
    event_hour TIMESTAMP,
    test_data INTEGER,
    num_hits BIGINT,
    PRIMARY KEY (event_hour, test_data)
);
```

Two important design choices:

1. `test_data` is included — we group by both time window and `test_data`, so both appear in the output.
2. `PRIMARY KEY` — enables upsert behavior. When Flink sends updated counts for the same window, PostgreSQL updates the existing row instead of creating a duplicate.

> During the original stream, Zach forgot the `test_data` column and the primary key, which caused errors. We include both from the start.

Now look at `src/job/aggregation_job.py`. The key differences from the pass-through job:

Tighter watermark (1 second instead of 5):

```python
WATERMARK for event_watermark as event_watermark - INTERVAL '1' SECOND
```

This makes windows close faster so we see results sooner.

The tumbling window query:

```python
t_env.execute_sql(f"""
    INSERT INTO {aggregated_table}
    SELECT
        window_start as event_hour,
        test_data,
        COUNT(*) AS num_hits
    FROM TABLE(
        TUMBLE(TABLE {source_table}, DESCRIPTOR(event_watermark), INTERVAL '1' MINUTE)
    )
    GROUP BY window_start, test_data;
""").wait()
```

The `TUMBLE` function:
- `TABLE {source_table}` — input data (Kafka source)
- `DESCRIPTOR(event_watermark)` — the time column for windowing (must match the `WATERMARK` column)
- `INTERVAL '1' MINUTE` — window size

> During the stream, Zach tried `DESCRIPTOR(window_timestamp)` instead of `DESCRIPTOR(event_watermark)`, which caused an error. The descriptor must reference the column with the `WATERMARK` defined on it.

Parallelism:

```python
env.set_parallelism(3)
```

Flink runs 3 copies processing data in parallel (similar to Spark executors). The task manager has 15 slots, so there's room to spare.

Submit and test:

```bash
make aggregation_job
```

Send data:

```bash
uv run python3 src/producers/producer.py
```

Wait ~15 seconds for the windows to close, then check:

```sql
SELECT event_hour, count(*) as entries, sum(num_hits) as total_hits
FROM processed_events_aggregated
GROUP BY event_hour
ORDER BY event_hour;
```

```
     event_hour      | entries | total_hits
---------------------+---------+------------
 2026-03-02 17:36:00 |     253 |        253
 2026-03-02 17:37:00 |     737 |        737
```

The 990 events were grouped into 1-minute tumbling windows. Each row shows how many events landed in that minute.

Try this with a plain Python consumer — you'd need to implement the windowing logic, handle late events, manage state, and write the upsert SQL yourself. With Flink, it's a SQL query.


## Step 12: Understanding window types

We used tumbling windows above. Flink supports three types:

### Tumbling windows

Fixed-size, non-overlapping. Every event belongs to exactly one window.

```
|  Window 1  |  Window 2  |  Window 3  |
|  1 min     |  1 min     |  1 min     |
```

Use case: Counting events per minute, hourly aggregations, daily summaries.

### Sliding windows

Fixed-size, overlapping. An event can belong to multiple windows.

```
|--- Window 1 (5 min) ---|
      |--- Window 2 (5 min) ---|
            |--- Window 3 (5 min) ---|
      ← 1 min slide →
```

```sql
HOP(TABLE events, DESCRIPTOR(event_watermark), INTERVAL '1' MINUTE, INTERVAL '5' MINUTE)
```

Use case: "What was our peak traffic in any 5-minute window?" — useful for finding peaks, moving averages, surge detection.

### Session windows

Dynamic windows based on inactivity gaps. A window closes after no events arrive for a specified duration.

```
|--events--| gap |--events------| gap |--events--|
| Session 1|     |  Session 2   |     | Session 3|
```

Use case: User session analysis — group a user's clicks until they're inactive for 30 minutes. Great for behavioral analytics.


## Step 13: When to use streaming vs batch

Not everything needs streaming. In Zach's words from the workshop: "In my whole career as a data engineer for 10 years, there were literally two use cases where I actually needed streaming — Airbnb's surge pricing and Netflix fraud detection."

Use streaming when:
- You need real-time automated reactions (fraud detection, surge pricing, security alerting)
- There's an automated process on the other end that acts on the data immediately
- Five-minute latency makes a meaningful difference

Use batch or micro-batch when:
- Results can wait minutes or hours (dashboards, reports, analytics)
- A human is the end consumer (they won't notice 15-minute vs real-time)
- Simpler to maintain — hourly or 15-minute micro-batches are the sweet spot

Why Flink over a plain Kafka consumer?

For simple pass-through (read a message, write it somewhere), a Kafka consumer is fine. For anything involving:
- Time windows and aggregations
- Late-arriving data handling (watermarks)
- Automatic checkpoint/recovery
- Parallel processing
- Multiple sink connectors

Flink saves you from building all that yourself.


## Cleanup

Stop and remove all containers:

```bash
docker compose down
```

To also remove the PostgreSQL data volume:

```bash
docker compose down -v
```
