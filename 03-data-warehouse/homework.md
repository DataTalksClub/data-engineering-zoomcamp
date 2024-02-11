## Week 3 Homework
ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. This repository should contain your code for solving the homework. If your solution includes code that is not in file format (such as SQL queries or shell commands), please include these directly in the README file of your repository.

<b><u>Important Note:</b></u> <p> For this homework we will be using the 2022 Green Taxi Trip Record Parquet Files from the New York
City Taxi Data found here: </br> https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page </br>
If you are using orchestration such as Mage, Airflow or Prefect do not load the data into Big Query using the orchestrator.</br> 
Stop with loading the files into a bucket. </br></br>
<u>NOTE:</u> You will need to use the PARQUET option files when creating an External Table</br>

<b>SETUP:</b></br>
Create an external table using the Green Taxi Trip Records Data for 2022. </br>
Create a table in BQ using the Green Taxi Trip Records for 2022 (do not partition or cluster this table). </br>
</p>

```python
import io
import os
import requests
import pandas as pd

"""
Pre-reqs:
1. `pip install pandas pyarrow`
"""

init_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
init_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'

def download_parquet_locally(year, service, target_folder):
    """
    Downloads Parquet files from the specified URL and stores them in a local folder.

    Args:
        year (str): The year of the data to download.
        service (str): The type of taxi service (e.g., "green", "yellow").
        target_folder (str): The folder path where to store the downloaded files.
    """

    for i in range(12):
        # Construct parquet file name
        month = str(i+1).zfill(2)  # Zero-pad month for consistent naming
        parquet_file_name = f"{service}_tripdata_{year}-{month}.parquet"

        # Create target folder if it doesn't exist
        os.makedirs(target_folder, exist_ok=True)  # Ensures folders are created recursively

        # Build absolute file path
        full_file_path = os.path.join(init_url, parquet_file_name)

        # Download parquet file (if necessary)
        if not os.path.exists(full_file_path):
            os.system(f"wget {full_file_path} -O {parquet_file_name}")
            print(f"Downloaded Parquet: {full_file_path}")

        print(f"Local Parquet: {full_file_path}")  # Indicate local storage

# Example usage:

# Ejecuta el script con el argumento `--target_folder`

target_folder = "./parquet/"  # Replace with your desired folder path
download_parquet_locally('2022', 'green', target_folder)
```

```sql
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `mythical-geode-413902.nytaxigreen.external_green_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://nyc-tl-data-marlon/green_trip_data/green_tripdata_2022-*.parquet']
);

```


## Question 1:
Question 1: What is count of records for the 2022 Green Taxi Data??
- 65,623,481
- 840,402
- 1,936,423
- 253,647

***- 840,402***
```sql
--- Quantity of records
SELECT COUNT(*) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`
--- Results 840402
```

## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- 0 MB for the External Table and 6.41MB for the Materialized Table
- 18.82 MB for the External Table and 47.60 MB for the Materialized Table
- 0 MB for the External Table and 0MB for the Materialized Table
- 2.14 MB for the External Table and 0MB for the Materialized Table

***- 0 MB for the External Table and 6.41MB for the Materialized Table***

```sql
SELECT COUNT(DISTINCT(PULocationID)) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`; --0B
SELECT COUNT(DISTINCT(PULocationID)) FROM `mythical-geode-413902.nytaxigreen.materialized_green_tripdata` --6.41MB
```

## Question 3:
How many records have a fare_amount of 0?
- 12,488
- 128,219
- 112
- 1,622

***- 1,622***


```sql
SELECT COUNT(*) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata` WHERE fare_amount=0 ; --0B

```


## Question 4:
What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)
- Cluster on lpep_pickup_datetime Partition by PUlocationID
- Partition by lpep_pickup_datetime  Cluster on PUlocationID
- Partition by lpep_pickup_datetime and Partition by PUlocationID
- Cluster on by lpep_pickup_datetime and Cluster on PUlocationID

***- Partition by lpep_pickup_datetime  Cluster on PUlocationID***

```sql
CREATE OR REPLACE TABLE mythical-geode-413902.nytaxigreen.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`;

```

## Question 5:
Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime
06/01/2022 and 06/30/2022 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 

- 22.82 MB for non-partitioned table and 647.87 MB for the partitioned table
- 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table
- 5.63 MB for non-partitioned table and 0 MB for the partitioned table
- 10.31 MB for non-partitioned table and 10.31 MB for the partitioned table

***-12.82 MB for non-partitioned table and 1.12 MB for the partitioned table ***

```sql
SELECT DISTINCT(PULocationID) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`
WHERE DATE(lpep_pickup_datetime) >='2022-06-01' AND DATE(lpep_pickup_datetime)<='2022-06-30'; --4.414 MB

SELECT DISTINCT(PULocationID) FROM `mythical-geode-413902.nytaxigreen.green_tripdata_partitoned_clustered`
WHERE DATE(lpep_pickup_datetime) >='2022-06-01' AND DATE(lpep_pickup_datetime)<='2022-06-30';  --1.12 MB

```

## Question 6: 
Where is the data stored in the External Table you created?

- Big Query
- GCP Bucket
- Big Table
- Container Registry

***- GCP Bucket***

## Question 7:
It is best practice in Big Query to always cluster your data:
- True
- False

***- False***

## (Bonus: Not worth points) Question 8:
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

 
## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw3





```sql 
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `mythical-geode-413902.nytaxigreen.external_green_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://nyc-tl-data-marlon/green_trip_data/green_tripdata_2022-*.parquet']
);


--- Quantity of records
SELECT COUNT(*) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`;
--- Results 840402

--- Materialized table 
CREATE TABLE `mythical-geode-413902.nytaxigreen.external_green_tripdata2`   FROM `gs://nyc-tl-data-marlon/green_trip_data/green_tripdata_2022-*.parquet`
  WITH SCHEMA=AUTODETECT,
  FORMAT PARQUET;


CREATE OR REPLACE  TABLE `mythical-geode-413902.nytaxigreen.external_green_tripdata2`
OPTIONS (
  format = 'parquet',
  uris = ['gs://nyc-tl-data-marlon/green_trip_data/green_tripdata_2022-*.parquet']
);



--Question 2:
--Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
--What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

SELECT COUNT(DISTINCT(PULocationID)) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`; --0B
SELECT COUNT(DISTINCT(PULocationID)) FROM `mythical-geode-413902.nytaxigreen.materialized_green_tripdata` --6.41MB


--## Question 3:
--How many records have a fare_amount of 0?
SELECT COUNT(*) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata` WHERE fare_amount=0 ; --0B


--Question 4:
--What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)
CREATE OR REPLACE TABLE mythical-geode-413902.nytaxigreen.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`;


--Question 5:
--Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
--Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values?


SELECT DISTINCT(PULocationID) FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`
WHERE DATE(lpep_pickup_datetime) >='2022-06-01' AND DATE(lpep_pickup_datetime)<='2022-06-30'; --4.414 MB

SELECT DISTINCT(PULocationID) FROM `mythical-geode-413902.nytaxigreen.green_tripdata_partitoned_clustered`
WHERE DATE(lpep_pickup_datetime) >='2022-06-01' AND DATE(lpep_pickup_datetime)<='2022-06-30';  --1.12 MB


--(Bonus: Not worth points) Question 8:
--No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

SELECT COUNT(*) query FROM `mythical-geode-413902.nytaxigreen.materialized_green_tripdata`;

SELECT COUNT(*) query FROM `mythical-geode-413902.nytaxigreen.external_green_tripdata`;



```