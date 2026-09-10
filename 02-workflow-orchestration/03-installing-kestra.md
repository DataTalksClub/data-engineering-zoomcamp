---
video_url: https://www.youtube.com/watch?v=wgPxC4UjoLM
---
# Installing Kestra

To install Kestra, we are going to use Docker Compose. We already have a Postgres database set up, along with pgAdmin from Module 1. We can continue to use these with Kestra but we'll need to make a few modifications to our Docker Compose file.

Use [this example Docker Compose file](docker-compose.yml) to correctly add the 2 new services and set up the volumes correctly.

Add information about setting a username and password.

We'll set up Kestra using Docker Compose containing one container for the Kestra server and another for the Postgres database:


```bash
cd 02-workflow-orchestration
docker compose up -d
```

**Note:** Check that `pgAdmin` isn't running on the same ports as Kestra. If so, check out the [FAQ](#troubleshooting-tips) at the bottom of the README.

Once the container starts, you can access the Kestra UI at [http://localhost:8080](http://localhost:8080).

To shut down Kestra, go to the same directory and run the following command:

```bash
docker compose down
```
## Add Flows to Kestra
Flows can be added to Kestra by copying and pasting the YAML directly into the editor, or by adding via Kestra's API. See below for adding programmatically.

<details>
<summary>Add Flows to Kestra programmatically</summary>

If you prefer to add flows programmatically using Kestra's API, run the following commands:

```bash
# Import all flows: assuming username admin@kestra.io and password Admin1234! (adjust to match your username and password)
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/01_hello_world.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/02_python.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/03_getting_started_data_pipeline.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/04_postgres_taxi.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/05_postgres_taxi_scheduled.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/06_gcp_kv.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/07_gcp_setup.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/08_gcp_taxi.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/09_gcp_taxi_scheduled.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/10_chat_without_rag.yaml
curl -X POST -u 'admin@kestra.io:Admin1234!' http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/11_chat_with_rag.yaml
```
</details>

## Resources
- [Install Kestra with Docker Compose](https://go.kestra.io/de-zoomcamp/docker-compose)
