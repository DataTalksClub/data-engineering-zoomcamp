---
video_url: https://www.youtube.com/watch?v=uAlp2VuZZPY
---
# SQL with Spark

In this unit we take the revenue query from week 4 (analytics engineering)
and run it with Spark SQL. We combine the green and yellow taxi data into
one dataset, register it as a temporary table, and execute the revenue
report as a SQL query.

## The data

We use the data prepared in the [previous unit](06-preparing-taxi-data.md).
That unit is optional: if you skipped it, you can just execute the two files
from the Materials section - the download script (for yellow and green,
2020 and 2021) and the schema notebook, which turns the CSV files into
parquet.

You don't have to use parquet. If you want to use the CSV files instead,
make sure you use the explicit schema when reading them, to avoid unpleasant
surprises. With parquet the schema is already built in.

## Combining green and yellow

The query we want to run uses `trips_data` - a combination of yellow and
green taxis. So first we combine the two DataFrames into one.

We read both datasets. Because inside a year we have month folders, we use
`*/*` to go into the subfolders and read 2020 and 2021 at the same time:

```python
df_green = spark.read.parquet('data/pq/green/*/*')
df_yellow = spark.read.parquet('data/pq/yellow/*/*')
```

The two schemas are similar but not the same. Some fields are shared, like
`fare_amount` and `congestion_surcharge`, but green has fields that yellow
doesn't have (like `ehail_fee`) and the other way around. We want to keep
only the columns that both datasets have.

The easiest way to find them is to take the intersection of the two column
sets:

```python
set(df_green.columns) & set(df_yellow.columns)
```

For these datasets, the intersection contains:

```text
{
    'DOLocationID',
    'PULocationID',
    'RatecodeID',
    'VendorID',
    'congestion_surcharge',
    'extra',
    'fare_amount',
    'improvement_surcharge',
    'mta_tax',
    'passenger_count',
    'payment_type',
    'store_and_fwd_flag',
    'tip_amount',
    'tolls_amount',
    'total_amount',
    'trip_distance'
}
```

One problem: the pickup and dropoff time columns are named differently -
`lpep_pickup_datetime` in green and `tpep_pickup_datetime` in yellow. We
rename them (with `withColumnRenamed`) to just `pickup_datetime` and
`dropoff_datetime` in both DataFrames. Then we compute the common columns
again, preserving the order of the green columns:

```python
common_colums = []

yellow_columns = set(df_yellow.columns)

for col in df_green.columns:
    if col in yellow_columns:
        common_colums.append(col)
```

Now we select these columns from both DataFrames, and while we're at it we
add a `service_type` column, so later we know where each record comes from:

```python
from pyspark.sql import functions as F

df_green_sel = df_green \
    .select(common_colums) \
    .withColumn('service_type', F.lit('green'))

df_yellow_sel = df_yellow \
    .select(common_colums) \
    .withColumn('service_type', F.lit('yellow'))

df_trips_data = df_green_sel.unionAll(df_yellow_sel)
```

`F.lit` adds a literal - a constant value - to every record. `unionAll`
puts the two DataFrames together into one. As a sanity check, we can count
the records of each service type:

```python
df_trips_data.groupBy('service_type').count().show()
```

```text
+------------+--------+
|service_type|   count|
+------------+--------+
|       green| 2304517|
|      yellow|39649199|
+------------+--------+
```

Note that `groupBy` alone doesn't trigger any computation - it's a lazy
operation that returns another DataFrame. It's `show()` that actually
executes it.

## From DataFrames to SQL

Now we can use SQL to query this data. Spark has a `sql` method that takes
a query string - but we cannot simply put the name of the DataFrame in the
`FROM` clause. First we need to tell Spark that this DataFrame is a table:

```python
df_trips_data.registerTempTable('trips_data')
```

And now we can run SQL against it:

```python
spark.sql("""
SELECT
    service_type,
    count(1)
FROM
    trips_data
GROUP BY
    service_type
""").show()
```

The result is exactly the same as with the DataFrame API - same numbers,
only the column name is slightly different (`count(1)` instead of `count`).

## The revenue report

Now the query we actually wanted to run. It's the revenue calculation from
week 4: for each pickup location (revenue zone), for each month, and for
each service type, we compute the revenue:

```python
df_result = spark.sql("""
SELECT
    -- Revenue grouping
    PULocationID AS revenue_zone,
    date_trunc('month', pickup_datetime) AS revenue_month,
    service_type,

    -- Revenue calculation
    SUM(fare_amount) AS revenue_monthly_fare,
    SUM(extra) AS revenue_monthly_extra,
    SUM(mta_tax) AS revenue_monthly_mta_tax,
    SUM(tip_amount) AS revenue_monthly_tip_amount,
    SUM(tolls_amount) AS revenue_monthly_tolls_amount,
    SUM(improvement_surcharge) AS revenue_monthly_improvement_surcharge,
    SUM(total_amount) AS revenue_monthly_total_amount,
    SUM(congestion_surcharge) AS revenue_monthly_congestion_surcharge,

    -- Additional calculations
    AVG(passenger_count) AS avg_monthly_passenger_count,
    AVG(trip_distance) AS avg_monthly_trip_distance
FROM
    trips_data
GROUP BY
    1, 2, 3
""")
```

Because we loaded the data for two years at once, this computes the
statistics for every month at the same time. Finally we save the result:

```python
df_result.write.parquet('data/report/revenue/', mode='overwrite')
```

While it executes we can look at the Spark master UI: there are 215 tasks
running, and the job combines the two inputs - the yellow taxi DataFrame
and the green taxi DataFrame - then does the grouping and writes the result
to parquet.

## One file instead of 200

If we look at `data/report/revenue` after the job finishes, we get quite a
lot of files - around 200, each only a few kilobytes. It's convenient to
reduce the number of files, and for that we use `coalesce`. It's the same
as repartition, but we use it when we want to reduce the number of
partitions - here to exactly one:

```python
df_result.coalesce(1).write.parquet('data/report/revenue/', mode='overwrite')
```

Because the path already exists, we need `mode='overwrite'`. This took
about 26 seconds, and afterwards we have one file of around 500 KB with all
the revenue data - for each month, for each taxi type, for each location.

Note what happened here: we wrote the results back to what we pretend is a
data lake - it's still a bunch of files. We didn't write anything to a data
warehouse. With Spark we can operate completely on a data lake.

I said before that if you can use SQL, maybe you don't need Spark - tools
like Hive or Presto might do. But you don't always have those tools, and if
you already have a Spark cluster, why not use it for executing SQL queries?
On top of that you get the DataFrame API for the things that are easier to
express in code.

## Materials

* [`code/06_spark_sql.ipynb`](code/06_spark_sql.ipynb) - unioning green and
  yellow into one `trips_data` temp table and running the revenue report as SQL.
* [`code/06_spark_sql.py`](code/06_spark_sql.py) - the same report as a
  parameterised script, which the cloud units later submit to a cluster.
