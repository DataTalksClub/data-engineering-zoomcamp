## Week 3 Homework
<b><u>Important Note:</b></u> <p>You can load the data however you would like, but keep the files in .GZ Format. 
If you are using orchestration such as Airflow or Prefect do not load the data into Big Query using the orchestrator.</br> 
Stop with loading the files into a bucket. </br></br>
<u>NOTE:</u> You can use the CSV option for the GZ files when creating an External Table</br>

<b>SETUP:</b></br>
Create an external table using the fhv 2019 data. </br>
Create a table in BQ using the fhv 2019 data (do not partition or cluster this table). </br>
Data can be found here: https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv </p>

Use tarraform from week1 to load data to GCS: 

```bash
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

Then, using 
[etl_web_to_gcs.py](..%2Fweek_2_workflow_orchestration%2Fcode%2Fflows%2F02_gcp%2Fetl_web_to_gcs.py) from week2, load 

The script was changed to pass more parameters : 
1) base_url ( since fhv data is downloaded from other place than before )
2) encoding ( encoding for 2020-02 file is 'latin1' which caused problems with ```pd.read_csv()``` )
3) months to accepts '*' as value - to fetch all the months in a year 
4) changed datetime_columns to list[str] instead of cumbersome "col1,col2,..." and splitting it by hand

Build the deployment, apply.
```bash
prefect deployment build ./etl_web_to_gcs.py:etl_parent_flow -n "ETL multi-month web to gcs deployment" 

prefect deployment apply etl_parent_flow-deployment.yaml
```

Run the deployment flows:
```bash
 prefect deployment run "etl-parent-flow/ETL multi-month web to gcs deployment" --params '{
  "months": "*",
  "encoding": "latin1",
  "year": 2019,
  "color": "fhv",
  "datetime_columns": [],
  "base_url": "https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv",
  "output_format": "csv"
}'

 prefect deployment run "etl-parent-flow/ETL multi-month web to gcs deployment" --params '{
  "months": "*",
  "encoding": "latin1",
  "year": 2020,
  "color": "fhv",
  "datetime_columns": [],
  "base_url": "https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv",
  "output_format": "csv"
}'

```

Create external table in BigQuery using 2019 fhv data saved in my gcs bucket:
```bigquery
-- Creating external table referring to gcs path

CREATE OR REPLACE EXTERNAL TABLE `magnetic-energy-375219.dezoomcamp.external_fhv_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://prefect-de-zoomcamp_magnetic-energy-375219/data/fhv/fhv_tripdata_2019-*.csv']
);
```

Create table in BigQuery using 2019 fhv data saved in my gcs bucket:
```bigquery
CREATE OR REPLACE TABLE dezoomcamp.fhv_tripdata
AS SELECT * FROM dezoomcamp.external_fhv_tripdata;


```

we use csv format since it enables BigQuery to infer column types.

## Question 1:
What is the count for fhv vehicle records for year 2019?
- 65,623,481
- 43,244,696
- 22,978,333
- 13,942,414

#### Answer ####  

```bigquery
SELECT COUNT(*) FROM `magnetic-energy-375219.dezoomcamp.fhv_tripdata`;
```
Query results:
43244696

#### Answer 1 
**B** 43,244,696


## Question 2:
Write a query to count the distinct number of affiliated_base_number for the entire dataset on both the tables.</br> 
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- 25.2 MB for the External Table and 100.87MB for the BQ Table
- 225.82 MB for the External Table and 47.60MB for the BQ Table
- 0 MB for the External Table and 0MB for the BQ Table
- 0 MB for the External Table and 317.94MB for the BQ Table 

#### Answer ####  
```bigquery
SELECT COUNT(distinct Affiliated_base_number) FROM `dezoomcamp.fhv_tripdata`;
```
has info : 
"This query will process 317.94 MB when run."

```bigquery
SELECT COUNT(distinct Affiliated_base_number) FROM magnetic-energy-375219.dezoomcamp.external_fhv_tripdata;
```
has info:
"This query will process 0 B when run." 

both return the same reuslt : 3163

#### Answer 2 
**D** 0 MB for the External Table and 317.94MB for the BQ Table

## Question 3:
How many records have both a blank (null) PUlocationID and DOlocationID in the entire dataset?
- 717,748
- 1,215,687
- 5
- 20,332

#### Answer ####  

```bigquery
SELECT COUNT(*) FROM `dezoomcamp.fhv_tripdata`
WHERE 
      PUlocationID is null 
  AND DOlocationID is null
  ;
```
returns: 717748

#### Answer 3 
**A** 717,748

## Question 4:
What is the best strategy to optimize the table if query always filter by pickup_datetime and order by affiliated_base_number?
- Cluster on pickup_datetime Cluster on affiliated_base_number
- Partition by pickup_datetime Cluster on affiliated_base_number
- Partition by pickup_datetime Partition by affiliated_base_number
- Partition by affiliated_base_number Cluster on pickup_datetime

#### Answer ####  

It's best to partition on column on which filtering always would be done - **pickup_datetime.**
Clustering will help with order by clause -> **affiliated_base_number**

#### Answer 4 
**B** Partition by pickup_datetime Cluster on affiliated_base_number


## Question 5:
Implement the optimized solution you chose for question 4. Write a query to retrieve the distinct affiliated_base_number between pickup_datetime 03/01/2019 and 03/31/2019 (inclusive).</br> 
Use the BQ table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values? Choose the answer which most closely matches.
- 12.82 MB for non-partitioned table and 647.87 MB for the partitioned table
- 647.87 MB for non-partitioned table and 23.06 MB for the partitioned table
- 582.63 MB for non-partitioned table and 0 MB for the partitioned table
- 646.25 MB for non-partitioned table and 646.25 MB for the partitioned table

#### Answer ####
Create partitioned and clustered table:
```bigquery
CREATE OR REPLACE TABLE dezoomcamp.fhv_tripdata_partitoned_clustered
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM dezoomcamp.fhv_tripdata;
```

Both queries are the same:
```bigquery
SELECT COUNT(distinct Affiliated_base_number) FROM `dezoomcamp.fhv_tripdata_partitoned_clustered`
WHERE pickup_datetime >= TIMESTAMP('2019-03-01')
AND   pickup_datetime <= TIMESTAMP('2019-03-31'); 

SELECT COUNT(distinct Affiliated_base_number) FROM `dezoomcamp.fhv_tripdata`
WHERE pickup_datetime >= TIMESTAMP('2019-03-01')
AND   pickup_datetime <= TIMESTAMP('2019-03-31');
```
which returns 722.

The estimate for query on partitioned_and_clustered table:

This query will process **23.05 MB** when run.

The estimate for query on normal table:

This query will process **647.87 MB** when run.

The query on fhv_tripdata_partitoned_clustered table uses partitioned column when filtering and BigQuery engine knows it 
before running the query, so the estimate is accurate.

When run:
fhv_tripdata :                      Bytes processed  647.87 MB
fhv_tripdata_partitoned_clustered : Bytes processed 23.05 MB

#### Answer 5 
**B** 647.87 MB for non-partitioned table and 23.06 MB for the partitioned table


## Question 6: 
Where is the data stored in the External Table you created?

- Big Query
- GCP Bucket
- Container Registry
- Big Table

#### Answer ####
The data is not stored in BigTable, BigQuery etc. The data remain in the same place for External Table: 
 ```text
 External Data Configuration

Source URI(s)
    gs://prefect-de-zoomcamp_magnetic-energy-375219/data/fhv/fhv_tripdata_2019-*.csv
```

#### Answer 6 
**B** - GCP Bucket

## Question 7:
It is best practice in Big Query to always cluster your data:
- True
- False

#### Answer ####

No - the easy case when it's not true is if new data is constantly added to the data and results in automatic reclustering which 
can cause performance degradation.
Too many clustering columns can result in performance degradation.  

#### Answer 7 
**B** False

## (Not required) Question 8:
A better format to store these files may be parquet. Create a data pipeline to download the gzip files and convert them into parquet. Upload the files to your GCP Bucket and create an External and BQ Table. 


Note: Column types for all files used in an External Table must have the same datatype. While an External Table may be created and shown in the side panel in Big Query, this will need to be validated by running a count query on the External Table to check if any errors occur. 
 
## Submitting the solutions

* Form for submitting: https://forms.gle/rLdvQW2igsAT73HTA
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 13 February (Monday), 22:00 CET


## Solution

We will publish the solution here
