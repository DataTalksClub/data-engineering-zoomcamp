# The pass-through Flink job

Now let's do the same thing our Python consumer did, but with Flink.

Unlike the producer and consumer scripts, Flink jobs can't run from a
Jupyter notebook. They are submitted to the Flink cluster as .py files
using `docker compose exec`. We cover how job submission works in
production in the "Flink in production" section at the end.


*The pass-through job keeps running: it moves arriving events to the sink and periodically snapshots state and source progress for recovery.*

Create `src/job/pass_through_job.py`.

The Kafka source table:

```python
def create_events_source_kafka(t_env):
    table_name = "events"
    source_ddl = f"""
        CREATE TABLE {table_name} (
            PULocationID INTEGER,
            DOLocationID INTEGER,
            trip_distance DOUBLE,
            total_amount DOUBLE,
            tpep_pickup_datetime BIGINT
        ) WITH (
            'connector' = 'kafka',
            'properties.bootstrap.servers' = 'redpanda:29092',
            'topic' = 'rides',
            'scan.startup.mode' = 'latest-offset',
            'properties.auto.offset.reset' = 'latest',
            'format' = 'json'
        );
        """
    t_env.execute_sql(source_ddl)
    return table_name
```

This is a Flink SQL DDL statement. Breaking it down:

- `PULocationID`, `DOLocationID`, `trip_distance`, `total_amount`,
  `tpep_pickup_datetime` - the JSON fields from our producer
- `'properties.bootstrap.servers' = 'redpanda:29092'` - the internal Docker
  network address (not `localhost` - Flink runs inside Docker)
- `'scan.startup.mode' = 'latest-offset'` - only read new messages arriving
  after the job starts
- `'format' = 'json'` - Flink deserializes JSON automatically

The PostgreSQL sink table:

```python
def create_processed_events_sink_postgres(t_env):
    table_name = 'processed_events'
    sink_ddl = f"""
        CREATE TABLE {table_name} (
            PULocationID INTEGER,
            DOLocationID INTEGER,
            trip_distance DOUBLE,
            total_amount DOUBLE,
            pickup_datetime TIMESTAMP
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

No psycopg2, no INSERT statements - just declare the table and Flink handles
the rest.

The execution:

```python
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import EnvironmentSettings, StreamTableEnvironment

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
            PULocationID,
            DOLocationID,
            trip_distance,
            total_amount,
            TO_TIMESTAMP_LTZ(tpep_pickup_datetime, 3) as pickup_datetime
        FROM {source_table}
        """
    ).wait()

if __name__ == '__main__':
    log_processing()
```

- Streaming mode - the job runs continuously, waiting for new data
- The `INSERT INTO ... SELECT` is the pipeline - read from Kafka, convert the
  timestamp, write to PostgreSQL

`enable_checkpointing(10 * 1000)` tells Flink to take a snapshot of the
job's state every 10 seconds. A checkpoint captures the Kafka offsets (how
far Flink has read) and any in-flight data. If the job crashes, it resumes
from the last checkpoint instead of starting from the beginning.

Checkpointing gets especially important with windows. If you have a
5-minute window and the job fails 2 minutes in, Flink doesn't just track
the offset - it also serializes the open windows to disk. When it
restarts, it picks up right where it left off, with the partially-filled
window intact.

The trade-off is resilience versus efficiency. Checkpointing every 1 second
is expensive - Flink has to serialize and persist the entire state that
often. Checkpointing every 10 minutes means you could lose up to 10 minutes
of progress on failure. 10 seconds is a reasonable default for most jobs.

Submit the job:

```bash
docker compose exec jobmanager ./bin/flink run \
    -py /opt/src/job/pass_through_job.py \
    --pyFiles /opt/src -d
```

```
Job has been submitted with JobID 663cff6811b65e97fc1e068d641401f4
```

Check the Flink UI at [http://localhost:8081](http://localhost:8081) - you should
see a running job.

Since the job uses `latest-offset`, it's waiting for new messages. Send data:

```bash
uv run python src/producers/producer.py
```

Query PostgreSQL:

```sql
SELECT count(*) FROM processed_events;
```

Compare this to our Python consumer approach - same result, but Flink handles
checkpointing, offset management, and PostgreSQL writes automatically.
