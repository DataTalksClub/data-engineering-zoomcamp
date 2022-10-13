{% macro identifier(value) %}	
  {%- set error_message = '
    Warning: the `identifier` macro is no longer supported and will be deprecated in a future release of dbt-utils. \
    Use `adapter.quote` instead. The {}.{} model triggered this warning. \
    '.format(model.package_name, model.name) -%}
  {%- do exceptions.warn(error_message) -%}
  {{ return(adapter.dispatch('identifier', 'dbt_utils') (value)) }}
{% endmacro %}	

{% macro default__identifier(value) -%}	
    "{{ value }}"	
{%- endmacro %}	

{% macro bigquery__identifier(value) -%}	
    `{{ value }}`	
{%- endmacro %}
