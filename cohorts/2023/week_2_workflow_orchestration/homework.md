## Week 2 Homework

The goal of this homework is to familiarize users with workflow orchestration and observation using AWS and Apache Airflow. 


## Question 1. Load January 2020 data

Create a DAG that loads the green taxi CSV dataset for January 2020 into S3 and run it. Look at the logs to find out how many rows the dataset has. (refer this [video](https://youtu.be/W-rMz_2GwqQ?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&t=234))

How many rows does that dataset have?

* 447,770
* 766,792
* 299,234
* 822,132


## Question 2. Scheduling with Cron

Cron is a common scheduling specification for workflows. 

Using the DAG in the Airflow, set the `schedule_interval` to run on the first of every month at 5am UTC. What’s the cron schedule for that? (refer this  [video](https://youtu.be/W-rMz_2GwqQ?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&t=234))

- `0 5 1 * *`
- `0 0 5 1 *`
- `5 * 1 0 *`
- `* * 5 1 0`


## Question 3. Loading data to Amazon Redshift

Using the DAG that extracts data from S3 and loads it into Amazon Redshift. This new script should not fill or remove rows with missing values. (The script is really just doing the E and L parts of ETL). Refer [here](https://youtu.be/Cx5jt-V5sgE?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&t=53)


The main task should print the total number of rows processed by the script. Use the task logging to capture the print statement.

Parametrize the entrypoint tasks to accept a list of months, a year, and a taxi color.

Make any other necessary changes to the code for it to function as required.

Create a DAG for this and run it using the Airflow executor and DAG folder

Make sure you have the CSV or parquet files (explain your decision) for Yellow taxi data for Feb. 2019 and March 2019 loaded in S3. Run your DAG to append this data to your Redshift table. How many rows did your DAG process?

- 14,851,920
- 12,282,990
- 27,235,753
- 11,338,483



## Question 4. Version control with Git

You want to store your DAG code in a GitHub repository for collaboration with your team. Push your code to GitHub.

Once you have pushed your code to GitHub, update the Airflow scheduler to read the DAGs from the GitHub repository instead of the local filesystem.


Run your DAG in Airflow with the Green taxi data for the month of November 2020.

How many rows were processed by the script?

- 88,019
- 192,297
- 88,605
- 190,225



## Question 5. Email or Slack notifications

Q5. It’s often helpful to be notified when something with your dataflow doesn’t work as planned. Choose one of the options below for creating email or slack notifications.

It’s often helpful to be notified when something with your dataflow doesn’t work as planned. Airflow allows you to send email notifications when certain events occur or don’t occur.

Update your DAG to send an email notification to yourself when a task fails.


Run the DAG used in Q4 for the Green taxi data for April 2019. Make sure you receive an email notification if any of the tasks fail.
Test the functionality.

Alternatively, you can grab the webhook URL from your own Slack workspace and Slack App that you create. 


How many rows were processed by the script?

- `125,268`
- `377,922`
- `728,390`
- `514,392`


## Question 6. Secrets

Airflow Connections and Variables can be used to securely store sensitive information like credentials.

Create an Airflow Connection in the UI that stores a fake 10-digit password to connect to a third-party service.
Once you’ve created your Connection in the UI, how many characters are shown as asterisks (*) on the next page of the UI?
- 5
- 6
- 8
- 10


## Submitting the solutions

* Form for submitting: https://forms.gle/PY8mBEGXJ1RvmTM97
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 8 February (Wednesday), 22:00 CET


## Solution

* Video: https://youtu.be/L04lvYqNlc0
* Code: https://github.com/discdiver/prefect-zoomcamp/tree/main/flows/04_homework
