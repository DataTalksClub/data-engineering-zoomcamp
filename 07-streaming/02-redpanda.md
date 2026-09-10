# Redpanda - a Kafka-compatible broker

Before we can produce or consume messages, we need a message broker -
a service that receives messages from producers, stores them, and delivers
them to consumers.

We use [Redpanda](https://redpanda.com/), a drop-in replacement for
Apache Kafka. Redpanda implements the same protocol, so any Kafka client
library works with it unchanged. The `kafka-python` library we'll use
doesn't know or care that Redpanda is running instead of Kafka.

Why Redpanda instead of Kafka?

- No JVM - Kafka runs on Java and needs significant memory for the JVM.
  Redpanda is written in C++ and starts in seconds with far less overhead.
- No ZooKeeper - Kafka traditionally required a separate ZooKeeper cluster
  for coordination (metadata, leader election). Redpanda handles this
  internally using the Raft consensus protocol - one less service to run.
- Single binary - just one container, nothing else to configure.

For this workshop, every time we say "Kafka" we mean the Kafka protocol
and concepts. Redpanda is the actual broker running underneath.


*The key topology distinction is where the client runs: both paths use Kafka clients, but Docker services and the laptop need different network routes.*

Create `docker-compose.yml` with the Redpanda service:

```yaml
services:
  redpanda:
    image: redpandadata/redpanda:v25.3.9
    command:
      - redpanda
      - start
      - --smp
      - '1'
      - --reserve-memory
      - 0M
      - --overprovisioned
      - --node-id
      - '1'
      - --kafka-addr
      - PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092
      - --advertise-kafka-addr
      - PLAINTEXT://redpanda:29092,OUTSIDE://localhost:9092
      - --pandaproxy-addr
      - PLAINTEXT://0.0.0.0:28082,OUTSIDE://0.0.0.0:8082
      - --advertise-pandaproxy-addr
      - PLAINTEXT://redpanda:28082,OUTSIDE://localhost:8082
      - --rpc-addr
      - 0.0.0.0:33145
      - --advertise-rpc-addr
      - redpanda:33145
    ports:
      - 8082:8082
      - 9092:9092
      - 28082:28082
      - 29092:29092
```

The command has many parameters. Let's go through them.

Resource parameters:

| Parameter | What it does |
|---|---|
| `--smp 1` | Use 1 CPU core. Redpanda is built on [Seastar](http://seastar.io/), a framework that pins threads to cores for high performance. For development, 1 core is enough. |
| `--reserve-memory 0M` | Don't reserve extra memory for Redpanda's internal cache. In production, Redpanda reserves memory for its own page cache; we skip this in development. |
| `--overprovisioned` | Don't pin threads to specific CPU cores. On a shared development machine, this avoids contention with other processes. |
| `--node-id 1` | Unique identifier for this broker in the cluster. With a single broker it doesn't matter, but the parameter is required. |

Networking parameters:

Redpanda exposes two separate listeners for the Kafka protocol - one for
connections from inside Docker (other containers) and one for connections
from outside Docker (your laptop):

| Parameter | Internal (Docker) | External (your laptop) |
|---|---|---|
| `--kafka-addr` | `PLAINTEXT://0.0.0.0:29092` | `OUTSIDE://0.0.0.0:9092` |
| `--advertise-kafka-addr` | `PLAINTEXT://redpanda:29092` | `OUTSIDE://localhost:9092` |

Why two addresses? Kafka clients use a two-step connection process:

1. The client connects to a bootstrap server and asks for cluster metadata
2. The broker responds with advertised addresses - where the client should
   connect for actual data transfer

Inside Docker, containers find each other by service name, so the internal
advertised address is `redpanda:29092`. From your laptop, you connect via
the published port at `localhost:9092`. If we used only one address, either
Docker containers or your laptop wouldn't be able to connect.

The `--pandaproxy-addr` / `--advertise-pandaproxy-addr` follow the same
pattern for Redpanda's HTTP REST API (not used in this workshop).
The `--rpc-addr` / `--advertise-rpc-addr` are for internal cluster
communication between Redpanda nodes (not relevant with a single node).

Published ports:

| Port | What it's for |
|---|---|
| `9092` | Kafka protocol (external) - your Python producer/consumer connects here |
| `29092` | Kafka protocol (internal) - Flink containers will connect here later |
| `8082` / `28082` | HTTP Proxy - REST API access (not used in this workshop) |

Start Redpanda:

```bash
docker compose up redpanda -d
```

Verify it's running:

```bash
docker compose ps
```

```
NAME                IMAGE                           SERVICE    STATUS
workshop-redpanda   redpandadata/redpanda:v25.3.9   redpanda   Up
```
