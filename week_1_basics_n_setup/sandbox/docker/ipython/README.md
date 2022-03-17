# Simple ipython terminal

Make a `Dockerfile` like

```Dockerfile
FROM python:3.9.1

RUN pip install pandas

ENTRYPOINT [ "bash" ]
```

(while at a command line in the directory with the Dockerfile) build it and give it the tag (`-t`) `test:pandas` via

`docker build -t test:pandas .`

and run it with an **i**nteractive **t**erminal (well a **t**ty)

`docker run -it test:pandas`

As the **ENTRYPOINT** is a `bash` terminal, you will have a `bash` terminal when you run the container.

Now, to do something a bit more interesting, you can write some pipeline code into a file, let's call it `pipeline.py`, and then edit the `Dockerfile` to copy that script into the container. `COPY` commands will have the form of 

`COPY <file_path_on_host> <file_path_in_container>`

and these paths can be relative, as shown below. I've also defined a `WORKDIR` for the container, which will be the base for relative paths in the container.

```Dockerfile
FROM python:3.9.1

RUN pip install pandas

WORKDIR /app
COPY pipeline.py pipeline.py

ENTRYPOINT [ "bash" ]
```

rebuild and rerun

```bash
docker build -t test:pandas .
docker run -it test:pandas
```

We can also add CLI args to our pipeline, as I've done in this commit. I've also edited the Dockerfile so that it just runs the python `pipeline.py` script when the container is started rather than just a bash terminal.

After making those changes, we rebuild, and then we can rerun it, but we have to provide an additional parameter or it will complain.

```bash
docker build -t test:pandas .
docker run -it test:pandas 2022-03-16
```