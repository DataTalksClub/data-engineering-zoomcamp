

{% macro concat(fields) -%}
  {{ return(adapter.dispatch('concat', 'dbt_utils')(fields)) }}
{%- endmacro %}

{% macro default__concat(fields) -%}
    {{ fields|join(' || ') }}
{%- endmacro %}
