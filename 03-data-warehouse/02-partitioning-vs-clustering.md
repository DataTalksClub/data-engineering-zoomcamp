---
video_url: https://www.youtube.com/watch?v=-CqXf7vhhDs
---
# Partitioning vs Clustering

In the [previous unit](01-data-warehouse-and-bigquery.md) we created
partitioned and clustered versions of the yellow taxi data table and saw
how much less data our queries scanned as a result. This unit goes into
the detail: the partitioning options BigQuery gives you, how clustering
sorts your data, and how to decide which of the two to use.

## Partitioning options

When you create a partitioned table in BigQuery, you choose what the
table is partitioned by. There are three options:

- Time-unit column: a column with a timestamp or date, like the pickup
  time of a taxi ride.
- Ingestion time: BigQuery assigns each row to a partition based on
  when it was inserted, using a pseudo-column called `_PARTITIONTIME`.
- Integer range: an integer column split into ranges.

With a time-unit column or ingestion time you also pick the
granularity: daily (the default), hourly, or monthly and yearly.

Daily is a good way to start. It works well when the data is of medium
size and spread evenly across the days.

Hourly is for a huge amount of data coming in, when you want to process
it by the hour. Keep an eye on the number of partitions this creates:
BigQuery allows at most 4000 partitions per table. With hourly
partitions you might need an expiration strategy that removes old
partitions.

Monthly or yearly is for the opposite case: a small amount of data
spread across a wide range of dates.

## How clustering works

When you cluster a table, the columns you specify are used to colocate
related data - rows with similar values end up stored together.

The order of the columns is important, because it determines the sort
order of the data. If you cluster on columns a, b and c, the table is
sorted first by a, then by b, then by c.

Clustering improves filter and aggregate queries, especially when you
filter or aggregate on the columns you clustered by.

Partitioning and clustering are not free, though. If your table is
small - less than 1 GB - neither shows a significant improvement in
query performance. They actually add cost: partitioned and clustered
tables incur metadata reads and metadata maintenance. For a small table
it can make more sense to have no partitioning or clustering at all.

You can specify up to four clustering columns. They must be top-level,
non-repeated columns, and you can choose from these types: DATE,
BOOLEAN, GEOGRAPHY, INT64, NUMERIC, STRING and DATETIME.

## Choosing between partitioning and clustering

Sometimes you want one, sometimes the other, sometimes both. The choice
comes down to a few criteria.

Cost. With partitioning, the cost benefit is known upfront: a query
that filters on the partition column only reads some of the partitions.
With clustering, the benefit is unknown until you run the query. This
matters because BigQuery lets you specify a maximum cost for a query:
if it would exceed that amount, BigQuery does not execute it at all.
You can only do that when the cost is known upfront, which means
partitioning.

Granularity. Use clustering when you need more granularity than
partitioning alone can provide.

Management. Partitioning gives you partition-level management: you can
delete partitions or move partitions between storages. Clustering
gives you none of that.

Columns. With clustering, you commonly filter or aggregate your data
on multiple columns. Partitioning works on a single column only,
because partitioning is only possible on one column.

Cardinality. Use clustering when the number of distinct values in a
column or group of columns is large. That cardinality is a hindrance
for partitioning, because of the 4000-partition limit.

## When clustering beats partitioning

Putting the criteria together, these are the situations where you
should choose clustering over partitioning:

- Partitioning would leave a small amount of data per partition -
  roughly less than 1 GB.
- Partitioning would create more partitions than the limit of 4000 per
  table.
- Your mutation operations would modify the majority of the partitions
  frequently - for example, writing to the table every few minutes.

## Automatic reclustering

As data is added to a clustered table, the newly inserted rows are
written into blocks whose key ranges can overlap the key ranges stored
in previous blocks. These overlapping keys weaken the sort property of
the table, and queries get slower.

To maintain the performance characteristics of a clustered table,
BigQuery performs automatic reclustering in the background: it restores
the sort property of the table without you doing anything. For
partitioned tables, clustering is maintained within the scope of each
partition.

Reclustering does not impact query performance, and it does not cost
you anything - BigQuery takes care of it.

## Summary

In this unit we have seen the partitioning options BigQuery offers, how
clustering colocates and sorts the data, what the criteria are for
choosing between partitioning and clustering, and how BigQuery
reclusters automatically.

A good exercise: think about the yellow taxi dataset from the previous
unit. Which column would you partition it by, and what would you
cluster it on? Think about the queries you want to run - that is what
the choice comes down to.

## Materials

- [`big_query.sql`](big_query.sql) — the partitioning and clustering half of the
  file: creating partitioned and partitioned-plus-clustered tables from the
  external table, inspecting `INFORMATION_SCHEMA.PARTITIONS`, and the paired
  queries that show how much data each variant scans.
