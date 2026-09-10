# Offsets - earliest vs latest

When Flink connects to Kafka, it needs to know where to start reading. This
is the `scan.startup.mode` setting:


*The starting position controls whether a new job replays history, waits for new events, or begins from a selected point in the log.*

| Mode | Behavior |
|---|---|
| `latest-offset` | Only read messages arriving after the job starts |
| `earliest-offset` | Read everything from the beginning of the topic |
| `timestamp` | Start from a specific point in time |

`earliest` is typically used for backfilling or restating data - you're
using Flink to process data that's been sitting in Kafka for a while, not
real-time data. `latest` is the more common production setting - the job
starts up and only processes new events as people click buttons on your
website or whatever event feed you're consuming.

Our pass-through job uses `latest-offset`. Let's see what happens with
`earliest-offset`:

1. Cancel the running job from the Flink UI (click on the job, then Cancel)
2. Clear the table:
   ```sql
   TRUNCATE processed_events;
   ```
3. Edit `src/job/pass_through_job.py` - change both offset settings:
   ```
   'scan.startup.mode' = 'earliest-offset',
   'properties.auto.offset.reset' = 'earliest',
   ```
4. Resubmit:
   ```bash
   docker compose exec jobmanager ./bin/flink run \
       -py /opt/src/job/pass_through_job.py \
       --pyFiles /opt/src -d
   ```
5. Wait 15 seconds, then check:
   ```sql
   SELECT count(*) FROM processed_events;
   ```

Flink reads all messages from the topic - including data from previous producer
runs. If you ran the producer twice before, you'll see ~2000 rows (duplicates
of everything already processed).

Why duplicates? Checkpoints are scoped to a specific job instance. When you
cancel and resubmit, it's a brand new job that knows nothing about previous
checkpoints. With `earliest-offset`, it starts from scratch. The offset
setting only matters at startup - once the job is running, checkpointing
takes over and tracks progress. But if you kill the job and create a new
one, those checkpoints are gone.

There is a third option - `timestamp` mode. If your job was running fine
until 2:00 PM and then crashed, you can restart it from exactly 2:00 PM.
This is useful for recovering from failures without reprocessing everything
from the beginning or missing the data that arrived while the job was down.

A common production pattern (Lambda architecture): run your streaming job with
`latest-offset` for real-time results, and if it goes down, use a separate
batch job to backfill the gap. This way the streaming job stays fast and you
don't lose data.

> Change the offset back to `latest-offset` when you're done experimenting.
