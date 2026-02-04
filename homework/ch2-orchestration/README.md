# Homework 2 - Orchestration

In this part I finished Module 2 on Orchestration using Kestra. I processed data from Yellow and Green data trips from NYC Taxi Dataset from 2019 until 2020, then extend it to 2021 for homework. This notebook is my answer on homework module 2.

### Quiz Questions

Complete the quiz shown below. It's a set of 6 multiple-choice questions to test your understanding of workflow orchestration, Kestra, and ETL pipelines.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

Answer: 134.5 MB
See picture below

2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv`
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

Answer: the rendered value is `green_tripdata_2020-04.csv`

3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- 13,537.299
- 24,648,499
- 18,324,219
- 29,430,127

Answer: `Yellow` Taxi in the CSV file in 2020 has 24,648,499 rows.
Query:
```
SELECT COUNT(*) FROM `dtc-de-course-486306.zoomcamp.yellow_tripdata` 
WHERE tpep_pickup_datetime BETWEEN "2020-01-01" AND "2020-12-31"
LIMIT 1000
```
4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- 5,327,301
- 936,199
- 1,734,051
- 1,342,034

Answer: `Green` Taxi in the CSV file in 2020 has 1,734,051 rows.
I use this query:
```
SELECT COUNT(*) FROM `dtc-de-course-486306.zoomcamp.green_tripdata` 
WHERE lpep_pickup_datetime BETWEEN "2020-01-01" AND "2020-12-31"
LIMIT 1000
```

5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

Answer: `Yellow` Taxi in the CSV file in 2021 in March has 1,925,152 rows.
Query
```
SELECT COUNT(*) FROM `dtc-de-course-486306.zoomcamp.yellow_tripdata_2021_03` 
```

6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration

Answer: Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
