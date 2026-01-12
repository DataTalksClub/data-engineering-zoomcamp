# Dockerizing the Ingestion Script

**[↑ Up](README.md)** | **[← Previous](06-pgadmin.md)** | **[Next →](08-docker-compose.md)**

Now let's containerize the ingestion script so we can run it in Docker.

## The Dockerfile

The `pipeline/Dockerfile` shows how to containerize the ingestion script:

```dockerfile
FROM python:3.13.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /code
ENV PATH="/code/.venv/bin:$PATH"

COPY pyproject.toml .python-version uv.lock ./
RUN uv sync --locked

COPY ingest_data.py .

ENTRYPOINT ["python", "ingest_data.py"]
```

### Explanation

- `FROM python:3.13.11-slim`: Start with slim Python 3.13 image for smaller size
- `COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/`: Copy uv binary from official uv image
- `WORKDIR /code`: Set working directory inside container
- `ENV PATH="/code/.venv/bin:$PATH"`: Add virtual environment to PATH
- `COPY pyproject.toml .python-version uv.lock ./`: Copy dependency files first (better caching)
- `RUN uv sync --locked`: Install all dependencies from lock file (ensures reproducible builds)
- `COPY ingest_data.py .`: Copy ingestion script
- `ENTRYPOINT ["python", "ingest_data.py"]`: Set entry point to run the ingestion script

## Build the Docker Image

```bash
cd pipeline
docker build -t taxi_ingest:v001 .
```

## Run the Containerized Ingestion

```bash
docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table=yellow_taxi_trips
```

### Important Notes

* We need to provide the network for Docker to find the Postgres container. It goes before the name of the image.
* Since Postgres is running on a separate container, the host argument will have to point to the container name of Postgres (`pgdatabase`).
* You can drop the table in pgAdmin beforehand if you want, but the script will automatically replace the pre-existing table.

**[↑ Up](README.md)** | **[← Previous](06-pgadmin.md)** | **[Next →](08-docker-compose.md)**
