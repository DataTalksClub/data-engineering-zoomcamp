## Week 5 Homework 

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the FHV 2019-10 data found here. [FHV Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-10.csv.gz)

### Question 1: 

**Install Spark and PySpark** 

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?
- 8.3.2
- 3.5.0
- 1.3.2
- 5.4.6



### Question 2: 

**FHV October 2019**

Read the October 2019 FHV into a Spark Dataframe with a schema as we did in the lessons.</br> 
Repartition the Dataframe to 6 partitions and save it to parquet.</br>
What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.</br>

- 1MB
- 6MB
- 25MB
- 87MB



### Question 3: 

**Count records** 

How many taxi trips were there on the 15th of October?</br></br>
Consider only trips that started on the 15th of October.</br>

- 108,164
- 12,856
- 452,470
- 62,610



### Question 4: 

**Longest trip for each day** 

What is the length of the longest trip in the dataset in hours?</br>

- 631,152.50 Hours
- 243.44 Hours
- 7.68 Hours
- 3.32 Hours



### Question 5: 

**User Interface**

Spark’s User Interface which shows the application's dashboard runs on which local port?</br>

- 80
- 443
- 4040
- 8080



### Question 6: 

**Least frequent pickup location zone**

Load the zone lookup data into a temp view in Spark</br>
[Zone Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv)</br>

Using the zone lookup data and the FHV October 2019 data, what is the name of the LEAST frequent pickup location Zone?</br>

- East Chelsea
- Jamaica Bay
- Union Sq
- Crown Heights North


## Submitting the solutions

- Form for submitting: TBA
- Deadline: See the course app
