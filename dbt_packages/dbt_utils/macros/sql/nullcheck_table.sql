{% macro nullcheck_table(relation) %}
    {{ return(adapter.dispatch('nullcheck_table', 'dbt_utils')(relation)) }}
{% endmacro %}

{% macro default__nullcheck_table(relation) %}

  {%- do dbt_utils._is_relation(relation, 'nullcheck_table') -%}
  {%- do dbt_utils._is_ephemeral(relation, 'nullcheck_table') -%}
  {% set cols = adapter.get_columns_in_relation(relation) %}

  select {{ dbt_utils.nullcheck(cols) }}
  from {{relation}}

{% endmacro %}
