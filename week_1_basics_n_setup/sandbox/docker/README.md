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