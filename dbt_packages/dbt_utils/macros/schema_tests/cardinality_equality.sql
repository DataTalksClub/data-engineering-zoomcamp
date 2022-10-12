{% test cardinality_equality(model, column_name, to, field) %}
    {{ return(adapter.dispatch('test_cardinality_equality', 'dbt_utils')(model, column_name, to, field)) }}
{% endtest %}

{% macro default__test_cardinality_equality(model, column_name, to, field) %}

{# T-SQL does not let you use numbers as aliases for columns #}
{# Thus, no "GROUP BY 1" #}

with table_a as (
select
  {{ column_name }},
  count(*) as num_rows
from {{ model }}
group by {{ column_name }}
),

table_b as (
select
  {{ field }},
  count(*) as num_rows
from {{ to }}
group by {{ field }}
),

except_a as (
  select *
  from table_a
  {{ dbt_utils.except() }}
  select *
  from table_b
),

except_b as (
  select *
  from table_b
  {{ dbt_utils.except() }}
  select *
  from table_a
),

unioned as (
  select *
  from except_a
  union all
  select *
  from except_b
)

select *
from unioned

{% endmacro %}
