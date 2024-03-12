## Module 6 Homework 

In this homework, we're going to extend Module 5 Homework and learn about streaming with PySpark.

Ensure you have the following set up (if you had done the previous homework and the module):

- Docker 
- PySpark

For this homework we will be using the files from Module 5 Homework,

-  FHV 2019-10 data found here: [FHV Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-10.csv.gz), and
- Green 2019-10 data found here: [Green Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz)



## Pre-setup

1. Extract and place the csv files in the `data` folder


## Spin up the containers



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


## Solution

We will publish the solution here after deadline.


