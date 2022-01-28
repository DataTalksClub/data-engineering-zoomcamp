### Setup

[Airflow Setup with Docker](1_setup.md)

### Execution

1. Build the image (only first-time, or when there's any change in the `Dockerfile`):
Takes ~15 mins for the first-time
```shell
docker-compose build
```
or (for legacy versions)
```shell
docker build .
```

2. Initialize the Airflow scheduler, DB, and other config
```shell
docker-compose up airflow-init
```

3. Kick up the all the services from the container:
```shell
docker-compose up
```

4. Login to Airflow web UI on `localhost:8080` with default creds: `airflow/airflow`

5. Run your DAG on the Web Console.

6. On finishing your run or to shut down the container/s:
```shell
docker-compose down
```

For more info, check out these official docs:
   * https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html
   * https://airflow.apache.org/docs/docker-stack/build.html
   * https://airflow.apache.org/docs/docker-stack/recipes.html
   

### Future Enhancements
* Deploy self-hosted Airflow setup on Kubernetes cluster, or use a Managed Airflow (Cloud Composer) service by GCP
