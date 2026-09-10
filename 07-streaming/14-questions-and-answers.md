# Q&A

Questions and answers from the
[2025 stream with Zach Wilson](https://www.youtube.com/watch?v=P2loELMUUeI).


*The Q&A revisits the operational and architectural decisions around recovery, stateful processing, lateness, latency, and production delivery.*

## What happens when a Flink job dies and restarts? Does it reprocess everything?
The `earliest` offset setting is only for the initial startup. If the job
restarts (not re-submitted as a new job), it uses checkpointing to resume
from the last snapshot. Without checkpointing, you either reprocess
everything (with `earliest`) or skip data (with `latest`).

The catch: checkpoints are scoped to a specific job instance. If you
completely kill a job and submit a new one, the new job has no knowledge of
the previous checkpoints. To preserve state across redeployments, restart
the existing job rather than creating a new one.

## Why can't we just use Kafka consumers? What does Flink actually add?
For simple pass-through (read a message, write it somewhere), a Kafka
consumer is fine. For anything involving time windows, watermarks,
checkpointing, or parallel processing, Flink saves you from building all
that yourself.

You can do windowing, watermarking, late data handling, and job recovery
with a plain consumer - go ahead and manage it yourself. But as Zach puts
it: "good luck." With a plain consumer, you'd also need to track
checkpoints yourself - save the latest processed timestamp to a file or
database and manage it on every restart. Flink keeps the state for you.

It's like asking "why use Spark when you can use Pandas?" You can, but
Pandas won't work at higher scale in a distributed way.

## What happens with events delayed beyond the watermark (the "tunnel" scenario)?
There are two types of lateness. The watermark handles acceptable lateness -
small delays where events arrive a few seconds late. For events arriving
much later (like after a 5-minute tunnel), Flink has an allowed lateness
parameter.

By default, allowed lateness is zero - events arriving after the watermark
closes a window are discarded. If you set allowed lateness to 10 minutes,
Flink will go back, find the old closed window, create a new aggregation
with the late event, and send it to the sink as a brand new record. This
means you need deduplication logic on the sink side (a primary key with
upsert behavior - exactly what we set up in the aggregation section).

The trade-off: allowed lateness requires Flink to hold all those windows
on disk for the duration of the tolerance.

## When do we actually need streaming? For many things micro-batch is enough.
The key question: is something going to happen in real time on the other
side? If there is an automated process that will change something based on
the data, streaming is a great choice. If a human is just looking at data,
real-time is unnecessary and micro-batch is easier to maintain.

In 10 years as a data engineer, Zach had literally two use cases that
genuinely needed streaming - Netflix fraud/security detection (5 minutes of
delay means 5 more minutes of a hacked account) and Airbnb surge pricing
(supply and demand changes rapidly). Everything else was daily batch, or
hourly/every-15-minute micro-batch for lower latency needs.

Before committing to streaming, consider the operational cost. A streaming
job runs 24/7 - if it breaks at 3 AM, someone needs to fix it. If you're
the only person on the team who understands Flink, you'll be on-call for
it forever. Talk to your manager before implementing streaming - you'll
need to teach your entire team before you can share the on-call burden.

## Spark Streaming vs Flink Streaming?
They are fundamentally different today but will likely converge. The key
difference: Spark Streaming is micro-batch - it pulses every 15-30 seconds,
pulling data in small batches (pull architecture). Flink is genuine
continuous processing - events flow through as they arrive (push
architecture). For most use cases the difference is negligible, but Flink
has lower latency for truly real-time needs.

For micro-batch intervals, Zach finds every-5-minutes too frequent with
Spark because startup alone takes about a minute, making the
overhead-to-work ratio poor. His sweet spots are hourly and every 15
minutes.

## How does job submission work in production?
In this workshop we mount local files into Docker and submit jobs with
`docker compose exec` - that's a development convenience. In production,
job submission looks different depending on the deployment:

- Managed services (AWS Kinesis Data Analytics, Google Cloud Dataflow,
  Confluent Cloud) - you upload a JAR or Python zip through a web console
  or CLI. The service handles the cluster.
- Self-hosted Flink on Kubernetes - you typically build a Docker image with
  your job code baked in, or use the Flink Kubernetes Operator which pulls
  job artifacts from S3/GCS at startup.
- Standalone Flink cluster - you use the `flink run` CLI pointing to a
  local file or an HTTP/S3 URL. CI/CD pipelines often upload the job
  artifact to S3 and then call `flink run` with that URL.

The common pattern: your code lives in git, CI builds an artifact (JAR,
Python zip, or Docker image), pushes it to a registry or object store, and
then triggers the Flink cluster to pick it up.
