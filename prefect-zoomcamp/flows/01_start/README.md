## Transcript for Video 2

In this session, we are going to take a look at a basic python script that pulls the yellow taxi data into a postgres db and then transforms that script to be orchestrated with Prefect. 

Prefect is the modern open source dataflow automation platform that will allow us to add observability and orchestration by utilizing python to write code as workflows to build,run and monitor pipelines at scale. 

First lets create a conda environment

`conda create -n zoom python=3.9` 

You can install the requirements found in requirements.txt ` pip install -r requirements.txt` or install Prefect `pip install prefect -U`

Now that we have everything install, you can see that this script is going to call a function called ingest_data which takes the parameters for a postgres db connection and will pull the data specified as a parameter and then load it into the postgres db. 

I’m going to be using pgAdmin4, and have already created the db named ny_taxi. Feel free to use whatever tool you are most familiar with to query postgres.

Let’s go ahead and run this script. 

`python ingest_data.py`

Alright looking in pgAdmin4, we can see that the data ingested into the postgres db. This is great but I had to manually trigger this python script. Using a workflow orchestration tool will allow me to add a scheduler so that I won’t have to trigger this script manually anymore. Additionally, I’ll get all the functionality that comes with workflow orchestation such as visibility, add resilience to the dataflow with automatic retries or caching and more. 

Let’s transform this into a Prefect flow. A flow is the most basic Prefect object that is a container for workflow logic and allows you to interact and understand the state of the workflow. Flows are like functions, they take inputs, preform work, and return an output. We can start by using the @flow decorator to a main_flow function. 

- import prefect with `from prefect import flow, task` 
- add `@flow(name="Ingest Flow")` above main() function

Flows contain tasks so let’s transform ingest_data into a task by adding the @task decorator. Tasks are not required for flows but tasks are special because they receive metadata about upstream dependencies and the state of those dependencies before the function is run, which gives you the opportunity to have a task wait on the completion of another task before executing. 

- add `@task(log_prints=True, retries=3)` above ingest_data() function

Now let’s run the ingest_data.py as a Prefect flow. 

`python ingest_data.py`

Awesome, so that just ran the script as a flow.  Alright let’s actually simplify this script and transform it into a extract and transform before we load the data into the postgres db. 

I’m going to start by breaking apart the large ingest_data function into multiple functions so that we can get more visibility into the tasks that are running or potentially causing failures. 

Let’s create a new task called extract data that will take the url for the csv and the task will actually return the results. Since this is pulling data from external my system (something I may not control) I want to add automatic retries and also add a caching so that if this task has already been run, it will not need to run again. 

- import `from prefect.tasks import task_input_hash`
- extract_data() code:
``` 
@task(log_prints=True, tags=["extract"], cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def extract_data(url: str):
    # the backup files are gzipped, and it's important to keep the correct extension
    # for pandas to be able to open the file
    if url.endswith('.csv.gz'):
        csv_name = 'yellow_tripdata_2021-01.csv.gz'
    else:
        csv_name = 'output.csv'
    
    os.system(f"wget {url} -O {csv_name}")

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    return df
```

Now that we have moved that logic into it’s own task, let’s call that task from the flow.

Next, If you look at the data in ny_taxi, you’ll see that on row 4, there is a passenger count of 0 so let’s do a transformation step to cleanse the data before we load the data to postgres. I’ll create a new task called transform_data for this. Notice how I can easily pass the dataframe to the following task.

- transform_data() function:
```
@task(log_prints=True)
def transform_data(df):
    print(f"pre: missing passenger count: {df['passenger_count'].isin([0]).sum()}")
    df = df[df['passenger_count'] != 0]
    print(f"post: missing passenger count: {df['passenger_count'].isin([0]).sum()}")
    return df
```
Lastly, let’s actually simplify the original ingest_data() function and rename this to load_data() 

```
@task(log_prints=True, retries=3)
def load_data(user, password, host, port, db, table_name, df):
  postgres_url = f'postgresql://{user}:{password}@{host}:{port}/{db}'
  engine = create_engine(postgresql_url)

  df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
  df.to_sql(name=table)name, con=engine, if_exists='append')
```
main() function now looks like: 
```
@flow(name="Ingest Flow")
def main(user, password, host, port, db, table_name, csv_url):
  raw_data = extract_data(csv_url)
  data = transform_data(raw_data)
  load_data(user, password, host, port, db, table_name, data)
```
Let’s clean the db and run the flow again with `drop table yellow_taxi_trips`

Now let's run our flow `python ingest_data.py` 

And if we look at the DB, we can see there are no more passenger counts of 0. 

There’s a lot more we can add by sprinkling in Prefect to our flow. We could parameterize the flow to take a table name so that we could change the table name loaded each time the flow was run. 

```
@flow(name="Ingest Data")
def main(table_name: str):
  user = "postgres"
  password = "admin"
  host = "localhost"
  port = "5433"
  db = "ny_taxi"
  table_name = "yellow_taxi_trips"
  csv_url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

  raw_data = extract_data(csv_url)
  data = transform_data(raw_data)
  load_data(user, password, host, port, db, table_name, data)

if __name__ == "__main__":
  main("yellow_taxi_trips")
```

We could add a subflow. There’s a lot more you can do but here are just a few examples. 

add function log_subflow():
```
@flow(name="Subflow", log_prints=True)
def log_subflow(table_name : str):
  print(f"Logging Subflow for {table_name}")
```

add newline `log_subflow(table_name)` to the main() flow

Alright let’s run the flow and then open the open source UI to visual. 

`python ingest_data.py`
`python orion start`

This should default but if your having problem or just want to make sure you set the prefect config to point to the api URL. This is especially important if you are going to host the Url somewhere else and need to change the url for the api that your flows are communicating with. 

`prefect config set PREFECT_API_URL="http://127.0.0.1:4200/api"`


Alright opening up localhost we can see the Prefect UI, which gives us a nice dashboard to see all of our flow run history. 

If we run a flow again we can see <flow name> in our terminal and the look at the UI and can see that same flow name. 

A quick navigation lets us dive into the logs of that flow run, navigate around. You’ll notice over on the side we have Deployments, Workqueues Blocks, Notifications, and TaskRun Concurrency. 

We will get to Deployments and Workques in later video but I want to quickly touch on Blocks, Notifications and TaskRun Concurrency.  

Task Run concurrency can be configured on tasks by adding a tag to the task and then setting a limit through a CLI command.

Notifications are important so that we know when something has failed or is wrong with our system. Instead of having to monitor our dashboard frequently, we can get a notification when something goes wrong and needs to be investigated.

Blocks are my personal favorite feature of Prefect. Blocks are a primitive within Prefect that enable the storage of configuration and provide an interface with interacting with external systems. There are several different types of blocks you can build, and you can even create your own. Block names are immutable so they can be reused across multiple flows. Blocks can also build upon blocks or be installed as part of Intergration collection which is prebuilt tasks and blocks that are pip installable. For example, a lot of users use the SqlAlchemy

Let’s actually take our postgres configuration and store that in a block 
- pip install SQL Alchemy
- Create a SQL Alchemy Connector block and place all configuration in there
- Change the flow code:
  - add `from prefect_sqlalchemy import SqlAlchemyConnector`
  - change load_data() function:
    ```
    @task(log_prints=True, retries=3)
    def load_data(table_name, df):
    
      connection_block = SqlAlchemyConnector.load("postgres-connector")
      with connection_block.get_connection(begin=False) as engine:
          df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
          df.to_sql(name=table_name, con=engine, if_exists='append')

    ```

Alright run the flow and let’s see if it was successful in the UI. 


