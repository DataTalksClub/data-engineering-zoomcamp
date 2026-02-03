FROM python:3.10-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /code
ENV PATH="/code/.venv/bin:$PATH"

COPY pyproject.toml .python-version uv.lock ./
RUN uv sync --locked

COPY ingest_data_green_taxi_2025_11.py .

ENTRYPOINT ["python", "ingest_data_green_taxi_2025_11.py"]