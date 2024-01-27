# Use the official PostgreSQL image as the base
FROM python:alpine

RUN pip install pgcli

# Set the environment variables for PostgreSQL
ENV POSTGRES_USER=root \
    POSTGRES_PASSWORD=root \
    POSTGRES_DB=ny_taxi

# Expose the PostgreSQL port
EXPOSE 5432

# Start PostgreSQL when the container starts
CMD ["postgres:13"]
