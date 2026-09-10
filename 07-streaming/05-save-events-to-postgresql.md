# Save events to PostgreSQL

Printing to the screen is fine for debugging, but let's save events to a
database. Add the PostgreSQL service to `docker-compose.yml`:


*The database sink turns each consumed event into a durable row instead of leaving it only in a terminal or in memory.*

```yaml
  postgres:
    image: postgres:18
    restart: on-failure
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5432:5432"
```

Start it:

```bash
docker compose up postgres -d
```

Connect to PostgreSQL. With `pgcli`:

```bash
uvx pgcli -h localhost -p 5432 -U postgres -d postgres
# password: postgres
```

Or via Docker:

```bash
docker compose exec postgres psql -U postgres -d postgres
```

Create a table for our events:

```sql
CREATE TABLE processed_events (
    PULocationID INTEGER,
    DOLocationID INTEGER,
    trip_distance DOUBLE PRECISION,
    total_amount DOUBLE PRECISION,
    pickup_datetime TIMESTAMP
);
```

Install the PostgreSQL client library:

```bash
uv add psycopg2-binary
```

Create `src/consumers/consumer_postgres.py`.

Set up the Kafka consumer. We reuse the same `ride_deserializer` from the
previous step. The `group_id` is different - each consumer group tracks its
offsets independently, so the console consumer and the PostgreSQL consumer
each read all messages:

```python
from kafka import KafkaConsumer

server = 'localhost:9092'
topic_name = 'rides'

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='rides-to-postgres',
    value_deserializer=ride_deserializer
)
```

Connect to PostgreSQL:

```python
import psycopg2

conn = psycopg2.connect(
    host='localhost',
    port=5432,
    database='postgres',
    user='postgres',
    password='postgres'
)
conn.autocommit = True
cur = conn.cursor()
```

`autocommit = True` means each INSERT is committed immediately - no need
to call `conn.commit()` after every row.

Read messages and insert into PostgreSQL:

```python
from datetime import datetime

print(f"Listening to {topic_name} and writing to PostgreSQL...")

count = 0
for message in consumer:
    ride = message.value
    pickup_dt = datetime.fromtimestamp(ride.tpep_pickup_datetime / 1000)
    cur.execute(
        """INSERT INTO processed_events
           (PULocationID, DOLocationID, trip_distance, total_amount, pickup_datetime)
           VALUES (%s, %s, %s, %s, %s)""",
        (ride.PULocationID, ride.DOLocationID,
         ride.trip_distance, ride.total_amount, pickup_dt)
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
uv run python src/consumers/consumer_postgres.py
```

Check PostgreSQL:

```sql
SELECT count(*) FROM processed_events;
```

```
 count
-------
  1000
```

This works, but think about what's missing:

- What if we want to aggregate by time window? We'd need to implement windowing
  logic ourselves.
- What if the consumer crashes? We'd need to track offsets ourselves to avoid
  reprocessing or missing data.
- What about parallelism? We'd need to manage multiple consumer instances and
  partition assignment.
- What about writing to different sinks? We'd need to write connector code for
  each destination.

This is where Flink comes in. Clear the table before moving on:

```sql
TRUNCATE processed_events;
```
