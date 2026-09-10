---
video_url: https://www.youtube.com/watch?v=lu7TrqAWuH4
---
# Joins in Spark

In this unit we look at joins in Spark. We cover two cases - joining two
tables of similar size, and joining a large table with a small one - and we
see how both are executed internally: with the external merge sort and
reshuffling we already know from [group by](09-groupby-in-spark.md).

## Joining the two revenue tables

Where we left off last time: we have two tables, the hourly revenue for
green taxis and the hourly revenue for yellow taxis. Each has the hour, the
zone, the amount and the number of trips. We want to join them by hour and
zone and get one wider table: hour, zone, then the yellow revenue and trips
next to the green revenue and trips.

```python
df_join = df_green_revenue_temp \
    .join(df_yellow_revenue_temp, on=['hour', 'zone'], how='outer')
```

The join type is `outer`: when a record exists in green but not in yellow,
we still want it in the result - with nulls in the yellow columns - and the
other way around.

Note that this one `show()` (or `write`) executes the whole chain from the
very beginning: it reads the parquet files, runs the green revenue query,
reads another set of parquet files, runs the yellow revenue query, and only
then joins.

In the output we immediately see a problem: the columns are just `amount`
and `number_records` twice - we can't tell which one is green and which one
is yellow. So before joining we rename the columns:

```python
df_green_revenue_temp = df_green_revenue \
    .withColumnRenamed('amount', 'green_amount') \
    .withColumnRenamed('number_records', 'green_number_records')

df_yellow_revenue_temp = df_yellow_revenue \
    .withColumnRenamed('amount', 'yellow_amount') \
    .withColumnRenamed('number_records', 'yellow_number_records')
```

Now the result has `green_amount`, `green_number_records`,
`yellow_amount` and `yellow_number_records`, and we can save it:

```python
df_join.write.parquet('data/report/revenue/total', mode='overwrite')
```

Looking at the job in the Spark UI: three stages. The first one reads the
data and does the group by - that's green (or yellow, doesn't matter). The
second one does the same for the other taxi type. And the third stage
combines the two - the join itself.

The plan can be represented as a static DAG. The two input branches stay
separate until `SortMergeJoin`:

```text
Stage 53: Scan parquet -> WholeStageCodegen (3) -> Exchange
Stage 54: Scan parquet -> WholeStageCodegen (1) -> Exchange
Stage 55:
  Exchange -> WholeStageCodegen (2) --\
                                       -> SortMergeJoin -> WholeStageCodegen (5)
  Exchange -> WholeStageCodegen (4) --/
```

## How a join of two large tables works

Now the whiteboard version. We have the yellow dataset with a bunch of
partitions and the green dataset with a bunch of partitions. Records of
yellow we call `y1`, `y2`, and so on, records of green - `g1`, `g2`, and so
on. Each record is a composite of hour, zone, revenue and trip count.

```text
yellow partitions        green partitions
+------------+           +------------+
| k1 -> y1   |           | k2 -> g1   |
| k1 -> y2   |           | k3 -> g2   |
| k3 -> y3   |           | k4 -> g3   |
+------------+           +------------+
        |                     |
        +---- reshuffle ------+
        |    by key           |
   +---------+  +---------+  +---------+
   | k1: y1  |  | k2: y2  |  | k3: y3  |
   |    y2   |  |    g1   |  |    g3*  |
   +---------+  +---------+  +---------+
        |             |
   (k1, y1, null)  (k2, y2, g1)
```

For every record we create a complex record: the join key and the payload.
Because we join on two columns, the key is a composite key of hour and
zone - in the sketch, `k1` through `k4`.

Then we do reshuffling, like in the group by case. The purpose is the same:
all records with the same key must end up in the same partition. Everything
with `k1` goes to the first partition, everything with `k2` - to the
second, and so on.

After that we combine the records, similar to the reduce step in group by.
If we see two records with the same key - like `k2` with `y2` and `g1` -
we turn them into one record: `k2`, `y2`, `g1`. If there is no pair, the
join type decides what happens. With an outer join we output the record
with nulls: `k1`, `y1`, `null` or `k4`, `null`, `g3`. With an inner join we
would simply not output these records.

The algorithm doing this reshuffling is, again, external merge sort. That's
why in the execution plan this is called a sort merge join. And `shuffle
read` and `shuffle write` in the UI show us how much reshuffling actually
happened.

## Materializing intermediate results

In the run above we didn't read the green and yellow revenue tables we
saved last time - we recomputed them on the fly. Instead, we can load the
previously prepared results:

```python
df_green_revenue = spark.read.parquet('data/report/revenue/green')
df_yellow_revenue = spark.read.parquet('data/report/revenue/yellow')
```

Then rename the columns, join, and write as before. Saving an intermediate
result and reusing it is called materializing it. It can be useful beyond
this join - maybe we want a dashboard showing the green revenue separately.

Interestingly, the plan for this version doesn't look very different - also
three stages. The dataset here is probably just too small to see the
difference. In any case, the main point of this unit is how the join is
implemented, and that's the case of two relatively large tables.

## Joining with a small table: broadcast join

There is another case: one large table and one small one. We take the
joined revenue table (now read back from parquet - we don't want to wait
for the whole computation again), and we want to see what each zone
actually is. For that we have the zones table - it was created in one of
the first videos by loading the zones CSV and writing it as parquet:

```python
df_zones = spark.read.parquet('zones/')
```

The first rows of the lookup table are:

| LocationID | Borough | Zone | service_zone |
| ---: | --- | --- | --- |
| 1 | EWR | Newark Airport | EWR |
| 2 | Queens | Jamaica Bay | Boro Zone |
| 3 | Bronx | Allerton/Pelham Gardens | Boro Zone |
| 4 | Manhattan | Alphabet City | Yellow Zone |
| 5 | Staten Island | Arden Heights | Boro Zone |
| 6 | Staten Island | Arrochar/Fort Wadsworth | Boro Zone |
| 7 | Queens | Astoria | Boro Zone |
| 8 | Queens | Astoria Park | Boro Zone |
| 9 | Queens | Auburndale | Boro Zone |
| 10 | Queens | Baisley Park | Boro Zone |
| 11 | Brooklyn | Bath Beach | Boro Zone |

It's a small lookup table: location ID, borough, zone name and service
zone. Now the join - this time the column names are different in the two
tables, so instead of `on` we use a condition:

```python
df_result = df_join \
    .join(df_zones, df_join.zone == df_zones.LocationID)
```

The zone ID in our table is an integer while the zones table stores it
differently, so we also drop the extra ID columns and keep only the zone
name. Then we write the result to parquet.

Look at the execution plan now: there is a `BroadcastExchange`, and only
one stage - no reshuffling at all. The reason is that the zones DataFrame
is very small. Instead of appending keys and doing the sort merge join,
Spark broadcasts the small table: it sends a full copy of it to every
executor. Each executor processes its partition of the big table and does
the join in memory: for each revenue record, it looks up the zone by ID and
appends the zone information.

No data needs to be shuffled - only the small table is sent around once.
This is much, much faster than a sort merge join.

## Summary

- Two large tables: a sort merge join. Add the key to each record,
  reshuffle so that records with the same key end up in the same partition,
  then combine them there.
- One large and one small table: a broadcast join. Send a copy of the small
  table to every executor and do the lookup in memory - no reshuffling,
  which is why it's just one stage and it's fast.

## Materials

* [`code/07_groupby_join.ipynb`](code/07_groupby_join.ipynb) - the second half:
  the outer join of the two revenue tables, and the join against the small
  `zones` table.
