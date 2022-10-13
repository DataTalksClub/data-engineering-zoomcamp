# dbt-utils v0.8.0
## 🚨 Breaking changes
- dbt ONE POINT OH is here! This version of dbt-utils requires _any_ version (minor and patch) of v1, which means far less need for compatibility releases in the future. 
- The partition column in the `mutually_exclusive_ranges` test is now always called `partition_by_col`. This enables compatibility with `--store-failures` when multiple columns are concatenated together. If you have models built on top of the failures table, update them to reflect the new column name. ([#423](https://github.com/dbt-labs/dbt-utils/issues/423), [#430](https://github.com/dbt-labs/dbt-utils/pull/430))

## Contributors:
- [codigo-ergo-sum](https://github.com/codigo-ergo-sum) (#430)

# dbt-utils 0.7.5
🚨 This is a compatibility release in preparation for `dbt-core` v1.0.0 (🎉). Projects using dbt-utils 0.7.4 with dbt-core v1.0.0 can expect to see a deprecation warning. This will be resolved in dbt_utils v0.8.0.

## Fixes
- Regression in `get_column_values()` where the default would not be respected if the model didn't exist. ([#444](https://github.com/dbt-labs/dbt-utils/issues/444), [#448](https://github.com/dbt-labs/dbt-utils/pull/448))

## Under the hood
- get_url_host() macro now correctly handles URLs beginning with android-app:// (#426)

## Contributors:
- [foundinblank](https://github.com/foundinblank)

# dbt-utils v0.7.4
## Fixes
- `get_column_values()` now works correctly with mixed-quoting styles on Snowflake ([#424](https://github.com/dbt-labs/dbt-utils/issues/424), [#440](https://github.com/dbt-labs/dbt-utils/pull/440))
- Remove extra semicolon in `insert_by_period` materialization that was causing errors ([#439](https://github.com/dbt-labs/dbt-utils/pull/439))
- Swap `limit 0` out for `{{ limit_zero() }}` on the `slugify()` tests to allow for compatibility with [tsql-utils](https://github.com/dbt-msft/tsql-utils) ([#437](https://github.com/dbt-labs/dbt-utils/pull/437))

## Contributors:
- [sean-rose](https://github.com/sean-rose)
- [@swanderz](https://github.com/swanderz)


# dbt-utils v0.7.4b1
:rotating_light:🚨 We have renamed the `master` branch to `main`. If you have a local version of `dbt-utils`, you will need to update to the new branch. See the [GitHub docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/renaming-a-branch#updating-a-local-clone-after-a-branch-name-changes) for more details.

## Under the hood
- Bump `require-dbt-version` to have an upper bound of `'<=1.0.0'`.
- Url link fixes within the README for `not_constant`, `dateadd`, `datediff` and updated the header `Logger` to `Jinja Helpers`. ([#431](https://github.com/dbt-labs/dbt-utils/pull/431))
- Fully qualified a `cte_name.*` in the `equality` test to avoid an Exasol error ([#420](https://github.com/dbt-labs/dbt-utils/pull/420))
- `get_url_host()` macro now correctly handles URLs beginning with `android-app://` ([#426](https://github.com/dbt-labs/dbt-utils/pull/426))

## Contributors:
- [joemarkiewicz](https://github.com/fivetran-joemarkiewicz)
- [TimoKruth](https://github.com/TimoKruth)
- [foundinblank](https://github.com/foundinblank)

# dbt-utils v0.7.3

## Under the hood

- Fix bug introduced in 0.7.2 in dbt_utils.star which could cause the except argument to drop columns that were not explicitly specified ([#418](https://github.com/dbt-labs/dbt-utils/pull/418))
- Remove deprecated argument from not_null_proportion ([#416](https://github.com/dbt-labs/dbt-utils/pull/416))
- Change final select statement in not_null_proportion to avoid false positive failures ([#416](https://github.com/dbt-labs/dbt-utils/pull/416))

# dbt-utils v0.7.2

## Features

- Add `not_null_proportion` schema test that allows the user to specify the minimum (`at_least`) tolerated proportion (e.g., `0.95`) of non-null values ([#411](https://github.com/dbt-labs/dbt-utils/pull/411))


## Under the hood
- Allow user to provide any case type when defining the `exclude` argument in `dbt_utils.star()` ([#403](https://github.com/dbt-labs/dbt-utils/pull/403))
- Log whole row instead of just column name in 'accepted_range' schema test to allow better visibility into failures ([#413](https://github.com/dbt-labs/dbt-utils/pull/413))
- Use column name to group in 'get_column_values ' to allow better cross db functionality ([#407](https://github.com/dbt-labs/dbt-utils/pull/407))

# dbt-utils v0.7.1

## Under the hood

- Declare compatibility with dbt v0.21.0, which has no breaking changes for this package ([#398](https://github.com/fishtown-analytics/dbt-utils/pull/398))


# dbt-utils v0.7.0
## Breaking changes

### 🚨 New dbt version

dbt v0.20.0 or greater is required for this release. If you are not ready to upgrade, consider using a previous release of this package.

In accordance with the version upgrade, this package release includes breaking changes to:
- Generic (schema) tests
- `dispatch` functionality

### 🚨 get_column_values
The order of (optional) arguments has changed in the `get_column_values` macro.

Before:
```jinja
{% macro get_column_values(table, column, order_by='count(*) desc', max_records=none, default=none) -%}
...
{% endmacro %}
```

After:
```jinja
{% macro get_column_values(table, column, max_records=none, default=none) -%}
...
{% endmacro %}
```
If you were relying on the position to match up your optional arguments, this may be a breaking change — in general, we recommend that you explicitly declare any optional arguments (if not all of your arguments!)
```
-- before: This works on previous version of dbt-utils, but on 0.7.0, the `50` would be passed through as the `order_by` argument
{% set payment_methods = dbt_utils.get_column_values(
        ref('stg_payments'),
        'payment_method',
        50
) %}

-- after
{% set payment_methods = dbt_utils.get_column_values(
        ref('stg_payments'),
        'payment_method',
        max_records=50
) %}
```

## Features
* Add new argument, `order_by`, to `get_column_values` (code originally in [#289](https://github.com/fishtown-analytics/dbt-utils/pull/289/) from [@clausherther](https://github.com/clausherther), merged via [#349](https://github.com/fishtown-analytics/dbt-utils/pull/349/))
* Add `slugify` macro, and use it in the pivot macro. :rotating_light: This macro uses the `re` module, which is only available in dbt v0.19.0+. As a result, this feature introduces a breaking change. ([#314](https://github.com/fishtown-analytics/dbt-utils/pull/314))
* Add `not_null_proportion` schema test that allows the user to specify the minimum (`at_least`) tolerated proportion (e.g., `0.95`) of non-null values

## Under the hood
* Update the default implementation of concat macro to use `||` operator ([#373](https://github.com/fishtown-analytics/dbt-utils/pull/314) from [@ChristopheDuong](https://github.com/ChristopheDuong)). Note this may be a breaking change for adapters that support `concat()` but not `||`, such as Apache Spark.
- Use `power()` instead of `pow()` in `generate_series()` and `haversine_distance()` as they are synonyms in most SQL dialects, but some dialects only have `power()` ([#354](https://github.com/fishtown-analytics/dbt-utils/pull/354) from [@swanderz](https://github.com/swanderz))
- Make `get_column_values` return the default value passed as a parameter instead of an empty string before compilation ([#304](https://github.com/dbt-labs/dbt-utils/pull/386) from [@jmriego](https://github.com/jmriego)

# dbt-utils v0.6.6

## Fixes

- make `sequential_values` schema test use `dbt_utils.type_timestamp()` to allow for compatibility with db's without timestamp data type. [#376](https://github.com/fishtown-analytics/dbt-utils/pull/376) from [@swanderz](https://github.com/swanderz)

# dbt-utils v0.6.5
## Features
* Add new `accepted_range` test ([#276](https://github.com/fishtown-analytics/dbt-utils/pull/276) [@joellabes](https://github.com/joellabes))
* Make `expression_is_true` work as a column test (code originally in [#226](https://github.com/fishtown-analytics/dbt-utils/pull/226/) from [@elliottohara](https://github.com/elliottohara), merged via [#313](https://github.com/fishtown-analytics/dbt-utils/pull/313/))
* Add new schema test, `not_accepted_values` ([#284](https://github.com/fishtown-analytics/dbt-utils/pull/284) [@JavierMonton](https://github.com/JavierMonton))
* Support a new argument, `zero_length_range_allowed` in the `mutually_exclusive_ranges` test ([#307](https://github.com/fishtown-analytics/dbt-utils/pull/307) [@zemekeneng](https://github.com/zemekeneng))
* Add new schema test, `sequential_values` ([#318](https://github.com/fishtown-analytics/dbt-utils/pull/318), inspired by [@hundredwatt](https://github.com/hundredwatt))
* Support `quarter` in the `postgres__last_day` macro ([#333](https://github.com/fishtown-analytics/dbt-utils/pull/333/files) [@seunghanhong](https://github.com/seunghanhong))
* Add new argument, `unit`, to `haversine_distance` ([#340](https://github.com/fishtown-analytics/dbt-utils/pull/340) [@bastienboutonnet](https://github.com/bastienboutonnet))
* Add new schema test, `fewer_rows_than` (code originally in [#221](https://github.com/fishtown-analytics/dbt-utils/pull/230/) from [@dmarts](https://github.com/dmarts), merged via [#343](https://github.com/fishtown-analytics/dbt-utils/pull/343/))

## Fixes
* Handle booleans gracefully in the unpivot macro ([#305](https://github.com/fishtown-analytics/dbt-utils/pull/305) [@avishalom](https://github.com/avishalom))
* Fix a bug in `get_relation_by_prefix` that happens with Snowflake external tables. Now the macro will retrieve tables that match the prefix which are external tables ([#351](https://github.com/fishtown-analytics/dbt-utils/pull/351))
* Fix `cardinality_equality` test when the two tables' column names differed ([#334](https://github.com/fishtown-analytics/dbt-utils/pull/334) [@joellabes](https://github.com/joellabes))

## Under the hood
* Fix Markdown formatting for hub rendering ([#336](https://github.com/fishtown-analytics/dbt-utils/issues/350) [@coapacetic](https://github.com/coapacetic))
* Reorder readme and improve docs

# dbt-utils v0.6.4

### Fixes
- Fix `insert_by_period` to support `dbt v0.19.0`, with backwards compatibility for earlier versions ([#319](https://github.com/fishtown-analytics/dbt-utils/pull/319), [#320](https://github.com/fishtown-analytics/dbt-utils/pull/320))

### Under the hood
- Speed up CI via threads, workflows ([#315](https://github.com/fishtown-analytics/dbt-utils/pull/315), [#316](https://github.com/fishtown-analytics/dbt-utils/pull/316))
- Fix `equality` test when used with ephemeral models + explicit column set ([#321](https://github.com/fishtown-analytics/dbt-utils/pull/321))
- Fix `get_query_results_as_dict` integration test with consistent ordering ([#322](https://github.com/fishtown-analytics/dbt-utils/pull/322))
- All macros are now properly dispatched, making it possible for non-core adapters to implement a shim package for dbt-utils ([#312](https://github.com/fishtown-analytics/dbt-utils/pull/312)) Thanks [@chaerinlee1](https://github.com/chaerinlee1) and [@swanderz](https://github.com/swanderz)
- Small, non-breaking changes to accomodate TSQL (can't group by column number references, no real TRUE/FALSE values, aggregation CTEs need named columns) ([#310](https://github.com/fishtown-analytics/dbt-utils/pull/310)) Thanks [@swanderz](https://github.com/swanderz)
- Make `get_relations_by_pattern` and `get_relations_by_prefix` more powerful by returning `relation.type` ([#323](https://github.com/fishtown-analytics/dbt-utils/pull/323))

# dbt-utils v0.6.3

- Bump `require-dbt-version` to `[">=0.18.0", "<0.20.0"]` to support dbt v0.19.0 ([#308](https://github.com/fishtown-analytics/dbt-utils/pull/308), [#309](https://github.com/fishtown-analytics/dbt-utils/pull/309))

# dbt-utils v0.6.2

## Fixes
- Fix the logic in `get_tables_by_pattern_sql` to ensure non-default arguments are respected ([#279](https://github.com/fishtown-analytics/dbt-utils/pull/279))


# dbt-utils v0.6.1

## Fixes
- Fix the logic in `get_tables_by_pattern_sql` for matching a schema pattern on BigQuery ([#275](https://github.com/fishtown-analytics/dbt-utils/pull/275/))

# dbt-utils v0.6.0

## Breaking changes
- :rotating_light: dbt v0.18.0 or greater is required for this release. If you are not ready to upgrade, consider using a previous release of this package
- :rotating_light: The `get_tables_by_prefix`, `union_tables` and `get_tables_by_pattern` macros have been removed

## Migration instructions
- Upgrade your dbt project to v0.18.0 using [these instructions](https://discourse.getdbt.com/t/prerelease-v0-18-0-marian-anderson/1545).
- Upgrade your `packages.yml` file to use version `0.6.0` of this package. Run `dbt clean` and `dbt deps`.
- If your project uses the `get_tables_by_prefix` macro, replace it with `get_relations_by_prefix`. All arguments have retained the same name.
- If your project uses the `union_tables` macro, replace it with `union_relations`. While the order of arguments has stayed consistent, the `tables` argument has been renamed to `relations`. Further, the default value for the `source_column_name` argument has changed from `'_dbt_source_table'` to `'_dbt_source_relation'` — you may want to explicitly define this argument to avoid breaking changes.

```
-- before:
{{ dbt_utils.union_tables(
    tables=[ref('my_model'), source('my_source', 'my_table')],
    exclude=["_loaded_at"]
) }}

-- after:
{{ dbt_utils.union_relations(
    relations=[ref('my_model'), source('my_source', 'my_table')],
    exclude=["_loaded_at"],
    source_column_name='_dbt_source_table'
) }}
```
- If your project uses the `get_tables_by_pattern` macro, replace it with `get_tables_by_pattern_sql` — all arguments are consistent.

## Features

* Switch usage of `adapter_macro` to `adapter.dispatch`, and define `dbt_utils_dispatch_list`,
enabling users of community-supported database plugins to add or override macro implementations
specific to their database ([#267](https://github.com/fishtown-analytics/dbt-utils/pull/267))
* Use `add_ephemeral_prefix` instead of hard-coding a string literal, to support
database adapters that use different prefixes ([#267](https://github.com/fishtown-analytics/dbt-utils/pull/267))
* Implement a quote_columns argument in the unique_combination_of_columns schema test ([#270](https://github.com/fishtown-analytics/dbt-utils/pull/270) [@JoshuaHuntley](https://github.com/JoshuaHuntley))

## Quality of life
* Remove deprecated macros `get_tables_by_prefix` and `union_tables` ([#268](https://github.com/fishtown-analytics/dbt-utils/pull/268))
* Remove `get_tables_by_pattern` macro, which is equivalent to the `get_tables_by_pattern_sql` macro (the latter has a more logical name) ([#268](https://github.com/fishtown-analytics/dbt-utils/pull/268))

# dbt-utils v0.5.1

## Quality of life
* Improve release process, and fix tests ([#251](https://github.com/fishtown-analytics/dbt-utils/pull/251))
* Make deprecation warnings more useful ([#258](https://github.com/fishtown-analytics/dbt-utils/pull/258) [@tayloramurphy](https://github.com/tayloramurphy))
* Add more docs for `date_spine` ([#265](https://github.com/fishtown-analytics/dbt-utils/pull/265) [@calvingiles](https://github.com/calvingiles))
