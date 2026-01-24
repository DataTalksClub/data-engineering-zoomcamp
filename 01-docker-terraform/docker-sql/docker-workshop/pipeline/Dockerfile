FROM python:3.13.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/


# set up the working directory inside the container
WORKDIR /code

# set up our image by installing prerequisites; pandas in this case
COPY "pyproject.toml" "uv.lock" ".python-version" ./
# Install dependencies from lock file (ensures reproducible builds)
RUN uv sync --locked


# copy the script to the container. 1st name is source file, 2nd is destination
COPY pipeline.py .

ENTRYPOINT ["uv", "run", "python", "pipeline.py" ]
