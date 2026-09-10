---
video_url: https://www.youtube.com/watch?v=k81mLJVX08w
---
# BigQuery Best Practices

This unit is a short checklist of best practices for running queries in
BigQuery. Everything on it serves one of two goals: reducing cost or
improving query performance.

## Cost reduction

Most of our effort goes into cost reduction or query performance, and the
two are related: the cheaper query is usually the one that reads less data.

The slide lists five habits:

- Avoid `SELECT *`. BigQuery stores data columnar: each column is stored
  separately, not as part of a row. When you name the columns you need,
  BigQuery reads only those columns. With `*` it has to read all of them,
  even the ones you never look at. For one or two columns, this is the
  difference between reading almost nothing and reading the whole table.
- Price your queries before running them. The estimated price shows up in
  the top right corner of the query editor. Look at it before you press
  run.
- Use clustered or partitioned tables. We covered this in detail in the
  [previous unit](02-partitioning-vs-clustering.md): both let BigQuery skip
  large parts of the table.
- Use streaming inserts with caution. Streaming inserts can increase your
  cost drastically.
- Materialize query results in stages. Suppose you write a query with a
  CTE (a common table expression, the `WITH` clause) and reuse it in
  several places. Instead of recomputing it each time, run it once, store
  the result in a table, and use that table in the following steps.

One more thing: BigQuery caches query results. When you rerun the same
query, it can serve the cached result instead of recomputing it.

## Query performance

The second group of best practices is about making queries fast.

- Always filter on the partitioned column, or on the clustered column.
  Otherwise the partitioning and clustering you set up do you no good.
- Denormalize your data. In a normalized database you split data into many
  small tables to avoid duplication; in a warehouse you often do the
  opposite and keep things together, so a query doesn't have to join them
  back.
- If you have a complicated structure, use nested or repeated columns.
  They let you keep related data together in one table without
  denormalizing it away entirely.
- Use external data sources appropriately, but don't overdo it. Reading
  from Google Cloud Storage, for example, can incur more cost than reading
  from BigQuery's own storage.
- Reduce the data before you use it in a JOIN: filter first, join after.
- Do not treat `WITH` clauses as prepared statements. A `WITH` clause names
  a subquery inside one query, it is not something you define once and
  reuse across queries.
- Avoid oversharding tables: sharding is splitting your data into many
  small tables, for example one per day. Too many small tables work worse
  than one partitioned table.

## More performance tips

A few more things that speed up queries:

- Avoid JavaScript user-defined functions (UDFs, functions you write
  yourself in SQL).
- Use approximate aggregation functions rather than the exact ones, such
  as HyperLogLog++ for counting distinct values.
- `ORDER` statements should be the last part of your query.
- Optimize your join patterns. Place the table with the largest number of
  rows first, then the table with the fewest rows, then the remaining
  tables by decreasing size. The largest table gets distributed evenly
  across the nodes, and the next table gets broadcast to all of them.

The reason the join order matters is not obvious until you see how
BigQuery actually executes a query. We look at that in detail in the
[next unit](04-internals-of-bigquery.md).
