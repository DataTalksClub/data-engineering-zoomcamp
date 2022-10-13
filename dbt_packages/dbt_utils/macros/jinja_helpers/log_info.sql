{% macro log_info(message) %}
    {{ return(adapter.dispatch('log_info', 'dbt_utils')(message)) }}
{% endmacro %}

{% macro default__log_info(message) %}
    {{ log(dbt_utils.pretty_log_format(message), info=True) }}
{% endmacro %}
