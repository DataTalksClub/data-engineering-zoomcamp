{% macro intersect() %}
  {{ return(adapter.dispatch('intersect', 'dbt_utils')()) }}
{% endmacro %}


{% macro default__intersect() %}

    intersect

{% endmacro %}

{% macro bigquery__intersect() %}

    intersect distinct

{% endmacro %}
