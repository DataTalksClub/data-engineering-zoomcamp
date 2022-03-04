# dbt with BigQuery on Docker

This is a quick guide on how to setup dbt with BigQuery on Docker.

**Note:** You will need your authentication json key file for this method to work. You can use oauth alternatively.

- Create a directory with the name of your choosing.
  ```
  mkdir <dir-name>
  ```
- cd into the directory
  ```
  cd <dir-name>
  ```
- Copy this [Dockerfile](Dockerfile) in your directory borrowed from the official dbt git [here](https://github.com/dbt-labs/dbt-core/blob/main/docker/Dockerfile)
- Create `docker-compose.yaml` [file](docker-compose.yaml).
  ```yaml
  version: '3'
    services:
      dbt-bq-dtc:
        build:
          context: .
          target: dbt-bigquery
        image: dbt/bigquery
        volumes:
          - .:/usr/app
          - ~/.dbt/:/root/.dbt/
          - ~/.google/credentials/google_credentials.json:/.google/credentials/google_credentials.json
        network_mode: host
  ```
  -   Name the service as you deem right or `dbt-bq-dtc`.
  -   Use the `Dockerfile` in the current directory to build the image by passing `.` in the context.
  -   `target` specifies that we want to install the `dbt-bigquery` plugin in addition to `dbt-core`.
  -  Mount 3 volumes -
     - for persisting dbt data
     - path to the dbt `profiles.yml`
     - path to the `google_credentials.json` file which should be in the `~/.google/credentials/` path

- Create `profiles.yml` file in `~/.dbt/` in your local machine or add the following code in your existing `profiles.yml` - 
  ```yaml
  bq-dbt-workshop:
    outputs:
      dev:
        dataset: <bigquery-dataset>
        fixed_retries: 1
        keyfile: /.google/credentials/google_credentials.json
        location: EU
        method: service-account
        priority: interactive
        project: <gcp-project-id>
        threads: 4
        timeout_seconds: 300
        type: bigquery
    target: dev
  ```
  - Name the profile. `bq-dbt-workshop` in my case. This will be used in the `dbt_project.yml` file to refer and initiate dbt.
  - Replace with your `dataset`, `location` (my GCS bucket is in `EU` region, change to `US` if needed), `project` values.
- Run the following commands -
  - ```bash 
    docker compose build 
    ```
  - ```bash 
    docker compose run dbt-bq-dtc init
    ``` 
    - **Note:** We are essentially running `dbt init` above because the `ENTRYPOINT` in the [Dockerfile](Dockerfile) is `['dbt']`.
    - Input the required values. Project name will be `taxi_rides_ny`
    - This should create `dbt/taxi_rides_ny/` and you should see `dbt_project.yml` in there.
    - In `dbt_project.yml`, replace `profile: 'taxi_rides_ny'` with `profile: 'bq-dbt-workshop'` as we have a profile with the later name in our `profiles.yml`
  - ```bash
    docker compose run --workdir="//usr/app/dbt/taxi_rides_ny" dbt-bq-dtc debug
     ``` 
    - to test your connection. This should output `All checks passed!` in the end.
    - **Note:** The automatic path conversion in Git Bash will cause the commands to fail with `--workdir` flag. It can be fixed by prefixing the path with `//` as is done above. The solution was found [here](https://github.com/docker/cli/issues/2204#issuecomment-638993192).
    - Also, we change the working directory to the dbt project because the `dbt_project.yml` file should be in the current directory. Else it will throw `1 check failed: Could not load dbt_project.yml`