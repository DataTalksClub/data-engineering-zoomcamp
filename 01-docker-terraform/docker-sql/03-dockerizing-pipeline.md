# Dockerizing the Pipeline

**[↑ Up](README.md)** | **[← Previous](02-virtual-environment.md)** | **[Next →](04-postgres-docker.md)**

Now let's containerize the script. Create the following `Dockerfile` file:

## Simple Dockerfile with pip

```dockerfile
# base Docker image that we will build on
FROM python:3.13.11-slim

# set up our image by installing prerequisites; pandas in this case
RUN pip install pandas pyarrow

# set up the working directory inside the container
WORKDIR /app
# copy the script to the container. 1st name is source file, 2nd is destination
COPY pipeline.py pipeline.py

# define what to do first when the container runs
# in this example, we will just run the script
ENTRYPOINT ["python", "pipeline.py"]
```

**Explanation:**

- `FROM`: Base image (Python 3.13)
- `RUN`: Execute commands during build
- `WORKDIR`: Set working directory
- `COPY`: Copy files into the image
- `ENTRYPOINT`: Default command to run

### Build and Run

Let's build the image:

```bash
docker build -t test:pandas .
```

* The image name will be `test` and its tag will be `pandas`. If the tag isn't specified it will default to `latest`.

We can now run the container and pass an argument to it, so that our pipeline will receive it:

```bash
docker run -it test:pandas some_number
```

You should get the same output you did when you ran the pipeline script by itself.

> Note: these instructions assume that `pipeline.py` and `Dockerfile` are in the same directory. The Docker commands should also be run from the same directory as these files.

## Dockerfile with uv

What about uv? Let's use it instead of using pip:

```dockerfile
# Start with slim Python 3.13 image
FROM python:3.13.10-slim

# Copy uv binary from official uv image (multi-stage build pattern)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

# Set working directory
WORKDIR /app

# Add virtual environment to PATH so we can use installed packages
ENV PATH="/app/.venv/bin:$PATH"

# Copy dependency files first (better layer caching)
COPY "pyproject.toml" "uv.lock" ".python-version" ./
# Install dependencies from lock file (ensures reproducible builds)
RUN uv sync --locked

# Copy application code
COPY pipeline.py pipeline.py

# Set entry point
ENTRYPOINT ["python", "pipeline.py"]
```

**[↑ Up](README.md)** | **[← Previous](02-virtual-environment.md)** | **[Next →](04-postgres-docker.md)**
