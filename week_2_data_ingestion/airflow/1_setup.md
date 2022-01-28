
### Pre-Reqs

1. For the sake of standardization across this tutorial's config,
    rename your gcp-service-accounts-credentials file to `google_credentials.json` & store it in your `$HOME` directory
    ``` bash
        cd ~ && mkdir -p ~/.google/credentials/
        mv <path/to/your/service-account-authkeys>.json ~/.google/credentials/google_credentials.json
    ```

2. You may need to upgrade your docker-compose version to v2.x+, and set the memory for your Docker Engine to minimum 5GB
(ideally 8GB). If enough memory is not allocated, it might lead to airflow-webserver continuously restarting.

3. Python version: 3.7+


### Airflow Setup

1. Create a new sub-directory called `airflow` in your `project` dir (such as the one we're currently in)
   
2. **Import the official image** & setup from the latest Airflow version:
   ```shell
   curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
   ```
   
3. It could be overwhelming to see a lot of services in here. 
   But this is only a quick-start template, and as you proceed you'll figure out which unused services can be removed.
   Eg. [Here's](extras/docker-compose-nofrills.yml) a no-frills version of that template.

4. **Set the Airflow user**:

    On Linux, the quick-start needs to know your host user-id and needs to have group id set to 0. 
    Otherwise the files created in `dags`, `logs` and `plugins` will be created with root user. 
    You have to make sure to configure them for the docker-compose:

    ```bash
    mkdir -p ./dags ./logs ./plugins
    echo -e "AIRFLOW_UID=$(id -u)" > .env
    ```

    On Windows you will probably also need it. If you use MINGW/GitBash, execute the same command. 

    To get rid of the warning ("AIRFLOW_UID is not set"), you can create `.env` file with
    this content:

    ```
    AIRFLOW_UID=50000
    ```

5. **Docker Build**:

    When you want to run Airflow locally, you might want to use an extended image, 
    containing some additional dependencies - for example you might add new python packages, 
    or upgrade airflow providers to a later version.
    
    Create a `Dockerfile` pointing to Airflow version you've just downloaded, 
    such as `apache/airflow:2.2.3`, as the base image,
       
    And customize this `Dockerfile` by:
    * Adding your custom packages to be installed. The one we'll need the most is `gcloud` to connect with the GCS bucket/Data Lake.
    * Also, integrating `requirements.txt` to install libraries via  `pip install`
   
7. **Docker Compose**:

    Back in your `docker-compose.yaml`:
   * In `x-airflow-common`: 
     * Remove the `image` tag, to replace it with your `build` from your Dockerfile, as shown
     * Mount your `google_credentials` in `volumes` section as read-only
     * Set environment variables `GOOGLE_APPLICATION_CREDENTIALS` and `AIRFLOW_CONN_GOOGLE_CLOUD_DEFAULT`
   * Change `AIRFLOW__CORE__LOAD_EXAMPLES` to `false` (optional)

8. Here's how the final versions of your [Dockerfile](./Dockerfile) and [docker-compose.yml](./docker-compose.yaml) should look.
