FROM flink:2.2.0-scala_2.12-java17

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

# ref: https://nightlies.apache.org/flink/flink-docs-release-2.2/docs/deployment/resource-providers/standalone/docker/#using-flink-python-on-docker

WORKDIR /opt/pyflink
COPY pyproject.flink.toml pyproject.toml
RUN uv python install 3.12 && uv sync
ENV PATH="/opt/pyflink/.venv/bin:$PATH"

# Download connector libraries

WORKDIR /opt/flink/lib
RUN wget https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/2.2.0/flink-json-2.2.0.jar; \
    wget https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kafka/4.0.1-2.0/flink-sql-connector-kafka-4.0.1-2.0.jar; \
    wget https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc-core/4.0.0-2.0/flink-connector-jdbc-core-4.0.0-2.0.jar; \
    wget https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc-postgres/4.0.0-2.0/flink-connector-jdbc-postgres-4.0.0-2.0.jar; \
    wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.10/postgresql-42.7.10.jar

COPY flink-config.yaml /opt/flink/conf/config.yaml

WORKDIR /opt/flink
