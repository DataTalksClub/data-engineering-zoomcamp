# Postgres startup

The postgres server requires some environmental variables, `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`, 

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
postgres:13
```

and we'll also need to provide a volume if we want the data to persist. Inside the container, we'll use the default location for postgres data, `/var/lib/postgresql/data`, and on the host machine, we'll create a folder for the data we're going to collect, `/ny_taxi_postgres_data/`

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ny_taxi_postgres_data:/var/lib/postgresql/data \
postgres:13
```

and finally, we'll need to specify a port that the host machine can use to communicate with the container. The default port for postgres is 5432, and we'll map host-5432 to container-5432.

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
postgres:13
```