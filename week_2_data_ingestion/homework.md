## Week 2 Homework

In this homework, we'll prepare data for the next week. We'll need
to put the NY Taxi data from 2019 and 2020 to our data lake.

For the lessons, we'll need the Yellow taxi dataset. For the homework 
of week 3, we'll need FHV Data (for-hire vehicles).

You can find all the URLs on [the dataset page](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

In this homework, we will:

* Modify the DAG we created during the lessons for trasnferring the yellow taxi data
* Create a new dag for transferring the FHV data
* Create another dag for the Zones data


## Question 1: Start date for the Yellow taxi data

You'll need to parametrize the DAG we created in the videos. 

What should be the start date for this dag?

* 2019-01-01
* 2020-01-01
* 2021-01-01
* days_ago(1)


## Question 2: Frequency

How often do we need to run it?

* Daily
* Monthly
* Yearly
* Once


## Question 3: DAG for FHV Data

Now create another DAG - for uploading the FHV data. 

We will need three steps: 

* Donwload the data
* Parquetize it 
* Upload to GSC


Use the same frequency and the start date as for the green taxi dataset

Question: TBA


## Question 4: DAG for Zones


Create the final DAG - for Zones:

* Download it
* Parquetize 
* Upload to GCS

How often does it need to run?

* Daily
* Monthly
* Yearly
* Once


## Submitting the solutions

* Form for submitting: TBA
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: TBA

