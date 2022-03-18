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

To interactively work with the postgres db in recorded way, we'll do work in an .ipynb file. I'm partial to jupyterlab, so I'll install that into my conda env and register that env with the ipython "kernel"

```bash
conda install -c conda-forge jupyterlab=3.3
python -m ipykernel install --user --name de_env --display-name "Python (de_env)"
```

And I'll navigate up the tree a bit to the root_directory of this course, then I'll start the jupyter server on port 8889 (I already have another jupyter server running on the default port)

```bash
x@y: ~/.../data-engineering-zoomcamp$ jupyter lab --port=8889
```

We will be working with public [NYC taxi data](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page), and I'll download that data in my jupyter labbook.

The data dictionarys for NYC cab cos are available via that link. We'll be initially working with yellow taxi data, so I'll include that [data dictionary link](https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf).


We also have a few more packages to install. This can be done while our jupyter server is running.

```bash
conda install -c conda-forge sqlalchemy
conda install -c conda-forge pandas
```

Subsequent initial data ingestion notes will be included in the notebook.

# pgAdmin4

pgAdmin4 is a nice interface for managing a postgres database system. We can spin up a pgAdmin4 container via the command

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 6432:80 \
dpage/pgadmin4
```

but if we want it to be able to access our postgres database container, we'll need to connect these currently isolated containers. We can do this by creating a `docker network` 

```bash
docker network create pg-network
```

and modifying the `docker run` command to include the network and container name for both our postgres container,

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
postgres:13
```

and our pgAdmin4 container

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 6432:80 \
  --network pg-network \
  --name pg-admin \
dpage/pgadmin4
```

After starting this up, you can access the webinterface at http://localhost:6432/ (swap out the port number if you used a different port number).

After logging in, click the **Add New Server** button. In the interface that pops up, enter the postgres server name we set above (pg-database), then click into the **Connection** tab, enter (pg-database) as the "Host name/address" and enter the postgres credentials from the `docker run` command, then Save the config. If things worked, you should see a dashboard showing sessions and connections, and in the left-side tray, you expanding `pg-database` and `Databases` should reveal our `ny_taxi` table.

## Containerizing our pipeline

We can convert our notebook into a script using `jupyter`'s `nbconvert` functionality. 

```bash
(de_env) matt@matt:...$ jupyter nbconvert --to=script ingest_data.ipynb 
[NbConvertApp] Converting notebook ingest_data.ipynb to script
[NbConvertApp] Writing 3411 bytes to ingest_data.py
(de_env) matt@matt:...$ ls -la
drwxrwxr-x  5 matt             matt  4096 Mar 17 19:47 .
drwxrwxr-x  4 matt             matt  4096 Mar 16 22:33 ..
-rw-rw-r--  1 matt             matt 22489 Mar 17 18:14 ingest_data.ipynb
-rw-rw-r--  1 matt             matt  3411 Mar 17 19:47 ingest_data.py
drwx------ 19 systemd-coredump matt  4096 Mar 17 19:36 ny_taxi_postgres_data
drwxrwxr-x  2 matt             matt  4096 Mar 17 17:29 ny_taxi_postgres_data_raw
-rw-rw-r--  1 matt             matt  4897 Mar 17 19:46 README.md

```

But, looking at the code, it's kind of a mess. I think I'll just make it from scratch.

I repackaged it into an ETL format, and I'll make a second dockerized version.

I saved that code in `ingest_data_cli.py`, and that script can be manually called via a command like:

```bash
python ingest_data_cli.py --user=root \
	--password=root \
	--host=localhost \
	--port=5432 \
	--db_name=ny_taxi \
	--table_name=yellow_taxi_data \
	--url=https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv \
	--raw_file_path=./data_raw/yellow_tripdata_2021-01.csv
```

Now to containerize the script. Using our prior Dockerfile as a base, we can add on some requirements, namely `sqlalchemy` for its ORM and `psycopg2` for its postgres drivers.

```
FROM python:3.9.1

RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data_cli.py ingest_data_cli.py 

ENTRYPOINT [ "python", "ingest_data_cli.py" ]
```

and we can build that via 
`docker build -t taxi_data_ingester:v01 .`

and rather than call python to run the script, we can run docker. Note that now, the `host` parameter refers to the postgres container, which we named `pg-database`. 

```bash
docker run -it \
  --network=pg-network \
  taxi_data_ingester:v01 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db_name=ny_taxi \
    --table_name=yellow_taxi_data \
    --url=https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv \
    --raw_file_path=./data_raw/yellow_tripdata_2021-01.csv
```