# Week 6 Homework 

## Overview

In this homework, we're going to extend homework-05 by streaming and doing some real-time analysis with PySpark. Ensure you have the following set up (if you had done module-05 & homework-05, you're covered):

- Docker Engine 
- The pyspark `wget [pyspark.tgz from module-05 setup]` download link and your `pyspark --version`
- A docker network called `kafka-spark-network`. You can create the network below, if not yet created.
- A docker volume called `hadoop-distributed-file-system`. You can create the volume below, if not yet created.

For this homework we will be using the files
- from homework-05, FHV 2019-10 data found here: [FHV Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-10.csv.gz), and
- Green 2019-10 data found here: [Green Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz)



## Pre-setup

1. Extract and place the csv files in the paths under `resources` subfolder, as stated in [settings.py](settings.py)
2. If you encounter memory related issue, you can use a smaller portion by piping to a smaller-sized file just as we did in previous lesson, to test the code. Use the full file for answering questions.

```bash
head -n 1000 fhv_tripdata_2019-10.csv > fhv_rides.csv
```
3. Verify the network and volume still exists.

```bash
docker volume ls # should list hadoop-distributed-file-system
docker network ls # should list kafka-spark-network 
```

If not, create them first.
```bash
# Create Network
docker network create kafka-spark-network

# Create Volume
docker volume create --name=hadoop-distributed-file-system
```

TODO list the files to edit.
3. Go through the files [file-1] [file-2], for the spark versions. Edit to match the version you have installed from module-05

> [!IMPORTANT]
> change `spark-sql-kafka-0-10_2.12:[your-spark-version]`
>
> The files are using pyspark version 3.5.1, so they are showing `spark-sql-kafka-0-10_2.12:3.5.1`

## Spin up the containers.

Stand up the containers
```bash
docker compose up -d
```

Set rpk alias: 
```bash
alias rpk="docker exec -it redpanda-1 rpk"
```

### Question 1

Run following code to start. What is the `rpk` console version?

```bash
rpk --version
```

## Running Producer

```bash
# Run Producers for the two datasets
python producer.py --type fhv
python producer.py --type green
```

### Running Streaming Script

spark-submit script ensures installation of necessary jars before running the streaming.py

```bash
./spark-submit.sh streaming.py 
```

### Question 2

**What is the most popular pickup location for FHV type taxi rides?**

- 1
- 2
- 3
- 4

## Running Consumer

```bash
# Run consumer with default settings
python3 consumer.py
# Run consumer for specific topic
python3 consumer.py --topic [topic-name]
```

### Question 4:
most popular PUlocationID for fhv trip taxis



### Question 5:
least popular DOlocationID for fhv trip taxis


<!-- Not sure about these questions after this point, I might be able to do in with the 1.5 weeks but not right now with just these few days. -->

## Question 

```bash
rpk cluster info
rpk topic list --detailed
```

Create topic `rides_all` using the `rpk` CLI command in the terminal.

Which of these is the correct command to create topic with 1 partitions and 1 replica?

- `rpk topics creates rides_all --partitions 12 --replicas 1`
- `rpk topic rides_all --partitions 1 --replicas 1`
- `rpk topic create list rides_all --partitions 1 --replicas 1`
- `rpk topic create rides_all --partitions 1 --replicas 1`

Run the correct command in the terminal to create the topic.


### Question :
most common locationID where a taxi can drop off and pickup a passenger at the same location within a 10min threshold (windowing lesson).

<!-- scrap the above questions? -->

## Submitting the solutions

* Form for submitting: TBA
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: TBA


## Solution

We will publish the solution here after deadline.

For Question 6 ensure, 

1. Download the 2 datafiles and place them in `resources` folder<br>
  *ps: You need to unzip the compressed files*<br><br>
1. set alias for `rpk`:
```bash
alias rpk="docker exec -ti redpanda-1 rpk"
``` 

1. And create the topics (`all_rides`, `fhv_taxi_rides`, `green_taxi_rides`) in Redpanda Console UI or with `rpk` CLI command<br><br>
2. Run Producers for two datasets
```
python producer.py --type green
python producer.py --type fhv
```

1. Run pyspark streaming

```
./spark-submit.sh streaming.py
```


