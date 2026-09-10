# The Flink image and services

Flink doesn't come with Python support out of the box. We need a custom
Docker image with Python, PyFlink, and connector JARs.


*The image packages the workshop dependencies; the JobManager coordinates work while TaskManager slots execute it in parallel.*

Download the Flink build files:

```bash
PREFIX="https://raw.githubusercontent.com/DataTalksClub/data-engineering-zoomcamp/main/07-streaming/workshop"

wget ${PREFIX}/Dockerfile.flink
wget ${PREFIX}/pyproject.flink.toml
wget ${PREFIX}/flink-config.yaml
```

> If you cloned the repository, these files are already in the
> `cohorts/2027/07-streaming/code/` directory.

You can look at
[`Dockerfile.flink`](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2027/07-streaming/code/Dockerfile.flink)
to see what it does:

- Starts from the official Flink image (`flink:2.2.0-scala_2.12-java17`)
- Installs Python 3.12 and PyFlink via uv
- Downloads connector JARs (Kafka, JDBC, PostgreSQL driver)
- Applies a custom Flink config to increase JVM metaspace for PyFlink

Now add the Flink services to `docker-compose.yml`. A Flink cluster has
two types of processes - let's add them one at a time.

The JobManager is the coordinator. It accepts jobs, manages checkpoints,
and assigns work to task managers. You interact with it through the web UI
(port `8081`) and submit jobs via its RPC port (`6123`):

```yaml
  jobmanager:
    build:
      context: .
      dockerfile: ./Dockerfile.flink
    image: pyflink-workshop
    pull_policy: never
    expose:
      - "6123"
    ports:
      - "8081:8081"
    volumes:
      - ./:/opt/flink/usrlib
      - ./src/:/opt/src
    command: jobmanager
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        jobmanager.memory.process.size: 1600m
```

- `build` + `image: pyflink-workshop` - builds our custom Docker image and
  tags it as `pyflink-workshop`. The taskmanager will reuse this same image
  without rebuilding.
- `pull_policy: never` - don't try to pull `pyflink-workshop` from Docker Hub
  (it doesn't exist there - we built it locally).
- `volumes` - mount the source code into the container so we can submit jobs
  without rebuilding the image.
- `FLINK_PROPERTIES` - Flink configuration passed as an environment variable.
  `jobmanager.rpc.address: jobmanager` tells Flink where the coordinator
  lives (`jobmanager` is the Docker service name).

The TaskManager is the worker. It executes the actual data processing:

```yaml
  taskmanager:
    image: pyflink-workshop
    pull_policy: never
    expose:
      - "6121"
      - "6122"
    volumes:
      - ./:/opt/flink/usrlib
      - ./src/:/opt/src
    depends_on:
      - jobmanager
    command: taskmanager --taskmanager.registration.timeout 5 min
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        taskmanager.memory.process.size: 1728m
        taskmanager.numberOfTaskSlots: 15
        parallelism.default: 3
```

- `image: pyflink-workshop` - reuses the image built by the jobmanager
  service, no `build` needed.
- `depends_on: jobmanager` - start after the jobmanager.
- `--taskmanager.registration.timeout 5 min` - give the task manager
  5 minutes to find the job manager on startup (useful when services start
  in parallel).
- `taskmanager.numberOfTaskSlots: 15` - this task manager has 15 slots.
- `parallelism.default: 3` - by default, each pipeline stage runs 3 copies
  processing data in parallel.

A task slot is a unit of resources (memory, CPU) that can run one parallel
instance of a pipeline stage. Think of slots like lanes on a highway - more
lanes means more data can flow through at once. If you submit a job with
parallelism 3, that job uses 3 slots. With 15 slots available, you can run
5 such jobs simultaneously on this single task manager. In production, you'd
have multiple task managers across different machines, each contributing
slots to the cluster. The job manager decides which slots run which parts
of which jobs.

Make sure `src/` exists before starting Docker - the volume mount
`./src/:/opt/src` will create it as root if it doesn't exist, causing
permission issues later when you try to create files inside it:

```bash
mkdir -p src/job
```

Build the Flink image and start all services:

```bash
docker compose up --build -d
```

The first build takes a few minutes - it installs Python, PyFlink, and downloads
the connector JARs.

Verify all four services are running:

```bash
docker compose ps
```

```
NAME                  IMAGE                           SERVICE        STATUS
workshop-jobmanager   pyflink-workshop                jobmanager     Up
workshop-taskmanager  pyflink-workshop                taskmanager    Up
workshop-postgres     postgres:18                     postgres       Up
workshop-redpanda     redpandadata/redpanda:v25.3.9   redpanda       Up
```

Check the Flink dashboard at [http://localhost:8081](http://localhost:8081) -
you should see 1 task manager with 15 available task slots.
