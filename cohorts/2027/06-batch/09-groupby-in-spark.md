---
video_url: https://www.youtube.com/watch?v=9qrDsY_2COo
---
# GroupBy in Spark

In this unit we look at how Spark actually executes a `GROUP BY`. We take
the hourly-per-zone revenue query from the [previous unit](07-sql-with-spark.md),
run it for the green and yellow datasets, and follow it through the Spark
UI to see the two stages Spark uses - and where the reshuffling happens.

## The query

We start from the same revenue idea as before, but smaller: for the green
dataset, we want the total amount and the number of trips per hour, per
zone:

```sql
SELECT
    date_trunc('hour', lpep_pickup_datetime) AS hour,
    PULocationID AS zone,
    SUM(total_amount) AS amount,
    COUNT(1) AS number_records
FROM
    green
WHERE
    lpep_pickup_datetime >= '2020-01-01'
GROUP BY
    1, 2
ORDER BY
    hour, zone
```

We register the green DataFrame as a temporary table called `green` and run
this with `spark.sql`. The result has a row for each hour and zone: how
much money taxi drivers got in total, and how many trips started in this
location during this hour.

Two small fixes along the way. First, in this notebook we did not rename
the columns, so the green pickup time is still `lpep_pickup_datetime` - not
`pickup_datetime` as in the previous unit. Second, looking at the output we
see records from the past - for example a record with amount 0 from 2008,
which must be a mistake in the data. That's why we add the `WHERE` clause
and only consider data from January 2020 onwards. After that the first row
is 45 records in zone 7 in the very first hour of 2020, as expected.

## What Spark does with it

We write the result to parquet and watch the job in the Spark master UI.
With the `ORDER BY` there are three stages. Without it - two:

- the first stage is the preparation for the group by
- the second stage is the actual group by

The three-stage plan can be represented as a static DAG:

| Stage | Operators, top to bottom |
| --- | --- |
| 9 | `Scan parquet` → `WholeStageCodegen (1)` → `Exchange` |
| 10 | `Exchange` → `WholeStageCodegen (2)` → `Exchange` |
| 11 | `Exchange` → `WholeStageCodegen (3)` |

The final `Exchange` in stage 9 feeds stage 10, and the final `Exchange` in
stage 10 feeds stage 11.

Let's unpack what these two stages mean.

## Stage 1: group by within each partition

Say our DataFrame has a bunch of partitions - for simplicity, three. Each
executor pulls a partition and executes the same code:

```text
partition 1        partition 2        partition 3
    |                  |                  |
  filter             filter             filter      (drop records < 2020)
    |                  |                  |
  group by           group by           group by    (within the partition)
    |                  |                  |
  subresults         subresults         subresults
```

Filtering we already know: it discards the records from before 2020. Then
each executor does an initial group by - initial, because an executor can
only process one partition at a time, and this grouping only sees the
records of its own partition.

Within its partition, the executor groups by our two key fields - hour and
zone - and does the calculations. For example, for hour one and zone one it
outputs the revenue it saw in this partition and the number of trips, say
100 and 5 trips; for the same hour but zone two, 200 and 10 trips. The
second executor does the same for its partition, and when one of them
finishes, the third result appears.

So for each partition we get a set of subresults - already grouped, but
only within that partition. This is stage one.

## Stage 2: reshuffling and the final reduce

The subresults need to be combined: the same key can appear in several
partitions. This is what stage two does, and the process is called
reshuffling. It "shuffles" the records between partitions, guided by the
key: all records with the same key must end up in the same partition.

```text
subresult 1   (h1, z1)   (h1, z2)
subresult 2   (h1, z1)   (h1, z2)
subresult 3   (h1, z1)
        |          |
        +----+-----+
             |
   reshuffle by key (hour, zone)
             |
    +--------+--------+
    |                 |
 records (h1,z1)  records (h1,z2)
    |                 |
  reduce            reduce
```

In our example, hour one zone one shows up in the subresults of all three
partitions. After the reshuffle, all these records sit in one partition.

Internally the reshuffling is implemented as an algorithm called external
merge sort - a way of sorting data that doesn't fit in memory, and it can
be done in a distributed fashion. The records inside each partition are
sorted, which makes it easy to bring all records with the same key
together.

![Group-by subresults are reshuffled by key into output partitions](images/09-groupby-in-spark-03-reshuffling-whiteboard-imagegen.png)

Once the records with the same key are in the same partition, we can do
another group by and reduce them into one: sum the amounts, sum the counts.
Instead of several records with the same key, we output one record with the
combined result - and that is exactly the rows we saw in the query output.

If we look at the job in the Spark UI, the `Exchange` step in the plan is
this reshuffling. And `ORDER BY`? It also uses the same shuffling mechanism
- that's why we had a third stage. For our exploratory query ordering is
not really needed, so we remove it.

## Watching the shuffle in the UI

Back to the UI: for each stage you can see `shuffle read` and
`shuffle write` - how much data had to be reshuffled. This is an expensive
operation, because a lot of data moves over the network, so usually we want
to reshuffle as little data as possible.

We now do the same for the yellow dataset: register it as a temporary
table, run the same query (with `tpep_pickup_datetime` instead of the
`lpep_` prefix), and write the result to `data/report/revenue/yellow`.

Yellow is bigger, and when its job runs we see that stage two produces 200
partitions - quite a few. In practice that would be fine, because with real
datasets the files are a few orders of magnitude bigger. Here the files are
small, so we add one more step - `repartition` - to combine them into
fewer, bigger files. With the repartition, the job has three stages again:
the group by, the aggregating with the shuffling, and the repartitioning
(merging smaller partitions into bigger ones - which also involves a bit of
reshuffling). Stage two produced 200 partitions, the repartition stage
produced only 20, and the whole thing needed to shuffle around 28 MB.

Looking at `data/report` with `tree`, both the green and the yellow folders
have 20 files each. With `ls -lhR` we see the yellow report is about 15 MB
and the green one about 6 MB - a small dataset, but 20 files is still
better than 200 tiny ones.

The completed-stages table in the Spark UI shows the work behind that
report:

| Stage ID | Description | Submitted | Duration | Tasks | Input | Output | Shuffle read |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 35 | `parquet at NativeMethodAccessorImpl.java:0` | 2022/02/18 22:09:58 | 2 s | 20/20 |  | 14.4 MiB | 28.7 MiB |
| 34 | `parquet at NativeMethodAccessorImpl.java:0` | 2022/02/18 22:09:57 | 2 s | 200/200 |  |  |  |
| 33 | `parquet at NativeMethodAccessorImpl.java:0` | 2022/02/18 22:09:42 | 15 s | 11/11 | 425.1 MiB |  |  |

## Summary

Group by in Spark happens in two stages:

- Stage 1: group by within each partition (plus any filtering).
- Stage 2: reshuffling, so that all records with the same key end up in one
  partition, and then reducing these records into one.

Joins - the next unit - are implemented with very similar mechanisms: the
same external merge sort and reshuffling.

## Materials

* [`code/07_groupby_join.ipynb`](code/07_groupby_join.ipynb) - the first half:
  the hourly-per-zone revenue aggregations over green and yellow.
