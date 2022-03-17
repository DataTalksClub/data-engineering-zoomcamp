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

Subsequent notes will be included in the notebook.