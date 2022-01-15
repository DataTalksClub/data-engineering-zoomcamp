### Setup

1. Create a new sub-directory called `airflow` in your `project` dir (such as the one we're currently in)
   
2. Import the official image & setup from the latest Airflow version:
   ```shell
   curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
   ```
   
3. It could be overwhelming to see a lot of services in here. 
   But this is only a quick-start template, and as you proceed you'll figure out which unused services can be removed.
   [Here's](extras/docker-compose-nofrills.yml) a non-frills version of that template.
   
4. Build a custom `Dockerfile` pointing to the current Airflow version, 
   such as `apache/airflow:2.2.3`, as the base image
   
5. In this `Dockerfile`:
   * Add your custom packages to be installed. The one we'll need the most is `gcloud` to connect with the GCS bucket/Data Lake.
   * Also use `requirements.txt` to install libraries via  `pip install`
   * Load your `service-account-key` (eg. `google_credentials.json`) to the container path, and set the env-var `GOOGLE_APPLICATION_CREDENTIALS`.
   
6. Back in your `docker-compose.yaml`:
   * Remove the `image` tag in `x-airflow-common`, to replace it with your `build` from your Dockerfile.
   * Change `AIRFLOW__CORE__LOAD_EXAMPLES` to `false` (optional)
   
7. Here's how the final versions of your [Dockerfile](./Dockerfile) and [docker-compose.yml](./docker-compose.yaml) should look.
   

### Execution

1. Build the image (only first-time, or when there's any change in the `Dockerfile`):
```shell
docker compose build
```

2. Initialize the Airflow scheduler, DB, and other config
```shell
docker compose up airflow-init
```

3. Kick up the all the services from the container:
```shell
docker compose up
```

4. Login to Airflow web UI on `localhost:8080` with default creds: `airflow/airflow`

5. Run your DAG ()


For more info, check out these official docs:
   * https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html
   * https://airflow.apache.org/docs/docker-stack/build.html
   * https://airflow.apache.org/docs/docker-stack/recipes.html
   

### Future Enhancements
* Deploy self-hosted Airflow setup on Kubernetes cluster, or use a Managed Airflow (Cloud Composer) service by GCP
