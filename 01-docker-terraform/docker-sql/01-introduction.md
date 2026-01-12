# Introduction to Docker

**[↑ Up](README.md)** | **[← Previous](README.md)** | **[Next →](02-virtual-environment.md)**

Docker is a _containerization software_ that allows us to isolate software in a similar way to virtual machines but in a much leaner way.

A Docker image is a _snapshot_ of a container that we can define to run our software, or in this case our data pipelines. By exporting our Docker images to Cloud providers such as Amazon Web Services or Google Cloud Platform we can run our containers there.

## Why Docker?

Docker provides the following advantages:

- Reproducibility: Same environment everywhere
- Isolation: Applications run independently
- Portability: Run anywhere Docker is installed

They are used in many situations:

- Integration tests: CI/CD pipelines
- Running pipelines on the cloud: AWS Batch, Kubernetes jobs
- Spark: Analytics engine for large-scale data processing
- Serverless: AWS Lambda, Google Functions

## Basic Docker Commands

Check Docker version:

```bash
docker --version
```

Run a simple container:

```bash
docker run hello-world
```

Run something more complex:

```bash
docker run ubuntu
```

Nothing happens. Need to run it in `-it` mode:

```bash
docker run -it ubuntu
```

We don't have `python` there so let's install it:

```bash
apt update && apt install python3
python3 -V
```

## Stateless Containers

Important: Docker containers are stateless - any changes done inside a container will NOT be saved when the container is killed and started again.

When you exit the container and use it again, the changes are gone:

```bash
docker run -it ubuntu
python3 -V
```

This is good, because it doesn't affect your host system. Let's say you do something crazy like this:

```bash
docker run -it ubuntu
rm -rf / # don't run it on your computer!
```

Next time we run it, all the files are back.

## Managing Containers

But, this is not _completely_ correct. The state is saved somewhere. We can see stopped containers:

```bash
docker ps -a
```

We can restart one of them, but we won't do it, because it's not a good practice. They take space, so let's delete them:

```bash
docker rm `docker ps -aq`
```

Next time we run something, we add `--rm`:

```bash
docker run -it --rm ubuntu
```

## Different Base Images

There are other base images besides `hello-world` and `ubuntu`. For example, Python:

```bash
docker run -it --rm python:3.9.16
# add -slim to get a smaller version
```

This one starts `python`. If we want bash, we need to overwrite `entrypoint`:

```bash
docker run -it \
    --rm \
    --entrypoint=bash \
    python:3.9.16-slim
```

## Volumes

So, we know that with docker we can restore any container to its initial state in a reproducible manner. But what about data? A common way to do so is with _volumes_.

Let's create some data in `test`:

```bash
mkdir test
cd test
touch file1.txt file2.txt file3.txt
echo "Hello from host" > file1.txt
cd ..
```

Now let's create a simple script `test/list_files.py` that shows the files in the folder:

```python
from pathlib import Path

current_dir = Path.cwd()
current_file = Path(__file__).name

print(f"Files in {current_dir}:")

for filepath in current_dir.iterdir():
    if filepath.name == current_file:
        continue

    print(f"  - {filepath.name}")

    if filepath.is_file():
        content = filepath.read_text(encoding='utf-8')
        print(f"    Content: {content}")
```

Now let's map this to a Python container:

```bash
docker run -it \
    --rm \
    -v $(pwd)/test:/app/test \
    --entrypoint=bash \
    python:3.9.16-slim
```

Inside the container, run:

```bash
cd /app/test
ls -la
cat file1.txt
python list_files.py
```

You'll see the files from your host machine are accessible in the container!

**[↑ Up](README.md)** | **[← Previous](README.md)** | **[Next →](02-virtual-environment.md)**
