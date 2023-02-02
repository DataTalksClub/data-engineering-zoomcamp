## Transcript for Video 5

Hi all! Today we’re going to be going over how to add Parameterization to your flows and create deployments. We’re going to be expanding on the etl_web_to_gsc.py so let’s go ahead and create a new file called parameterized_flow.py. If you’re following along with the github you can see this is the flows/03_deployments folder. 
And as a reminder this is building upon the existing flow and blocks that we can configured so if you haven’t already configured the GCS Bucket block, go back and make sure you do that first. 

So to start, let’s allow our flow to take parameters of year, month, and color:

```
@flow()
def etl_web_to_gcs(year: int, month: int, color: str) -> None:
    """The main ETL function"""
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
``` 


Now let’s actually make a parent flow that will pass these parameters to the etl flow and we can set some defaults. This way I’m able to loop over a list of months and run the etl pipeline for each dataset. 

```
@flow()
def etl_parent_flow(
    months: list[int] = [1, 2], year: int = 2021, color: str = "yellow"
):
    for month in months:
        etl_web_to_gcs(year, month, color)
```
Once we have those parameters we can call the parent flow from main:

```
if __name__ == "__main__":
    color = "yellow"
    months = [1,2,3]
    year = 2021
    etl_parent_flow(months, year, color)
```
And just for good measure let’s add that caching key back to our fetch() function
- add `from prefect.tasks import task_input_hash`
- `@task(retries=3,cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))`

Alright let’s go a head and run this and make sure we can see the output in the Cloud  UI

A deployment in Prefect is a server-side concept that encapsulates a flow, allowing it to be scheduled and triggered via the API. 

A flow can have multiple deployments and you can think of it as the container of metadata needed for the flow to be scheduled. This might be what type of infrastructure the flow will run on, or where the flow code is stored, maybe it’s scheduled or has certain parameters. 

There are two ways to create a deployment. One is using the CLI command and the other is with python. Jeff will show how to set up the deployment with Python in the next video so for now we are going to create one using the CLI. 

Inside your terminal we can type  `prefect deployment build ./parameterized_flow.py:etl_parent_flow -n "Parameterized ETL"`

Now you can see it created a yaml file with all our details. This is the metadata. We can adjust the parameters here or in the UI after we apply but let’s just do it here:
- edit yaml with ` parameters: { "color": "yellow", "months" :[1, 2, 3], "year": 2021}`

Now we need to apply the deployment: `prefect deployment apply etl_parent_flow-deployment.yaml`

Here we can see the deployment in the UI, trigger a flow run, and you’ll notice this goes to late. That is because we are now using the API to trigger and schedule flow runs with this deployment instead of manually and we need to have an agent living in our execution environment (local) 




