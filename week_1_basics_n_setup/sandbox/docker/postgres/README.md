# Postgres startup

The postgres server requires some environmental variables, `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`, 

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
postgres:13
```

and we'll also need to provide a volume if we want the data to persist. Inside the container, we'll use the default location for postgres data, `/var/lib/postgresql/data`, and on the host machine, we'll create a folder for the data we're going to collect, `$(pwd)//ny_taxi_postgres_data/`. `$(pwd)` (the print working directory command) expands to the calling directory making the path absolute.

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
postgres:13
```

and finally, we'll need to specify a port that the host machine can use to communicate with the container. The default port for postgres is 5432, and we'll map host-5432 to container-5432.

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
postgres:13
```

I made a conda env to work with the db, and installed `pgcli` in it

```bash
conda create -n de_env python=3.9
conda activate de_env
(de_env) ...$ conda install -c conda-forge pgcli
```

Using `pgcli`, we can now connect to the db from the command line.

```bash
pgcli -h localhost -p 5432 -u root -d ny_taxi
```

Enter that, provide the password from above ("root"), and we'll get basically a `psql` terminal. There's nothing in the db yet (which you can confirm via `\dt`).

https://www.youtube.com/watch?v=2JM-ziJt0WI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=4

Stopped 9 minutes and 32s in