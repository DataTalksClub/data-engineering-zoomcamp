{% test accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true) %}
  {{ return(adapter.dispatch('test_accepted_range', 'dbt_utils')(model, column_name, min_value, max_value, inclusive)) }}
{% endtest %}

{% macro default__test_accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true) %}

with meet_condition as(
  select *
  from {{ model }}
),

validation_errors as (
  select *
  from meet_condition
  where
    -- never true, defaults to an empty result set. Exists to ensure any combo of the `or` clauses below succeeds
    1 = 2

  {%- if min_value is not none %}
    -- records with a value >= min_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not {{ column_name }} > {{- "=" if inclusive }} {{ min_value }}
  {%- endif %}

  {%- if max_value is not none %}
    -- records with a value <= max_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not {{ column_name }} < {{- "=" if inclusive }} {{ max_value }}
  {%- endif %}
)

select *
from validation_errors

{% endmacro %}
