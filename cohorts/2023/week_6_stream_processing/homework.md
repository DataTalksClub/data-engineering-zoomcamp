## Week 6 Homework 

In this homework, there will be two sections, the first session focus on theoretical questions related to Kafka 
and streaming concepts and the second session asks to create a small streaming application using preferred 
programming language (Python or Java).

### Question 1: 

**Please select the statements that are correct**

- Kafka Node is responsible to store topics [x]
- Zookeeper is removed from Kafka cluster starting from version 4.0 [x]
- Retention configuration ensures the messages not get lost over specific period of time. [x]
- Group-Id ensures the messages are distributed to associated consumers [x]


### Question 2: 

**Please select the Kafka concepts that support reliability and availability**

- Topic Replication [x]
- Topic Partioning
- Consumer Group Id
- Ack All [x]



### Question 3: 

**Please select the Kafka concepts that support scaling**  

- Topic Replication
- Topic Paritioning [x]
- Consumer Group Id [x]
- Ack All


### Question 4: 

**Please select the attributes that are good candidates for partitioning key. 
Consider cardinality of the field you have selected and scaling aspects of your application**  

- payment_type [x]
- vendor_id [x]
- passenger_count
- total_amount
- tpep_pickup_datetime
- tpep_dropoff_datetime


### Question 5: 

**Which configurations below should be provided for Kafka Consumer but not needed for Kafka Producer**

- Deserializer Configuration [x]
- Topics Subscription [x]
- Bootstrap Server 
- Group-Id [x]
- Offset [x]
- Cluster Key and Cluster-Secret


### Question 6:

Please implement a streaming application, for finding out popularity of PUlocationID across green and fhv trip datasets.
Please use the datasets [fhv_tripdata_2019-01.csv.gz](https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv) 
and [green_tripdata_2019-01.csv.gz](https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/green)

PS: If you encounter memory related issue, you can use the smaller portion of these two datasets as well, 
it is not necessary to find exact number in the  question.

Your code should include following
1. Producer that reads csv files and publish rides in corresponding kafka topics (such as rides_green, rides_fhv)
2. Pyspark-streaming-application that reads two kafka topics
   and writes both of them in topic rides_all and apply aggregations to find most popular pickup location.

   
## Submitting the solutions

* Form for submitting: https://forms.gle/rK7268U92mHJBpmW7
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 13 March (Monday), 22:00 CET


## Solution

We will publish the solution here after deadline#

For Question 6 ensure, 

1) Download fhv_tripdata_2019-01.csv and green_tripdata_2019-01.csv under resources/fhv_tripdata 
and resources/green_tripdata resprctively. ps: You need to unzip the compressed files

2) Update the client.properties settings using your Confluent Cloud api keys and cluster. 
3) And create the topics(all_rides, fhv_taxi_rides, green_taxi_rides) in Confluent Cloud UI

4) Run Producers for two datasets
```
python3 producer_confluent --type green
python3 producer_confluent --type fhv
```

5) Run pyspark streaming
```
./spark-submit.sh streaming_confluent.py
```


