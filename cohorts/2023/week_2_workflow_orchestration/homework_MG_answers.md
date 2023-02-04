## Week 2 Homework

The goal of this homework is to familiarise users with workflow orchestration and observation. 

### Setup up GCP using terraform from week1
Use terraform from week1

```shell
# Refresh service-account's auth-token for this session
export GOOGLE_APPLICATION_CREDENTIALS="/home/michal/.gcloud/tokens/magnetic-energy-375219-c1c78ad83f33.json"
gcloud auth application-default login

# Initialize state file (.tfstate)
terraform init

# Check changes to new infra plan
terraform plan -var="bucket_name=prefect-de-zoomcamp" -var="BQ_DATASET=dezoomcamp" 
```

```shell
# Create new infra: bucket and 
terraform apply -var="bucket_name=prefect-de-zoomcamp" -var="BQ_DATASET=dezoomcamp" 
```

```shell
# Delete infra after your work, to avoid costs on any running services
terraform destroy
```

with main.tf changes
```terraform
resource "google_storage_bucket" "data-lake-bucket" {
  name = local.final_bucket_name_value
  #...
}
```

and variables.tf changes
```terraform
locals {
  data_lake_bucket = "dtc_data_lake"
  bucket_name_value = var.bucket_name != "" ? var.bucket_name : local.data_lake_bucket
  final_bucket_name_value= "${local.bucket_name_value}_${var.project}"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket. Must be globally unique."
  default = ""
}
```

create gcp blocks using **make_gcp_blocks.py** script : 

```python make_gcp_blocks.py ```

## Question 1. Load January 2020 data

Using the `etl_web_to_gcs.py` flow that loads taxi data into GCS as a guide, create a flow that loads the green taxi CSV dataset for January 2020 into GCS and run it. Look at the logs to find out how many rows the dataset has.

How many rows does that dataset have?

* 447,770
* 766,792
* 299,234
* 822,132

#### Answer ####  

run etl_web_to_gcs.py script ( with fixes, since it didn't support passing params )

```bash
 python etl_web_to_gcs.py --color green --year 2020 --month 1 --datetime_columns "lpep_pickup_datetime,lpep_dropoff_datetime"
```
```bash
(data-engineering-zoomcamp) michal@pop-os:~/Projects/data-engineering-zoomcamp/cohorts/2023/week_2_workflow_orchestration/code/flows/02_gcp$  python etl_web_to_gcs.py --color green --year 2020 --month 1 --datetime_columns "lpep_pickup_datetime,lpep_dropoff_datetime"
21:40:26.708 | INFO    | prefect.engine - Created flow run 'airborne-turtle' for flow 'etl-web-to-gcs'
21:40:26.824 | INFO    | Flow run 'airborne-turtle' - Created task run 'fetch-b4598a4a-0' for task 'fetch'
...
21:40:29.737 | INFO    | Task run 'clean-b9fd7e03-0' - rows: 447770

```

#### Answer 1 
**A** 447,770

## Question 2. Scheduling with Cron

Cron is a common scheduling specification for workflows. 

Using the flow in `etl_web_to_gcs.py`, create a deployment to run on the first of every month at 5am UTC. What’s the cron schedule for that?

- `0 5 1 * *`
- `0 0 5 1 *`
- `5 * 1 0 *`
- `* * 5 1 0`

#### Answer ####

use https://crontab.guru/ 
https://crontab.guru/#0_5_1_*_* 

Modified etl_web_to_gcs to take parameters, added etl_parent_flow function
[etl_web_to_gcs.py](code%2Fflows%2F02_gcp%2Fetl_web_to_gcs.py)

```bash
prefect deployment build ./etl_web_to_gcs.py:etl_parent_flow -n "ETL multi-month web to gcs deployment" --cron "0 5 1 * *"

prefect deployment apply etl_parent_flow-deployment.yaml
```

#### Answer 2 
**A** 0 5 1 * *

## Question 3. Loading data to BigQuery 

Using `etl_gcs_to_bq.py` as a starting point, modify the script for extracting data from GCS and loading it into BigQuery. This new script should not fill or remove rows with missing values. (The script is really just doing the E and L parts of ETL).

The main flow should print the total number of rows processed by the script. Set the flow decorator to log the print statement.

Parametrize the entrypoint flow to accept a list of months, a year, and a taxi color. 

Make any other necessary changes to the code for it to function as required.

Create a deployment for this flow to run in a local subprocess with local flow code storage (the defaults).

Make sure you have the parquet data files for Yellow taxi data for Feb. 2019 and March 2019 loaded in GCS. Run your deployment to append this data to your BiqQuery table. How many rows did your flow code process?

- 14,851,920
- 12,282,990
- 27,235,753
- 11,338,483

#### Answer ####  

Modified etl_gcs_to_bq.py to take parameters, added etl_parent_flow function.

[etl_gcs_to_bq.py](code%2Fflows%2F02_gcp%2Fetl_gcs_to_bq.py)

Load the data to gcs for Yellow taxi data for Feb. 2019 and March 2019 loaded in GCS, using etl_parent_flow-deployment.yaml deployment ( from Q2 )
Run it manually from orion . 

Create deployment for etl_gcs_to_bq : 
```bash
prefect deployment build ./etl_gcs_to_bq.py:etl_parent_flow -n "ETL multi-month GCS to BQ deployment" 

prefect deployment apply etl_parent_flow-deployment.yaml
```

Make a custom run for this deployment with  
{ "months": [2, 3] , "year": 2019, "color": "yellow" } parameter.

logs : 
```
Downloading flow code from storage at '/home/michal/Projects/data-engineering-zoomcamp/cohorts/2023/week_2_workflow_orchestration/code/flows/02_gcp'
04:59:24 PM

Created subflow run 'vengeful-turtle' for flow 'etl-gcs-to-bq'
04:59:24 PM

Created subflow run 'warm-grasshopper' for flow 'etl-gcs-to-bq'
05:00:21 PM

:Total rows processed: 14851920
05:01:28 PM

Finished in state Completed('All states completed.')
```

--> **:Total rows processed: 14851920
05:01:28 PM**

#### Answer 3 
**A** 14851920

## Question 4. Github Storage Block

Using the `web_to_gcs` script from the videos as a guide, you want to store your flow code in a GitHub repository for collaboration with your team. Prefect can look in the GitHub repo to find your flow code and read it. Create a GitHub storage block from the UI or in Python code and use that in your Deployment instead of storing your flow code locally or baking your flow code into a Docker image. 

Note that you will have to push your code to GitHub, Prefect will not push it for you.

Run your deployment in a local subprocess (the default if you don’t specify an infrastructure). Use the Green taxi data for the month of November 2020.

How many rows were processed by the script?

- 88,019
- 192,297
- 88,605
- 190,225

#### Answer ####  

Create github block:
```bash
python make_github_blocks.py
```
or

```python
from prefect.filesystems import GitHub

github_block = GitHub(name="github-storage", repository="https://github.com/MichalGasiorowski/data-engineering-zoomcamp")
github_block.save("github-storage", overwrite=True)
```
create deployment ( specify path to flow from main folder in the repository)
```bash
prefect deployment build -n etl_github -sb github/github-storage cohorts/2023/week_2_workflow_orchestration/code/flows/02_gcp/etl_web_to_gcs.py:etl_parent_flow

prefect deployment apply etl_parent_flow-deployment.yaml
```
after that etl-parent-flow / etl_github deployment should be created. 

Run the flow with { "months" = [11], "year": 2020, color: "green", "datetime_columns": "lpep_pickup_datetime,lpep_dropoff_datetime" } 

```
Created task run 'fetch-ba00c645-0' for task 'fetch'
01:49:53 PM
....

columns: VendorID                        float64
lpep_pickup_datetime     datetime64[ns]
lpep_dropoff_datetime    datetime64[ns]
...
congestion_surcharge            float64
dtype: object
01:49:55 PM
clean-2c6af9f6-0

rows: 88605
01:49:55 PM
clean-2c6af9f6-0
....
```

#### Answer 4 
**C** 88605

## Question 5. Email or Slack notifications

Q5. It’s often helpful to be notified when something with your dataflow doesn’t work as planned. Choose one of the options below for creating email or slack notifications.

The hosted Prefect Cloud lets you avoid running your own server and has Automations that allow you to get notifications when certain events occur or don’t occur. 

Create a free forever Prefect Cloud account at app.prefect.cloud and connect your workspace to it following the steps in the UI when you sign up. 

Set up an Automation that will send yourself an email when a flow run completes. Run the deployment used in Q4 for the Green taxi data for April 2019. Check your email to see the notification.

Alternatively, use a Prefect Cloud Automation or a self-hosted Orion server Notification to get notifications in a Slack workspace via an incoming webhook. 

Join my temporary Slack workspace with [this link](https://join.slack.com/t/temp-notify/shared_invite/zt-1odklt4wh-hH~b89HN8MjMrPGEaOlxIw). 400 people can use this link and it expires in 90 days. 

In the Prefect Cloud UI create an [Automation](https://docs.prefect.io/ui/automations) or in the Prefect Orion UI create a [Notification](https://docs.prefect.io/ui/notifications/) to send a Slack message when a flow run enters a Completed state. Here is the Webhook URL to use: https://hooks.slack.com/services/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

Test the functionality.

Alternatively, you can grab the webhook URL from your own Slack workspace and Slack App that you create. 


How many rows were processed by the script?

- `125,268`
- `377,922`
- `728,390`
- `514,392`

#### Answer ####  
1) Go to https://app.prefect.cloud/ and log-in / create account.

2) Create workspace
3) Login into prefect cloud from terminal
```bash
prefect cloud login 
```
4) In prefect cloud Gui create automation for sending email notification when flow completes

5) Create blocks in prefect cloud : 
```bash
python make_gcp_blocks.py
python make_github_blocks.py 
```

6) Create deployment in prefect cloud from cli, the same as in Q4) :
```bash
prefect deployment build -n etl_github -sb github/github-storage cohorts/2023/week_2_workflow_orchestration/code/flows/02_gcp/etl_web_to_gcs.py:etl_parent_flow
prefect deployment apply etl_parent_flow-deployment.yaml

```
7) Run default work queue on prefect cloud: 
```bash
 prefect agent start --work-queue "default" 
```

8) Finally, run the flow for the etl-parent-flow/etl_github deployment : 
```bash
 prefect deployment run etl-parent-flow/etl_github --params '{"months": [4], "year": 2019, "color": "green", "datetime_columns": "lpep_pickup_datetime,lpep_dropoff_datetime" }' 
```

The flow on prefect cloud run ok and logs processed rows:

```bash
Created task run 'fetch-ba00c645-0' for task 'fetch'
02:30:34 PM

Executing 'fetch-ba00c645-0' immediately...
02:30:34 PM

Finished in state Completed()
02:30:38 PM
fetch-ba00c645-0

Created task run 'clean-2c6af9f6-0' for task 'clean'
02:30:39 PM

Executing 'clean-2c6af9f6-0' immediately...
02:30:39 PM

   VendorID lpep_pickup_datetime  ... trip_type congestion_surcharge
0         2  2019-04-01 00:18:40  ...         1                 2.75
1         2  2019-04-01 00:18:24  ...         1                 0.00

[2 rows x 20 columns]
02:30:39 PM
clean-2c6af9f6-0

columns: VendorID                          int64
lpep_pickup_datetime     datetime64[ns]
lpep_dropoff_datetime    datetime64[ns]
store_and_fwd_flag               object
...

rows: 514392
etc...
```
I receive email with message ( + another for the sublow ) :
```
Flow run etl-web-to-gcs/ubiquitous-agama entered state `Completed` at 2023-02-04T13:30:48.644464+00:00.
Flow ID: cd466358-0a6c-4f79-b207-dbd738385073
Flow run ID: 635ba8aa-d4bb-475b-b674-555fea09865e
Flow run URL: https://app.prefect.cloud/account/aada2469-e2bf-4140-b346-731a9060826f/workspace/1b5d1da8-fb55-466a-b4c5-ec57ba7e2b86/flow-runs/flow-run/635ba8aa-d4bb-475b-b674-555fea09865e
State message: All states completed.
```
so the notification indeed works!

#### Answer 5 
**D** 514392


## Question 6. Secrets

Prefect Secret blocks provide secure, encrypted storage in the database and obfuscation in the UI. Create a secret block in the UI that stores a fake 10-digit password to connect to a third-party service. Once you’ve created your block in the UI, how many characters are shown as asterisks (*) on the next page of the UI?

- 5
- 6
- 8
- 10

#### Answer ####  

1) (Optional ) To use local orion server first logout from prefect cloud:
```bash
prefect cloud logout
```
2) Create secret block:
![secret-block-screenshot.png](code%2Fimages%2Fsecret-block-screenshot.png)
next screen, specify block name and password

I used 'hunter2222' ;)

![secret-block-ceated-screenshot.png](code%2Fimages%2Fsecret-block-ceated-screenshot.png)
There are **8** '*' characters shown in this screen.

#### Answer 6 
**C** 8

## Submitting the solutions

* Form for submitting: https://forms.gle/PY8mBEGXJ1RvmTM97
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 6 February (Monday), 22:00 CET


## Solution

We will publish the solution here
