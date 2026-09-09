---
video_url: https://www.youtube.com/watch?v=ti3aC1m3rE8
---
# Spark DataFrames

In this unit we talk more about Spark DataFrames - the `df` things we
already used. They look similar to pandas DataFrames, but not quite:
we see how they differ, and what actions and transformations are.

## Reading parquet

Let's read the parquet files we created in the previous video:

```python
df = spark.read.parquet('fhvhv/2021/01/')
```

We don't specify the schema here, because parquet files contain the
schema information - the types for each column: strings, timestamps,
integers. Instead of looking at `df.schema`, there is a nicer way:

```python
df.printSchema()
```

The schema stored in parquet is:

```text
root
 |-- hvfhs_license_num: string (nullable = true)
 |-- dispatching_base_num: string (nullable = true)
 |-- pickup_datetime: timestamp (nullable = true)
 |-- dropoff_datetime: timestamp (nullable = true)
 |-- PULocationID: integer (nullable = true)
 |-- DOLocationID: integer (nullable = true)
 |-- SR_Flag: string (nullable = true)
```

This is also one of the reasons parquet files are smaller: they know
the schema and use more efficient ways of compressing the data. For
example, an integer takes 4 bytes, instead of the multiple bytes a
plain-text CSV value needs.

## Selecting and filtering

We can do the usual stuff we do with pandas. To keep only a few
columns, use `select`:

```python
df.select('pickup_datetime', 'dropoff_datetime',
          'PULocationID', 'DOLocationID')
```

The result is a DataFrame with these four columns:

```text
DataFrame[pickup_datetime: timestamp, dropoff_datetime: timestamp,
          PULocationID: int, DOLocationID: int]
```

This DataFrame now contains only these four columns. We can also
filter rows:

```python
df.filter(df.hvfhs_license_num == 'HV0003')
```

Run this, and... nothing happens. The Spark UI shows no new job. The
reason is that these commands are lazy, like `repartition` in the
previous unit. Only when we add `.show()` does Spark actually execute
something - then a job appears in the UI.

## Actions vs transformations

Spark distinguishes between things that are executed right away and
things that are not. The lazy ones are called transformations: they
transform the data - selecting columns, filtering rows, applying a
function to a column - but they are not executed immediately. The
eager ones are called actions: they trigger the evaluation.

Concretely: we start with the original DataFrame, apply `select`, then
`filter`, then maybe more transformations. Spark just records this
sequence - no data is touched yet. The moment we call `show()`, the
whole chain gets evaluated and we see the results. If we look at the
Spark UI at that point, Spark seems to compress all these
transformations into one stage and executes them at once.

Examples of actions:

- `show()` - print the results
- `take(5)` and `head(5)` - get five records
- `write.csv(...)` and `write.parquet(...)` - probably the main one:
  writing the results triggers the entire transformation graph

There is also `groupBy` - you specify the column to group by and what
to compute. We will not go into details here; the official
documentation is pretty good, and honestly, for aggregations I would
go with SQL, which we cover in the next video. It is more expressive.

Looking at the select-plus-filter code, you might wonder: isn't this
just SQL? It is - the same thing written as a query would be
`SELECT pickup_datetime, dropoff_datetime, PULocationID, DOLocationID
FROM df WHERE hvfhs_license_num = 'HV0003'`. So why bother with the
DataFrame API? Because it is more flexible, and one of the things it
gives us is user-defined functions.

## Built-in functions

The DataFrame way of doing things is more flexible than SQL, and one
of the things it gives us is user-defined functions. Before we get
there, let's see what functions Spark already has.

Spark ships a collection of built-in functions in `pyspark.sql.functions`,
conventionally imported as `F`:

```python
from pyspark.sql import functions as F
```

Type `F.` and hit tab - there are quite a lot of them. The one we want
is `to_date`: it takes a datetime and keeps only the date, discarding
the hour, minutes and seconds.

To apply it, we use `withColumn`, which adds a new column to a
DataFrame - also a transformation:

```python
df.withColumn('pickup_date', F.to_date(df.pickup_datetime)) \
  .withColumn('dropoff_date', F.to_date(df.dropoff_datetime)) \
  .show()
```

Now there are two new columns, `pickup_date` and `dropoff_date`. If we
give a name that already exists, the column gets overwritten - but be
careful: overwriting `pickup_datetime` with just a date changes the
semantics, so better to select the new columns:

```python
df.withColumn('pickup_date', F.to_date(df.pickup_datetime)) \
  .withColumn('dropoff_date', F.to_date(df.dropoff_datetime)) \
  .select('pickup_date', 'dropoff_date', 'PULocationID', 'DOLocationID') \
  .show()
```

## User-defined functions

There is a huge list of built-in functions, but sometimes you need
your own logic. In data warehouses, defining your own functions is
cumbersome. But PySpark is Python: you can put the code in your git
repo, cover it with tests, and then execute it on your DataFrames.

Let's write a function that does something crazy - something not easy
to express with SQL. Say it takes a dispatching base number like
`B02884`, strips the first character, turns the rest into an integer,
and then:

```python
def crazy_stuff(base_num):
    num = int(base_num[1:])
    if num % 7 == 0:
        return f's/{num:03x}'
    elif num % 3 == 0:
        return f'a/{num:03x}'
    else:
        return f'e/{num:03x}'
```

If the number is divisible by 7, the result starts with `s` and the
number is rendered in hex; if it is divisible by 3, it starts with
`a`; otherwise `e`. Completely made up - but let's say these are the
business requirements. Expressing this in SQL is not very nice,
especially as the conditions keep growing.

A quick sanity check: `crazy_stuff('B02884')` gives `s/b44`.

Now we turn this ordinary Python function into a user-defined
function, a UDF:

```python
crazy_stuff_udf = F.udf(crazy_stuff, returnType=types.StringType())
```

By default the return type is string; if we returned an integer, we
would need to say so explicitly. Now we can use it in `withColumn`:

```python
df \
    .withColumn('base_id', crazy_stuff_udf(df.dispatching_base_num)) \
    .select('base_id', 'pickup_date', 'dropoff_date',
            'PULocationID', 'DOLocationID') \
    .show()
```

This is also a transformation - everything is lazy until we execute
the `show()` action.

While this example is made up, real business rules can get quite
difficult. In SQL you end up with a bunch of nested `CASE` statements,
the query looks ugly, and SQL is very difficult to test - dbt helps,
but it is still not as easy as testing Python code.

That is the nice thing about Spark: you get the best of both worlds.
Use SQL for the parts that are naturally expressible in SQL, and drop
into Python with UDFs for the crazy stuff - and machine learning logic
usually looks like crazy stuff. In the next video we see how to use
SQL inside Spark itself.

## Materials

* [`code/04_pyspark.ipynb`](code/04_pyspark.ipynb) - inferring a schema through
  pandas, declaring an explicit `StructType`, repartitioning, writing parquet,
  actions vs transformations, built-in functions and a user-defined function.
