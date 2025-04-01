# SQL Refresher for module 4

### Table of contents


- [Window Funtions](#window-funtions)
    - [Row Number](#row-number)
    - [Rank and Dense Rank](#rank-and-dense-rank)    
    - [Lag and Lead](#lag-and-lead)   
    - [Percentile Cont](#percentile-cont)         
- [Common Table Expression](#common-table-expression)
- [dbt models and CTEs](#dbt-models-and-ctes)



## Window Funtions    

A window function performs a calculation across a set of table rows that are related to the current row within a specific "window" or subset of data. This is comparable to the type of calculation that can be done with an aggregate function  (such as SUM(), AVG(), COUNT(), etc.).

But unlike regular aggregate functions, use of a window function does not cause rows to become grouped into a single output row — the rows retain their separate identities.


**Syntax:**

```sql
FUNCTION() OVER (PARTITION BY column_name ORDER BY column_name)
```

A window function always has two components. This second part here defines your window:

```sql
OVER (PARTITION BY column_name ORDER BY column_name)
```

Your window here is how you want to be viewing your data when you're applying your function

- PARTITION BY: divides the result set into groups (optional).

- ORDER BY: defines the order of processing rows within the partition.


**Common Window Functions:**

Ranking Functions:

- ROW_NUMBER(): Assigns a unique row number within a partition.
- RANK(): Similar to ROW_NUMBER(), but assigns the same rank to duplicate values, skipping numbers.
- DENSE_RANK(): Like RANK(), but without gaps in numbering.

Aggregate Functions as Window Functions:

- SUM() OVER(): Computes a running total.
- AVG() OVER(): Computes a moving average.

Lag and Lead Functions:

- LAG(): Retrieves the value from a previous row.
- LEAD(): Retrieves the value from the next row.




### Row Number

ROW_NUMBER() does just what it sounds like—displays the number of a given row. It starts at 1 and numbers the rows according to the ORDER BY part of the window statement. Using the PARTITION BY clause will allow you to begin counting 1 again in each partition.

**Syntax:**

```sql
ROW_NUMBER() OVER (PARTITION BY column_name ORDER BY column_name)
```

**Common Uses:**

- Removing Duplicates: You can use ROW_NUMBER() to identify duplicate rows and keep only one by filtering out rows with a row number greater than 1.

- Ranking Data: Used when ranking rows based on specific criteria but requiring unique row numbers.

- Selecting the Latest Record: Helps in selecting the most recent entry per category when combined with PARTITION BY.

**Example 1:**

```sql

SELECT 
  total_amount,
  ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS ranking

FROM `greentaxi_trips` 
LIMIT 10;

```

The query returns the top 10 highest total_amount values from the table, along with a row number indicating their ranking.


| total_amount | ranking |
|--------|--------|
| 4012.3 | 1      |
| 2878.3 | 2      |
| 2438.8 | 3      |
| 2156.3 | 4      |
| 2109.8 | 5      |
| 2017.3 | 6      |
| 1971.05| 7      |
| 1958.8 | 8      |
| 1762.8 | 9      |
| 1600.8 | 10     |

The column generated with ROW_NUMBER() is temporary and does not modify the original table. It is just a calculation applied to the data in the query result.

**Example 2:**

Let's modify the previous query to add a partition by pick up location ID

```sql

SELECT 

  total_amount,
  PULocationID,
  ROW_NUMBER() OVER (PARTITION BY PULocationID ORDER BY total_amount DESC) AS ranking

FROM `greentaxi_trips` 
LIMIT 10;

```

This SQL query  assigns a ranking to each row based on total_amount in descending order within each 
PULocationID group:

| total_amount | PULocationID | ranking |
|-----------|-----------|-----------|
| 8.51      | 224       | 432       |
| 8.3       | 224       | 433       |
| 8.3       | 224       | 434       |
| 7.3       | 224       | 435       |
| 3.3       | 224       | 436       |
| 86.42     | 234       | 1         |
| 73.5      | 234       | 2         |
| 62.7      | 234       | 3         |
| 61.94     | 234       | 4         |
| 61.94     | 234       | 5         |

Using the PARTITION BY clause will allow you to begin counting 1 again in each partition.

### Rank and Dense Rank

ROW_NUMBER(), RANK(), and DENSE_RANK() are window functions used to assign a ranking to rows based on a specified order. However, they behave differently when there are duplicate values in the ranking column.

RANK() assigns a ranking, but skips numbers if there are ties. DENSE_RANK() its similar to RANK(), but does not skip numbers when there are ties.

For example:

| Score | ROW_NUMBER() | RANK() | DENSE_RANK() |
|-------|--------------|--------|--------------|
| 95    | 1            | 1      | 1            |
| 90    | 2            | 2      | 2            |
| 90    | 3            | 2      | 2            |
| 85    | 4            | 4      | 3            |


### Lag and Lead

It can often be useful to compare rows to preceding or following rows. You can use LAG or LEAD to create columns that pull values from other rows without the need for a self-join. All you need to do is enter which column to pull from and how many rows away you'd like to do the pull. LAG pulls from previous rows and LEAD pulls from following rows


**Syntax:**

```sql

LAG(expression) OVER (PARTITION BY partition_expression ORDER BY order_expression)
```

- expression: The column whose value you want to retrieve from the previous row
- offset (optional): The number of rows back from the current row to look. The default is 1, meaning it looks at the immediate previous row.
- PARTITION BY (optional): Divides the result set into partitions to apply the function to each partition separately.
- ORDER BY: Specifies the order in which the rows are processed.

**Example:**

```sql

SELECT 

lpep_pickup_datetime,
total_amount,
LAG(total_amount) OVER (ORDER BY lpep_pickup_datetime) as prev_total_amount,
LEAD(total_amount) OVER (ORDER BY lpep_pickup_datetime) as next_total_amount

FROM `greentaxi_trips` 
ORDER BY lpep_pickup_datetime

```

The query retrieves the lpep_pickup_datetime, total_amount, the previous trip's total_amount, and the next trip's total_amount.

| lpep_pickup_datetime      | total_amount | prev_total_amount | next_total_amount |
|---------------------------|--------------|-------------------|-------------------|
| 2008-12-31 23:33:38 UTC   | 7.3          | 6.3               | 5.3               |
| 2008-12-31 23:42:31 UTC   | 5.3          | 7.3               | 14.55             |
| 2008-12-31 23:47:51 UTC   | 14.55        | 5.3               | 19.55             |
| 2008-12-31 23:57:46 UTC   | 19.55        | 14.55             | 9.8               |
| 2009-01-01 00:00:00 UTC   | 9.8          | 19.55             | 81.3              |


### Percentile Cont

Computes the specified percentile value for the value_expression, with linear interpolation.

**Syntax:**

```sql

PERCENTILE_CONT(value_expression, percentile ) OVER (PARTITION BY partition_expression)
```

**Example:**

Lets calculate the 90th percentile of total_amount for each unique pickup location (PULocationID)

```sql

SELECT 
  PULocationID,
  total_amount,
  PERCENTILE_CONT(total_amount, 0.9 ) OVER (PARTITION BY PULocationID) AS p90

FROM `greentaxi_trips` 

```

- PERCENTILE_CONT(total_amount, 0.9): calculates the 90th percentile (p90) of total_amount
- PARTITION BY PULocationID: This groups the calculations by PULocationID, so the 90th percentile is computed separately for each location.


Query results looks like this:

| PULocationID | total_amount  | p90  |
|------|-------|-------|
| 224  | 17.3    | 51.9  |
| 224  | 20.67    | 51.9  |
| 224  | 21    | 51.9  |
| 224  | 26.06 | 51.9  |
| 224  | 27.13 | 51.9  |
| 224  | 40.14 | 51.9  |
| 224  | 55.46 | 51.9  |
| 224  | 25.74 | 51.9  |
| 224  | 27.02 | 51.9  |
| 224  | 37    | 51.9  |


The P90 value is essentially the amount below which 90% of the values fall. In this table, the P90 
is constant at 51.9, which means that for location "224", 90% of the total amounts are below 51.9.


## Common Table Expression

A CTE, short for Common Table Expression, is like a query within a query. With the WITH statement, you can create temporary tables to store results, making complex queries more readable and maintainable. These temporary tables exist only for the duration of the main query.

CTEs and subqueries are both powerful tools and can be used to achieve similar goals, but they have different use cases and advantages. Differences are CTE is reusable during the entire session and more readable

By declaring CTEs at the beginning of the query, you enhance code readability, enabling a clearer grasp of your analysis logic. 

**Syntax:**

```sql

WITH cte_name AS (
    SELECT column1, column2
    FROM some_table
    WHERE condition
)
SELECT * FROM cte_name;
```

**Example: Let's find the trip with the second largest total_amount**

```sql

WITH cte AS(

  SELECT
  lpep_pickup_datetime,
  total_amount,
  RANK() OVER (ORDER BY total_amount DESC) AS rank

  FROM `greentaxi_trips` 

)


SELECT * FROM cte WHERE rank = 2;

```

The query starts with a Common Table Expression (CTE) named cte. We use the RANK() window function to 
assign a ranking (rank) to each row based on total_amount in descending order (from highest to lowest).

Now, we use the CTE in the main query: ```SELECT * FROM cte WHERE rank = 2;```

Result of the query:


| lpep_pickup_datetime      | total_amount | rank | 
|---------------------------|--------------|-------------------|
| 2019-10-10 15:22:49 UTC  | 2878.3        | 2             | 



## dbt models and CTEs

CTEs and window functions will be used a lot in module 4 on dbt. Let's see an example of application in dbt models

**Example:**

Suppose we start from the FHV dataset and we want to create a dbt model that enriches the data by calculating the trip duration and the 90th percentile.

```sql

WITH trip_duration_calculated AS (

    SELECT
        *,
        timestamp_diff(dropOff_datetime, pickup_datetime, second) as trip_duration

    FROM `fhv_trips`
)

SELECT 

    PUlocationID,
    trip_duration,
    PERCENTILE_CONT(trip_duration, 0.90) OVER (PARTITION BY PUlocationID) AS trip_duration_p90


FROM trip_duration_calculated


```

**Step 1: Understanding the CTE**

The WITH clause creates a CTE named trip_duration_calculated. This CTE acts as a temporary table that 
contains all columns from the fhv_trips table. Additionally, it calculates the trip duration for each ride

**Step 2: Main Query using the CTE and Window Function**

This query computes the 90th percentile of trip duration for each PUlocationID using a window function:

The PARTITION BY PUlocationID clause ensures that the percentile calculation is performed separately 
for each unique PUlocationID.

The percentile 90 means that 90% of the trips have a duration equal to or below this value

**Query result looks like this:**

| PUlocationID | trip_duration | trip_duration_p90 |
|-------------|---------------|--------------------|
| 190         | 451           | 2170.0            |
| 190         | 1373          | 2170.0            |
| 190         | 817           | 2170.0            |
| 190         | 589           | 2170.0            |
| 190         | 1648          | 2170.0            |
| 32          | 546           | 1988.0            |
| 32          | 151           | 1988.0            |
| 32          | 1752          | 1988.0            |
| 32          | 2426          | 1988.0            |
| 32          | 888           | 1988.0            |


- For PUlocationID = 190, 90% of trips have a duration ≤ 2170.0   seconds.
- For PUlocationID = 32, 90% of trips have a duration ≤ 1988.0  seconds.