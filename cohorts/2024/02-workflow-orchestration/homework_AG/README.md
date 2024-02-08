# Homework

Clone the mage repo:

```bash
git clone https://github.com/mage-ai/mage-zoomcamp.git mage-zoomcamp
```

Navigate to the repo:

```
cd mage-data-engineering-zoomcamp
```

Rename dev.env to simply .env— this will ensure the file is not committed to Git by accident, since it will contain credentials in the future.

```
cp dev.env .env
```

Now, build the container [after making sure that the docker daemon is running]:
```
docker compose build
```

Start the Docker container:
```
docker compose up
```

Navigate to http://localhost:6789 in your browser.

The rest of the exercise was done on mage. But I copy the relevant files for:
* data_loaders
* transformers
* data_exporters

to this directory for evaluation.