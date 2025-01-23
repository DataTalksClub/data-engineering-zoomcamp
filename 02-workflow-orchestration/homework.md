### Quiz Questions

Complete the Quiz shown below. It’s a set of 6 multiple-choice questions to test your understanding of workflow orchestration, Kestra and ETL pipelines for data lakes and warehouses.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- ***128.3 MB X***
- 134.5 MB 
- 364.7 MB
- 692.6 MB

2) What is the value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- ***`green_tripdata_2020-04.csv` X***
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

3) How many rows are there for the `Yellow` Taxi data for the year 2020?
``` SQL
SELECT count(1) FROM `de-zoo.zoomcamp.yellow_tripdata` WHERE filename LIKE "%2020%";
```
- 13,537.299
- ***24,648,499 X***
- 18,324,219
- 29,430,127

4) How many rows are there for the `Green` Taxi data for the year 2020?
``` SQL
SELECT count(1) FROM `de-zoo.zoomcamp.green_tripdata` WHERE filename LIKE "%2020%";
```
- 5,327,301
- 936,199
- ***1,734,051 X***
- 1,342,034

5) How many rows are there for the `Yellow` Taxi data for March 2021?
``` SQL
SELECT COUNT(1) FROM `de-zoo.zoomcamp.yellow_tripdata` WHERE filename LIKE "%2021-03%";
```
- 1,428,092
- 706,911
- ***1,925,152 X***
- 2,561,031

6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- ***Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration X***
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  