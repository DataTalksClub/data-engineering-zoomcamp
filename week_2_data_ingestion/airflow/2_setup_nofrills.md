## Setup (No-frills)

### Pre-Reqs

1. For the sake of standardization across this workshop's config,
    rename your gcp-service-accounts-credentials file to `google_credentials.json` & store it in your `$HOME` directory
    ``` bash
        cd ~ && mkdir -p ~/.google/credentials/
        mv <path/to/your/service-account-authkeys>.json ~/.google/credentials/google_credentials.json
    ```

2. You may need to upgrade your docker-compose version to v2.x+, and set the memory for your Docker Engine to minimum 4GB
(ideally 8GB). If enough memory is not allocated, it might lead to airflow-webserver continuously restarting.

3. Python version: 3.7+


### Airflow Setup

1. Create a new sub-directory called `airflow` in your `project` dir (such as the one we're currently in)
   
2. **Set the Airflow user**:

    On Linux, the quick-start needs to know your host user-id and needs to have group id set to 0. 
    Otherwise the files created in `dags`, `logs` and `plugins` will be created with root user. 
    You have to make sure to configure them for the docker-compose:

    ```bash
    mkdir -p ./dags ./logs ./plugins
    echo -e "AIRFLOW_UID=$(id -u)" >> .env
    ```

    On Windows you will probably also need it. If you use MINGW/GitBash, execute the same command. 

    To get rid of the warning ("AIRFLOW_UID is not set"), you can create `.env` file with
    this content:

    ```
    AIRFLOW_UID=50000
    ```

3. **Docker Build**:

    When you want to run Airflow locally, you might want to use an extended image, 
    containing some additional dependencies - for example you might add new python packages, 
    or upgrade airflow providers to a later version.
    
    Create a `Dockerfile` pointing to the latest Airflow version such as `apache/airflow:2.2.3`, for the base image,
       
    And customize this `Dockerfile` by:
    * Adding your custom packages to be installed. The one we'll need the most is `gcloud` to connect with the GCS bucket (Data Lake).
    * Also, integrating `requirements.txt` to install libraries via  `pip install`

4. Copy [docker-compose-nofrills.yml](docker-compose-nofrills.yml), [.env_example](.env_example) & [entrypoint.sh](scripts/entrypoint.sh) from this repo.
    The changes from the official setup are:
    * Removal of `redis` queue, `worker`, `triggerer`, `flower` & `airflow-init` services, 
    and changing from `CeleryExecutor` (multi-node) mode to `LocalExecutor` (single-node) mode 
    * Inclusion of `.env` for better parametrization & flexibility
    * Inclusion of simple `entrypoint.sh` to the `webserver` container, responsible to initialize the database and create login-user (admin).
    * Updated `Dockerfile` to grant permissions on executing `scripts/entrypoint.sh`
        
5. `.env`:
    * Rebuild your `.env` file by making a copy of `.env_example` (but make sure your `AIRFLOW_UID` remains):
        ```shell
        mv .env_example .env
        ```
    * Set environment variables `AIRFLOW_UID`, `GCP_PROJECT_ID` & `GCP_GCS_BUCKET`, as per your config.
    * Optionally, if your `google-credentials.json` is stored somewhere else, such as a path like `$HOME/.gc`, 
    modify the env-vars (`GOOGLE_APPLICATION_CREDENTIALS`, `AIRFLOW_CONN_GOOGLE_CLOUD_DEFAULT`) and `volumes` path in `docker-compose-nofrills.yml`

6. Here's how the final versions of your [Dockerfile](./Dockerfile) and [docker-compose-nofrills](./docker-compose-nofrills.yml) should look.


## Problems

### `File /.google/credentials/google_credentials.json was not found`

First, make sure you have your credentials in your `$HOME/.google/credentials`.
Maybe you missed the step and didn't copy the your JSON with credentials there?
Also, make sure the file-name is `google_credentials.json`.

Second, check that docker-compose can correctly map this directory to airflow worker.

Execute `docker ps` to see the list of docker containers running on your host machine and find the ID of the airflow worker.

Then execute `bash` on this container:

```bash
docker exec -it <container-ID> bash
```

Now check if the file with credentials is actually there:

```bash
ls -lh /.google/credentials/
```

If it's empty, docker-compose couldn't map the folder with credentials. 
In this case, try changing it to the absolute path to this folder:

```yaml
  volumes:
    - ./dags:/opt/airflow/dags
    - ./logs:/opt/airflow/logs
    - ./plugins:/opt/airflow/plugins
    # here: ----------------------------
    - c:/Users/alexe/.google/credentials/:/.google/credentials:ro
    # -----------------------------------
```
