This [dbt](https://github.com/dbt-labs/dbt) package contains macros that can be (re)used across dbt projects.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

----
## Contents

**[Schema tests](#schema-tests)**
  - [equal_rowcount](#equal_rowcount-source)
  - [equality](#equality-source)
  - [expression_is_true](#expression_is_true-source)
  - [recency](#recency-source)
  - [at_least_one](#at_least_one-source)
  - [not_constant](#not_constant-source)
  - [cardinality_equality](#cardinality_equality-source)
  - [unique_where](#unique_where-source)
  - [not_null_where](#not_null_where-source)
  - [not_null_proportion](#not_null_proportion-source)
  - [relationships_where](#relationships_where-source)
  - [mutually_exclusive_ranges](#mutually_exclusive_ranges-source)
  - [unique_combination_of_columns](#unique_combination_of_columns-source)
  - [accepted_range](#accepted_range-source)

**[Macros](#macros)**

- [Introspective macros](#introspective-macros):
    - [get_column_values](#get_column_values-source)
    - [get_relations_by_pattern](#get_relations_by_pattern-source)
    - [get_relations_by_prefix](#get_relations_by_prefix-source)
    - [get_query_results_as_dict](#get_query_results_as_dict-source)

- [SQL generators](#sql-generators)
    - [date_spine](#date_spine-source)
    - [haversine_distance](#haversine_distance-source)
    - [group_by](#group_by-source)
    - [star](#star-source)
    - [union_relations](#union_relations-source)
    - [generate_series](#generate_series-source)
    - [surrogate_key](#surrogate_key-source)
    - [safe_add](#safe_add-source)
    - [pivot](#pivot-source)
    - [unpivot](#unpivot-source)

- [Web macros](#web-macros)
    - [get_url_parameter](#get_url_parameter-source)
    - [get_url_host](#get_url_host-source)
    - [get_url_path](#get_url_path-source)

- [Cross-database macros](#cross-database-macros):
    - [current_timestamp](#current_timestamp-source)
    - [dateadd](#dateadd-source)
    - [datediff](#datediff-source)
    - [split_part](#split_part-source)
    - [last_day](#last_day-source)
    - [width_bucket](#width_bucket-source)

- [Jinja Helpers](#jinja-helpers)
    - [pretty_time](#pretty_time-source)
    - [pretty_log_format](#pretty_log_format-source)
    - [log_info](#log_info-source)

[Materializations](#materializations):
- [insert_by_period](#insert_by_period-source)

---
### Schema Tests
#### equal_rowcount ([source](macros/schema_tests/equal_rowcount.sql))
This schema test asserts the that two relations have the same number of rows.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.equal_rowcount:
          compare_model: ref('other_table_name')

```

#### fewer_rows_than ([source](macros/schema_tests/fewer_rows_than.sql))
This schema test asserts that this model has fewer rows than the referenced model.

Usage:
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.fewer_rows_than:
          compare_model: ref('other_table_name')
```

#### equality ([source](macros/schema_tests/equality.sql))
This schema test asserts the equality of two relations. Optionally specify a subset of columns to compare.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.equality:
          compare_model: ref('other_table_name')
          compare_columns:
            - first_column
            - second_column
```

#### expression_is_true ([source](macros/schema_tests/expression_is_true.sql))
This schema test asserts that a valid sql expression is true for all records. This is useful when checking integrity across columns, for example, that a total is equal to the sum of its parts, or that at least one column is true.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.expression_is_true:
          expression: "col_a + col_b = total"
```

The macro accepts an optional argument `condition` that allows for asserting
the `expression` on a subset of all records.

**Usage:**

```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.expression_is_true:
          expression: "col_a + col_b = total"
          condition: "created_at > '2018-12-31'"
```

This macro can also be used at the column level. When this is done, the `expression` is evaluated against the column.

```yaml
version: 2
models:
    - name: model_name
      columns:
        - name: col_a
          tests:
            - dbt_utils.expression_is_true:
                expression: '>= 1'
        - name: col_b
          tests:
            - dbt_utils.expression_is_true:
                expression: '= 1'
                condition: col_a = 1
```

#### recency ([source](macros/schema_tests/recency.sql))
This schema test asserts that there is data in the referenced model at least as recent as the defined interval prior to the current timestamp.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.recency:
          datepart: day
          field: created_at
          interval: 1
```

#### at_least_one ([source](macros/schema_tests/at_least_one.sql))
This schema test asserts if column has at least one value.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: col_name
        tests:
          - dbt_utils.at_least_one
```

#### not_constant ([source](macros/schema_tests/not_constant.sql))
This schema test asserts if column does not have same value in all rows.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: column_name
        tests:
          - dbt_utils.not_constant
```

#### cardinality_equality ([source](macros/schema_tests/cardinality_equality.sql))
This schema test asserts if values in a given column have exactly the same cardinality as values from a different column in a different model.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: from_column
        tests:
          - dbt_utils.cardinality_equality:
              field: other_column_name
              to: ref('other_model_name')
```

#### unique_where ([source](macros/schema_tests/test_unique_where.sql))
This test validates that there are no duplicate values present in a field for a subset of rows by specifying a `where` clause.

**Usage:**
```yaml
version: 2

models:
  - name: my_model
    columns:
      - name: id
        tests:
          - dbt_utils.unique_where:
              where: "_deleted = false"
```

#### not_null_where ([source](macros/schema_tests/test_not_null_where.sql))
This test validates that there are no null values present in a column for a subset of rows by specifying a `where` clause.

**Usage:**
```yaml
version: 2

models:
  - name: my_model
    columns:
      - name: id
        tests:
          - dbt_utils.not_null_where:
              where: "_deleted = false"
```

#### not_null_proportion ([source](macros/schema_tests/not_null_proportion.sql))
This test validates that the proportion of non-null values present in a column is between a specified range [`at_least`, `at_most`] where `at_most` is an optional argument (default: `1.0`).

**Usage:**
```yaml
version: 2

models:
  - name: my_model
    columns:
      - name: id
        tests:
          - dbt_utils.not_null_proportion:
              at_least: 0.95
```

#### not_accepted_values ([source](macros/schema_tests/not_accepted_values.sql))
This test validates that there are no rows that match the given values.

Usage:
```yaml
version: 2

models:
  - name: my_model
    columns:
      - name: city
        tests:
          - dbt_utils.not_accepted_values:
              values: ['Barcelona', 'New York']
```

#### relationships_where ([source](macros/schema_tests/relationships_where.sql))
This test validates the referential integrity between two relations (same as the core relationships schema test) with an added predicate to filter out some rows from the test. This is useful to exclude records such as test entities, rows created in the last X minutes/hours to account for temporary gaps due to ETL limitations, etc.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: id
        tests:
          - dbt_utils.relationships_where:
              to: ref('other_model_name')
              field: client_id
              from_condition: id <> '4ca448b8-24bf-4b88-96c6-b1609499c38b'
```

#### mutually_exclusive_ranges ([source](macros/schema_tests/mutually_exclusive_ranges.sql))
This test confirms that for a given lower_bound_column and upper_bound_column,
the ranges of between the lower and upper bounds do not overlap with the ranges
of another row.

**Usage:**
```yaml
version: 2

models:
  # test that age ranges do not overlap
  - name: age_brackets
    tests:
      - dbt_utils.mutually_exclusive_ranges:
          lower_bound_column: min_age
          upper_bound_column: max_age
          gaps: not_allowed

  # test that each customer can only have one subscription at a time
  - name: subscriptions
    tests:
      - dbt_utils.mutually_exclusive_ranges:
          lower_bound_column: started_at
          upper_bound_column: ended_at
          partition_by: customer_id
          gaps: required

  # test that each customer can have subscriptions that start and end on the same date
  - name: subscriptions
    tests:
      - dbt_utils.mutually_exclusive_ranges:
          lower_bound_column: started_at
          upper_bound_column: ended_at
          partition_by: customer_id
          zero_length_range_allowed: true
```

**Args:**
* `lower_bound_column` (required): The name of the column that represents the
lower value of the range. Must be not null.
* `upper_bound_column` (required): The name of the column that represents the
upper value of the range. Must be not null.
* `partition_by` (optional): If a subset of records should be mutually exclusive
(e.g. all periods for a single subscription_id are mutually exclusive), use this
argument to indicate which column to partition by. `default=none`
* `gaps` (optional): Whether there can be gaps are allowed between ranges.
`default='allowed', one_of=['not_allowed', 'allowed', 'required']`
* `zero_length_range_allowed` (optional): Whether ranges can start and end on the same date.
`default=False`

**Note:** Both `lower_bound_column` and `upper_bound_column` should be not null.
If this is not the case in your data source, consider passing a coalesce function
to the `lower_` and `upper_bound_column` arguments, like so:
```yaml
version: 2

models:
- name: subscriptions
  tests:
    - dbt_utils.mutually_exclusive_ranges:
        lower_bound_column: coalesce(started_at, '1900-01-01')
        upper_bound_column: coalesce(ended_at, '2099-12-31')
        partition_by: customer_id
        gaps: allowed
```

**Understanding the `gaps` argument:**
Here are a number of examples for each allowed `gaps` argument.
* `gaps: not_allowed`: The upper bound of one record must be the lower bound of
the next record.

| lower_bound | upper_bound |
|-------------|-------------|
| 0           | 1           |
| 1           | 2           |
| 2           | 3           |

* `gaps: allowed` (default): There may be a gap between the upper bound of one
record and the lower bound of the next record.

| lower_bound | upper_bound |
|-------------|-------------|
| 0           | 1           |
| 2           | 3           |
| 3           | 4           |

* `gaps: required`: There must be a gap between the upper bound of one record and
the lower bound of the next record (common for date ranges).

| lower_bound | upper_bound |
|-------------|-------------|
| 0           | 1           |
| 2           | 3           |
| 4           | 5           |

**Understanding the `zero_length_range_allowed` argument:**
Here are a number of examples for each allowed `zero_length_range_allowed` argument.
* `zero_length_range_allowed: false`: (default) The upper bound of each record must be greater than its lower bound.

| lower_bound | upper_bound |
|-------------|-------------|
| 0           | 1           |
| 1           | 2           |
| 2           | 3           |

* `zero_length_range_allowed: true`: The upper bound of each record can be greater than or equal to its lower bound.

| lower_bound | upper_bound |
|-------------|-------------|
| 0           | 1           |
| 2           | 2           |
| 3           | 4           |

#### sequential_values ([source](macros/schema_tests/sequential_values.sql))
This test confirms that a column contains sequential values. It can be used
for both numeric values, and datetime values, as follows:
```yml
version: 2

seeds:
  - name: util_even_numbers
    columns:
      - name: i
        tests:
          - dbt_utils.sequential_values:
              interval: 2


  - name: util_hours
    columns:
      - name: date_hour
        tests:
          - dbt_utils.sequential_values:
              interval: 1
              datepart: 'hour'
```

**Args:**
* `interval` (default=1): The gap between two sequential values
* `datepart` (default=None): Used when the gaps are a unit of time. If omitted, the test will check for a numeric gap.

#### unique_combination_of_columns ([source](macros/schema_tests/unique_combination_of_columns.sql))
This test confirms that the combination of columns is unique. For example, the
combination of month and product is unique, however neither column is unique
in isolation.

We generally recommend testing this uniqueness condition by either:
* generating a [surrogate_key](#surrogate_key-source) for your model and testing
the uniqueness of said key, OR
* passing the `unique` test a coalesce of the columns (as discussed [here](https://docs.getdbt.com/docs/building-a-dbt-project/testing-and-documentation/testing/#testing-expressions)).

However, these approaches can become non-perfomant on large data sets, in which
case we recommend using this test instead.

**Usage:**
```yaml
- name: revenue_by_product_by_month
  tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
          - month
          - product
```

An optional `quote_columns` argument (`default=false`) can also be used if a column name needs to be quoted.

```yaml
- name: revenue_by_product_by_month
  tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
          - month
          - group
        quote_columns: true

```

#### accepted_range ([source](macros/schema_tests/accepted_range.sql))
This test checks that a column's values fall inside an expected range. Any combination of `min_value` and `max_value` is allowed, and the range can be inclusive or exclusive. Provide a `where` argument to filter to specific records only.

In addition to comparisons to a scalar value, you can also compare to another column's values. Any data type that supports the `>` or `<` operators can be compared, so you could also run tests like checking that all order dates are in the past.

**Usage:**
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: user_id
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
              inclusive: false

      - name: account_created_at
        tests:
          - dbt_utils.accepted_range:
              max_value: "getdate()"
              #inclusive is true by default

      - name: num_returned_orders
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: "num_orders"

      - name: num_web_sessions
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
              inclusive: false
              where: "num_orders > 0"
```

----

## Macros

### Introspective macros
These macros run a query and return the results of the query as objects. They are typically abstractions over the [statement blocks](https://docs.getdbt.com/reference/dbt-jinja-functions/statement-blocks) in dbt.


#### get_column_values ([source](macros/sql/get_column_values.sql))
This macro returns the unique values for a column in a given [relation](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation) as an array.

Arguments:
- `table` (required): a [Relation](https://docs.getdbt.com/reference/dbt-classes#relation) (a `ref` or `source`) that contains the list of columns you wish to select from
- `column` (required): The name of the column you wish to find the column values of
- `order_by` (optional, default=`'count(*) desc'`): How the results should be ordered. The default is to order by `count(*) desc`, i.e. decreasing frequency. Setting this as `'my_column'` will sort alphabetically, while `'min(created_at)'` will sort by when thevalue was first observed.
- `max_records` (optional, default=`none`): The maximum number of column values you want to return
- `default` (optional, default=`[]`): The results this macro should return if the relation has not yet been created (and therefore has no column values).


**Usage:**
```sql
-- Returns a list of the payment_methods in the stg_payments model_
{% set payment_methods = dbt_utils.get_column_values(table=ref('stg_payments'), column='payment_method') %}

{% for payment_method in payment_methods %}
    ...
{% endfor %}

...
```

```sql
-- Returns the list sorted alphabetically
{% set payment_methods = dbt_utils.get_column_values(
        table=ref('stg_payments'),
        column='payment_method',
        order_by='payment_method'
) %}
```

```sql
-- Returns the list sorted my most recently observed
{% set payment_methods = dbt_utils.get_column_values(
        table=ref('stg_payments'),
        column='payment_method',
        order_by='max(created_at) desc',
        max_records=50,
        default=['bank_transfer', 'coupon', 'credit_card']
%}
...
```

#### get_relations_by_pattern ([source](macros/sql/get_relations_by_pattern.sql))
Returns a list of [Relations](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation)
that match a given schema- or table-name pattern.

This macro is particularly handy when paired with `union_relations`.

**Usage:**
```
-- Returns a list of relations that match schema_pattern%.table
{% set relations = dbt_utils.get_relations_by_pattern('schema_pattern%', 'table_pattern') %}

-- Returns a list of relations that match schema_pattern.table_pattern%
{% set relations = dbt_utils.get_relations_by_pattern('schema_pattern', 'table_pattern%') %}

-- Returns a list of relations as above, excluding any that end in `deprecated`
{% set relations = dbt_utils.get_relations_by_pattern('schema_pattern', 'table_pattern%', '%deprecated') %}

-- Example using the union_relations macro
{% set event_relations = dbt_utils.get_relations_by_pattern('venue%', 'clicks') %}
{{ dbt_utils.union_relations(relations = event_relations) }}
```

**Args:**
* `schema_pattern` (required): The schema pattern to inspect for relations.
* `table_pattern` (required): The name of the table/view (case insensitive).
* `exclude` (optional): Exclude any relations that match this table pattern.
* `database` (optional, default = `target.database`): The database to inspect
for relations.

**Examples:**
Generate drop statements for all Relations that match a naming pattern:
```sql
{% set relations_to_drop = dbt_utils.get_relations_by_pattern(
    schema_pattern='public',
    table_pattern='dbt\_%'
) %}

{% set sql_to_execute = [] %}

{{ log('Statements to run:', info=True) }}

{% for relation in relations_to_drop %}
    {% set drop_command -%}
    -- drop {{ relation.type }} {{ relation }} cascade;
    {%- endset %}
    {% do log(drop_command, info=True) %}
    {% do sql_to_execute.append(drop_command) %}
{% endfor %}
```

#### get_relations_by_prefix ([source](macros/sql/get_relations_by_prefix.sql))
> This macro will soon be deprecated in favor of the more flexible `get_relations_by_pattern` macro (above)

Returns a list of [Relations](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation)
that match a given prefix, with an optional exclusion pattern. It's particularly
handy paired with `union_relations`.

**Usage:**

```
-- Returns a list of relations that match schema.prefix%
{% set relations = dbt_utils.get_relations_by_prefix('my_schema', 'my_prefix') %}

-- Returns a list of relations as above, excluding any that end in `deprecated`
{% set relations = dbt_utils.get_relations_by_prefix('my_schema', 'my_prefix', '%deprecated') %}

-- Example using the union_relations macro
{% set event_relations = dbt_utils.get_relations_by_prefix('events', 'event_') %}
{{ dbt_utils.union_relations(relations = event_relations) }}
```

**Args:**
* `schema` (required): The schema to inspect for relations.
* `prefix` (required): The prefix of the table/view (case insensitive)
* `exclude` (optional): Exclude any relations that match this pattern.
* `database` (optional, default = `target.database`): The database to inspect
for relations.

#### get_query_results_as_dict ([source](macros/sql/get_query_results_as_dict.sql))
This macro returns a dictionary from a sql query, so that you don't need to interact with the Agate library to operate on the result

**Usage:**
```
-- Returns a dictionary of the users table where the state is California
{% set california_cities = dbt_utils.get_query_results_as_dict("select * from" ~ ref('cities') ~ "where state = 'CA' and city is not null ") %}
select
  city,
{% for city in california_cities %}
  sum(case when city = {{ city }} then 1 else 0 end) as users_in_{{ city }},
{% endfor %}
  count(*) as total
from {{ ref('users') }}

group by 1
```

### SQL generators
These macros generate SQL (either a complete query, or a part of a query). They often implement patterns that should be easy in SQL, but for some reason are much harder than they need to be.

#### date_spine ([source](macros/sql/date_spine.sql))
This macro returns the sql required to build a date spine. The spine will include the `start_date` (if it is aligned to the `datepart`), but it will not include the `end_date`.

**Usage:**

```
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2019-01-01' as date)",
    end_date="cast('2020-01-01' as date)"
   )
}}
```

#### haversine_distance ([source](macros/sql/haversine_distance.sql))
This macro calculates the [haversine distance](http://daynebatten.com/2015/09/latitude-longitude-distance-sql/) between a pair of x/y coordinates.

Optionally takes a `unit` string argument ('km' or 'mi') which defaults to miles (imperial system).

**Usage:**

```
{{ dbt_utils.haversine_distance(48.864716, 2.349014, 52.379189, 4.899431) }}

{{ dbt_utils.haversine_distance(
    lat1=48.864716,
    lon1=2.349014,
    lat2=52.379189,
    lon2=4.899431,
    unit='km'
) }}
```

**Args:**
- `lat1` (required): latitude of first location
- `lon1` (required): longitude of first location
- `lat2` (required): latitude of second location
- `lon3` (required): longitude of second location
- `unit` (optional, default=`'mi'`): one of `mi` (miles) or `km` (kilometers)

#### group_by ([source](macros/sql/groupby.sql))
This macro build a group by statement for fields 1...N

**Usage:**

```
{{ dbt_utils.group_by(n=3) }}
```

Would compile to:

```sql
group by 1,2,3
```

#### star ([source](macros/sql/star.sql))
This macro generates a list of all fields that exist in the `from` relation, excluding any fields listed in the `except` argument. The construction is identical to `select * from {{ref('my_model')}}`, replacing star (`*`) with the star macro. This macro also has an optional `relation_alias` argument that will prefix all generated fields with an alias (`relation_alias`.`field_name`). The macro also has optional `prefix` and `suffix` arguments, which will be appropriately concatenated to each field name in the output (`prefix` ~ `field_name` ~ `suffix`).

**Usage:**
```sql
select
  {{ dbt_utils.star(ref('my_model')) }}
from {{ ref('my_model') }}

```

```sql
select
{{ dbt_utils.star(from=ref('my_model'), except=["exclude_field_1", "exclude_field_2"]) }}
from {{ ref('my_model') }}

```

#### union_relations ([source](macros/sql/union.sql))

This macro unions together an array of [Relations](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation),
even when columns have differing orders in each Relation, and/or some columns are
missing from some relations. Any columns exclusive to a subset of these
relations will be filled with `null` where not present. An new column
(`_dbt_source_relation`) is also added to indicate the source for each record.

**Usage:**
```
{{ dbt_utils.union_relations(
    relations=[ref('my_model'), source('my_source', 'my_table')],
    exclude=["_loaded_at"]
) }}
```

**Args:**
* `relations` (required): An array of [Relations](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation).
* `exclude` (optional): A list of column names that should be excluded from
the final query.
* `include` (optional): A list of column names that should be included in the
final query. Note the `include` and `exclude` arguments are mutually exclusive.
* `column_override` (optional): A dictionary of explicit column type overrides,
e.g. `{"some_field": "varchar(100)"}`.``
* `source_column_name` (optional, `default="_dbt_source_relation"`): The name of
the column that records the source of this row.

#### generate_series ([source](macros/sql/generate_series.sql))
This macro implements a cross-database mechanism to generate an arbitrarily long list of numbers. Specify the maximum number you'd like in your list and it will create a 1-indexed SQL result set.

**Usage:**
```
{{ dbt_utils.generate_series(upper_bound=1000) }}
```

#### surrogate_key ([source](macros/sql/surrogate_key.sql))
Implements a cross-database way to generate a hashed surrogate key using the fields specified.

**Usage:**
```
{{ dbt_utils.surrogate_key(['field_a', 'field_b'[,...]]) }}
```

#### safe_add ([source](macros/sql/safe_add.sql))
Implements a cross-database way to sum nullable fields using the fields specified.

**Usage:**
```
{{ dbt_utils.safe_add('field_a', 'field_b'[,...]) }}
```

#### pivot ([source](macros/sql/pivot.sql))
This macro pivots values from rows to columns.

**Usage:**
```
{{ dbt_utils.pivot(<column>, <list of values>) }}
```

**Example:**

    Input: orders

    | size | color |
    |------|-------|
    | S    | red   |
    | S    | blue  |
    | S    | red   |
    | M    | red   |

    select
      size,
      {{ dbt_utils.pivot(
          'color',
          dbt_utils.get_column_values(ref('orders'), 'color')
      ) }}
    from {{ ref('orders') }}
    group by size

    Output:

    | size | red | blue |
    |------|-----|------|
    | S    | 2   | 1    |
    | M    | 1   | 0    |

**Args:**
- `column`: Column name, required
- `values`: List of row values to turn into columns, required
- `alias`: Whether to create column aliases, default is True
- `agg`: SQL aggregation function, default is sum
- `cmp`: SQL value comparison, default is =
- `prefix`: Column alias prefix, default is blank
- `suffix`: Column alias postfix, default is blank
- `then_value`: Value to use if comparison succeeds, default is 1
- `else_value`: Value to use if comparison fails, default is 0
- `quote_identifiers`: Whether to surround column aliases with double quotes, default is true

#### unpivot ([source](macros/sql/unpivot.sql))
This macro "un-pivots" a table from wide format to long format. Functionality is similar to pandas [melt](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.melt.html) function.
Boolean values are replaced with the strings 'true'|'false'

**Usage:**
```
{{ dbt_utils.unpivot(
  relation=ref('table_name'),
  cast_to='datatype',
  exclude=[<list of columns to exclude from unpivot>],
  remove=[<list of columns to remove>],
  field_name=<column name for field>,
  value_name=<column name for value>
) }}
```

**Usage:**

    Input: orders

    | date       | size | color | status     |
    |------------|------|-------|------------|
    | 2017-01-01 | S    | red   | complete   |
    | 2017-03-01 | S    | red   | processing |

    {{ dbt_utils.unpivot(ref('orders'), cast_to='varchar', exclude=['date','status']) }}

    Output:

    | date       | status     | field_name | value |
    |------------|------------|------------|-------|
    | 2017-01-01 | complete   | size       | S     |
    | 2017-01-01 | complete   | color      | red   |
    | 2017-03-01 | processing | size       | S     |
    | 2017-03-01 | processing | color      | red   |

**Args**:
- `relation`: The [Relation](https://docs.getdbt.com/docs/writing-code-in-dbt/class-reference/#relation) to unpivot.
- `cast_to`: The data type to cast the unpivoted values to, default is varchar
- `exclude`: A list of columns to exclude from the unpivot operation but keep in the resulting table.
- `remove`: A list of columns to remove from the resulting table.
- `field_name`: column name in the resulting table for field
- `value_name`: column name in the resulting table for value

### Web macros
#### get_url_parameter ([source](macros/web/get_url_parameter.sql))
This macro extracts a url parameter from a column containing a url.

**Usage:**
```
{{ dbt_utils.get_url_parameter(field='page_url', url_parameter='utm_source') }}
```

#### get_url_host ([source](macros/web/get_url_host.sql))
This macro extracts a hostname from a column containing a url.

**Usage:**
```
{{ dbt_utils.get_url_host(field='page_url') }}
```

#### get_url_path ([source](macros/web/get_url_path.sql))
This macro extracts a page path from a column containing a url.

**Usage:**
```
{{ dbt_utils.get_url_path(field='page_url') }}
```
----
### Cross-database macros
These macros make it easier for package authors (especially those writing modeling packages) to implement cross-database
compatibility. In general, you should not use these macros in your own dbt project (unless it is a package)

#### current_timestamp ([source](macros/cross_db_utils/current_timestamp.sql))
This macro returns the current timestamp.

**Usage:**
```
{{ dbt_utils.current_timestamp() }}
```

#### dateadd ([source](macros/cross_db_utils/dateadd.sql))
This macro adds a time/day interval to the supplied date/timestamp. Note: The `datepart` argument is database-specific.

**Usage:**
```
{{ dbt_utils.dateadd(datepart='day', interval=1, from_date_or_timestamp="'2017-01-01'") }}
```

#### datediff ([source](macros/cross_db_utils/datediff.sql))
This macro calculates the difference between two dates.

**Usage:**
```
{{ dbt_utils.datediff("'2018-01-01'", "'2018-01-20'", 'day') }}
```

#### split_part ([source](macros/cross_db_utils/split_part.sql))
This macro splits a string of text using the supplied delimiter and returns the supplied part number (1-indexed).

**Usage:**
```
{{ dbt_utils.split_part(string_text='1,2,3', delimiter_text=',', part_number=1) }}
```

#### date_trunc ([source](macros/cross_db_utils/date_trunc.sql))
Truncates a date or timestamp to the specified datepart. Note: The `datepart` argument is database-specific.

**Usage:**
```
{{ dbt_utils.date_trunc(datepart, date) }}
```

#### last_day ([source](macros/cross_db_utils/last_day.sql))
Gets the last day for a given date and datepart. Notes:

- The `datepart` argument is database-specific.
- This macro currently only supports dateparts of `month` and `quarter`.

**Usage:**
```
{{ dbt_utils.last_day(date, datepart) }}
```

#### width_bucket ([source](macros/cross_db_utils/width_bucket.sql))
This macro is modeled after the `width_bucket` function natively available in Snowflake.

From the original Snowflake [documentation](https://docs.snowflake.net/manuals/sql-reference/functions/width_bucket.html):

Constructs equi-width histograms, in which the histogram range is divided into intervals of identical size, and returns the bucket number into which the value of an expression falls, after it has been evaluated. The function returns an integer value or null (if any input is null).
Notes:

**Args:**
- `expr`: The expression for which the histogram is created. This expression must evaluate to a numeric value or to a value that can be implicitly converted to a numeric value.

- `min_value` and `max_value`: The low and high end points of the acceptable range for the expression. The end points must also evaluate to numeric values and not be equal.

- `num_buckets`:  The desired number of buckets; must be a positive integer value. A value from the expression is assigned to each bucket, and the function then returns the corresponding bucket number.

When an expression falls outside the range, the function returns:
- `0` if the expression is less than min_value.
- `num_buckets + 1` if the expression is greater than or equal to max_value.


**Usage:**
```
{{ dbt_utils.width_bucket(expr, min_value, max_value, num_buckets) }}
```


---
### Jinja Helpers
#### pretty_time ([source](macros/jinja_helpers/pretty_time.sql))
This macro returns a string of the current timestamp, optionally taking a datestring format.
```sql
{#- This will return a string like '14:50:34' -#}
{{ dbt_utils.pretty_time() }}

{#- This will return a string like '2019-05-02 14:50:34' -#}
{{ dbt_utils.pretty_time(format='%Y-%m-%d %H:%M:%S') }}
```

#### pretty_log_format ([source](macros/jinja_helpers/pretty_log_format.sql))
This macro formats the input in a way that will print nicely to the command line when you `log` it.
```sql
{#- This will return a string like:
"11:07:31 + my pretty message"
-#}

{{ dbt_utils.pretty_log_format("my pretty message") }}
```
#### log_info ([source](macros/jinja_helpers/log_info.sql))
This macro logs a formatted message (with a timestamp) to the command line.
```sql
{{ dbt_utils.log_info("my pretty message") }}
```

```
11:07:28 | 1 of 1 START table model analytics.fct_orders........................ [RUN]
11:07:31 + my pretty message
```

#### slugify ([source](macros/jinja_helpers/slugify.sql))
This macro is useful for transforming Jinja strings into "slugs", and can be useful when using a Jinja object as a column name, especially when that Jinja object is not hardcoded.

For this example, let's pretend that we have payment methods in our payments table like `['venmo App', 'ca$h-money']`, which we can't use as a column name due to the spaces and special characters. This macro does its best to strip those out in a sensible way: `['venmo_app',
'cah_money']`.

```sql
{%- set payment_methods = dbt_utils.get_column_values(
    table=ref('raw_payments'),
    column='payment_method'
) -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{ payment_method }}' then amount end)
  as {{ slugify(payment_method) }}_amount,

{% endfor %}
...
```

```sql
select
order_id,

sum(case when payment_method = 'Venmo App' then amount end)
  as venmo_app_amount,

sum(case when payment_method = 'ca$h money' then amount end)
  as cah_money_amount,
...
```

### Materializations
#### insert_by_period ([source](macros/materializations/insert_by_period_materialization.sql))
`insert_by_period` allows dbt to insert records into a table one period (i.e. day, week) at a time.

This materialization is appropriate for event data that can be processed in discrete periods. It is similar in concept to the built-in incremental materialization, but has the added benefit of building the model in chunks even during a full-refresh so is particularly useful for models where the initial run can be problematic.

Should a run of a model using this materialization be interrupted, a subsequent run will continue building the target table from where it was interrupted (granted the `--full-refresh` flag is omitted).

Progress is logged in the command line for easy monitoring.

**Usage:**
```sql
{{
  config(
    materialized = "insert_by_period",
    period = "day",
    timestamp_field = "created_at",
    start_date = "2018-01-01",
    stop_date = "2018-06-01")
}}

with events as (

  select *
  from {{ ref('events') }}
  where __PERIOD_FILTER__ -- This will be replaced with a filter in the materialization code

)

....complex aggregates here....

```

**Configuration values:**
* `period`: period to break the model into, must be a valid [datepart](https://docs.aws.amazon.com/redshift/latest/dg/r_Dateparts_for_datetime_functions.html) (default='Week')
* `timestamp_field`: the column name of the timestamp field that will be used to break the model into smaller queries
* `start_date`: literal date or timestamp - generally choose a date that is earlier than the start of your data
* `stop_date`: literal date or timestamp (default=current_timestamp)

**Caveats:**
* This materialization is compatible with dbt 0.10.1.
* This materialization has been written for Redshift.
* This materialization can only be used for a model where records are not expected to change after they are created.
* Any model post-hooks that use `{{ this }}` will fail using this materialization. For example:
```yaml
models:
    project-name:
        post-hook: "grant select on {{ this }} to db_reader"
```
A useful workaround is to change the above post-hook to:
```yaml
        post-hook: "grant select on {{ this.schema }}.{{ this.name }} to db_reader"
```

----

### Contributing

We welcome contributions to this repo! To contribute a new feature or a fix, please open a Pull Request with 1) your changes, 2) updated documentation for the `README.md` file, and 3) a working integration test. See [this page](integration_tests/README.md) for more information.

----

### Dispatch macros

**Note:** This is primarily relevant to:
- Users and maintainers of community-supported [adapter plugins](https://docs.getdbt.com/docs/available-adapters)
- Users who wish to override a low-lying `dbt_utils` macro with a custom implementation, and have that implementation used by other `dbt_utils` macros

If you use Postgres, Redshift, Snowflake, or Bigquery, this likely does not apply to you.

dbt v0.18.0 introduced [`adapter.dispatch()`](https://docs.getdbt.com/reference/dbt-jinja-functions/adapter#dispatch), a reliable way to define different implementations of the same macro across different databases.

dbt v0.20.0 introduced a new project-level `dispatch` config that enables an "override" setting for all dispatched macros. If you set this config in your project, when dbt searches for implementations of a macro in the `dbt_utils` namespace, it will search through your list of packages instead of just looking in the `dbt_utils` package.

Set the config in `dbt_project.yml`:
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order:
      - first_package_to_search    # likely the name of your root project
      - second_package_to_search   # could be a "shim" package, such as spark_utils
      - dbt_utils                  # always include dbt_utils as the last place to search
```

If overriding a dispatched macro with a custom implementation in your own project's `macros/` directory, you must name your custom macro with a prefix: either `default__` (note the two underscores), or the name of your adapter followed by two underscores. For example, if you're running on Postgres and wish to override the behavior of `dbt_utils.datediff` (such that `dbt_utils.date_spine` will use your version instead), you can do this by defining a macro called either `default__datediff` or `postgres__datediff`.

Let's say we have the config defined above, and we're running on Spark. When dbt goes to dispatch `dbt_utils.datediff`, it will search for macros the following in order:
```
first_package_to_search.spark__datediff
first_package_to_search.default__datediff
second_package_to_search.spark__datediff
second_package_to_search.default__datediff
dbt_utils.spark__datediff
dbt_utils.default__datediff
```

----

### Getting started with dbt

- [What is dbt]?
- Read the [dbt viewpoint]
- [Installation]
- Join the [chat][slack-url] on Slack for live questions and support.


## Code of Conduct

Everyone interacting in the dbt project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [PyPA Code of Conduct].



[PyPA Code of Conduct]: https://www.pypa.io/en/latest/code-of-conduct/
[slack-url]: http://ac-slackin.herokuapp.com/
[Installation]: https://dbt.readme.io/docs/installation
[What is dbt]: https://dbt.readme.io/docs/overview
[dbt viewpoint]: https://dbt.readme.io/docs/viewpoint
