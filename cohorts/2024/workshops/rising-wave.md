<p align="center">
  <picture>
    <source srcset="https://github.com/risingwavelabs/risingwave/blob/main/.github/RisingWave-logo-dark.svg" width="500px" media="(prefers-color-scheme: dark)">
    <img src="https://github.com/risingwavelabs/risingwave/blob/main/.github/RisingWave-logo-light.svg" width="500px">
  </picture>
</p>


</div>

<p align="center">
  <a
    href="https://docs.risingwave.com/"
    target="_blank"
  ><b>Documentation</b></a>&nbsp;&nbsp;&nbsp;📑&nbsp;&nbsp;&nbsp;
  <a
    href="https://tutorials.risingwave.com/"
    target="_blank"
  ><b>Hands-on Tutorials</b></a>&nbsp;&nbsp;&nbsp;🎯&nbsp;&nbsp;&nbsp;
  <a
    href="https://cloud.risingwave.com/"
    target="_blank"
  ><b>RisingWave Cloud</b></a>&nbsp;&nbsp;&nbsp;🚀&nbsp;&nbsp;&nbsp;
  <a
    href="https://risingwave.com/slack"
    target="_blank"
  >
    <b>Get Instant Help</b>
  </a>
</p>
<div align="center">
  <a
    href="https://risingwave.com/slack"
    target="_blank"
  >
    <img alt="Slack" src="https://badgen.net/badge/Slack/Join%20RisingWave/0abd59?icon=slack" />
  </a>
  <a
    href="https://twitter.com/risingwavelabs"
    target="_blank"
  >
    <img alt="X" src="https://img.shields.io/twitter/follow/risingwavelabs" />
  </a>
  <a
    href="https://www.youtube.com/@risingwave-labs"
    target="_blank"
  >
    <img alt="YouTube" src="https://img.shields.io/youtube/channel/views/UCsHwdyBRxBpmkA5RRd0YNEA" />
  </a>
</div>

## Stream processing with RisingWave

In this hands-on workshop, we’ll learn how to process real-time streaming data using SQL in RisingWave. The system we’ll use is [RisingWave](https://github.com/risingwavelabs/risingwave), an open-source SQL database for processing and managing streaming data. You may not feel unfamiliar with RisingWave’s user experience, as it’s fully wire compatible with PostgreSQL.

![RisingWave](https://raw.githubusercontent.com/risingwavelabs/risingwave-docs/main/docs/images/new_archi_grey.png)

We’ll cover the following topics in this Workshop: 

- Why Stream Processing?
- Stateless computation (Filters, Projections)
- Stateful Computation (Aggregations, Joins)
- Time windowing
- Watermark
- Data Ingestion and Delivery

RisingWave in 10 Minutes:
https://tutorials.risingwave.com/docs/intro

## Homework

The contents below will be covered during the workshop.

### Question 1

What is RisingWave meant to be used for? 

1. OLTP workloads. 
2. Adhoc
OLAP Workloads. 
3. Stream Processing.

### Question 2

What is the interface which RisingWave supports? 

1. Java SDK. 
2. PostgreSQL like interface. 
3. Rust SDK. 
4. Python SDK.

### Question 3

What if I want to run a custom function which RisingWave does not
support? 

1. Sink the data out, run the function, and sink it back in. 
2. Write a Python / Java / WASM / JS UDF. 

### Question 4

Is this statement True or False?
> I cannot create materialized views
on top of other materialized views. 

1. True 

2. False

### Question 5

How does RisingWave process ingested data? 

1. Incrementally, only on
checkpoints. 
2. In batch, each time a user queries a materialized view.
3. In batch, at fixed intervals.
4. Incrementally, as new records are
ingested.

### Question 6

Is the following Statement True or False: 

RisingWave is only for Stream Processing, it cannot serve any select requests from applications. 

1. True 
2. False

### Question 7

Why can’t we use cross joins in RisingWave Materialized Views?

1. Because they are not supported by the SQL standard.
2. Because they are not supported by the Incremental View Maintenance algorithm.
3. Because they are not supported by the PostgreSQL planner.
4. Because they are too expensive, so it is banned in RisingWave’s stream engine.

### Question 8

What is the recommended way to view the progress of long-running SQL
statements like `CREATE MATERIALIZED VIEW` in RisingWave? 

1. Using the
EXPLAIN ANALYZE statement. 
2. Querying the `rw_catalog.rw_ddl_progress` table. 
3. Checking the RisingWave logs. 
4. It is not possible to view the progress of such statements.

### Question 9

How do I view the execution plan of my SQL query?

1. `SHOW <query>` 
2. `EXPLAIN <query>` 
3. `DROP <query>` 
4. `VIEW <query>`

### Question 10

Which is used to ingest data from external systems? 

1.`CREATE SOURCE <...>` 

2.`CREATE SINK <...>`

### Question 11

What is the purpose of a watermark? 

1. To specify the time at which a
record was ingested. 
2. To specify the time at which a record was
updated. 
3. To specify the time at which a record was deleted. 
4. To specify the time at which a record is considered stale, and can be
deleted.

## Submitting the solutions

- Form for submitting: TBA
- You can submit your homework multiple times. In this case, only the
last submission will be used.

Deadline: TBA

## Solution
