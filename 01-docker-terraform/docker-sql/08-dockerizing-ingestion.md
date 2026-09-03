# Dockerizing the Ingestion Script

**[↑ Up](README.md)** | **[← Previous](07-pgadmin.md)** | **[Next →](09-docker-compose.md)**

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

ENTRYPOINT ["uv", "run", "python", "ingest_data.py"]
```

### Explanation

- `FROM python:3.13.11-slim`: Start with slim Python 3.13 image for smaller size
- `COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/`: Copy uv binary from official uv image
- `WORKDIR /code`: Set working directory inside container
- `ENV PATH="/code/.venv/bin:$PATH"`: Add virtual environment to PATH
- `COPY pyproject.toml .python-version uv.lock ./`: Copy dependency files first (better caching)
- `RUN uv sync --locked`: Install all dependencies from lock file (ensures reproducible builds)
- `COPY ingest_data.py .`: Copy ingestion script
- `ENTRYPOINT ["uv", "run", "python", "ingest_data.py"]`: Set entry point to run the ingestion script

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
    --pg-user=root \
    --pg-pass=root \
    --pg-host=pgdatabase \
    --pg-port=5432 \
    --pg-db=ny_taxi \
    --target-table=yellow_taxi_trips
```

### Important Notes

* We need to provide the network for Docker to find the Postgres container. It goes before the name of the image.
* Since Postgres is running on a separate container, the host argument will have to point to the container name of Postgres (`pgdatabase`).
* You can drop the table in pgAdmin beforehand if you want, but the script will automatically replace the pre-existing table.

## (Optional) Running pgAdmin in Docker

**pgAdmin** is a web-based administration tool for PostgreSQL that provides a graphical interface for browsing databases, executing SQL queries, managing schemas, and monitoring your PostgreSQL server without using the command line.

If you would like a graphical interface to inspect your PostgreSQL database, you can run pgAdmin as a separate Docker container.

### Start pgAdmin

```bash
docker run -it \
  --name pgadmin \
  --network=pg-network \
  -e PGADMIN_DEFAULT_EMAIL=admin@admin.com \
  -e PGADMIN_DEFAULT_PASSWORD=root \
  -v pgadmin_data:/var/lib/pgadmin \
  -p 8085:80 \
  dpage/pgadmin4
```

### Explanation

- `--name pgadmin`: Assigns the container the name `pgadmin`.
- `--network=pg-network`: Connects pgAdmin to the same Docker network as the PostgreSQL container, allowing it to communicate using the container name.
- `-e PGADMIN_DEFAULT_EMAIL=admin@admin.com`: Creates the default login email for pgAdmin.
- `-e PGADMIN_DEFAULT_PASSWORD=root`: Sets the password for the default pgAdmin account.
- `-v pgadmin_data:/var/lib/pgadmin`: Creates a Docker volume to persist pgAdmin settings and saved server connections.
- `-p 8085:80`: Maps port `8085` on your host machine to port `80` inside the container.

### Access pgAdmin

Once the container is running, open your browser and navigate to:

```
http://localhost:8085
```

Login using:

- **Email:** `admin@admin.com`
- **Password:** `root`

### Register the PostgreSQL Server

After logging in:

1. Right-click **Servers** → **Register** → **Server**.
2. Under the **General** tab:
   - **Name:** `Local PostgreSQL` (or any name you prefer)
3. Under the **Connection** tab:
   - **Host name/address:** `pgdatabase`
   - **Port:** `5432`
   - **Maintenance database:** `ny_taxi`
   - **Username:** `root`
   - **Password:** `root`
4. Click **Save**.

Since both containers are attached to the same Docker network (`pg-network`), pgAdmin can connect to PostgreSQL using the container name (`pgdatabase`) rather than `localhost`.

**[↑ Up](README.md)** | **[← Previous](07-pgadmin.md)** | **[Next →](09-docker-compose.md)**
