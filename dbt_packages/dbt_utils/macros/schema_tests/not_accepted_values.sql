{% test not_accepted_values(model, column_name, values, quote=True) %}
  {{ return(adapter.dispatch('test_not_accepted_values', 'dbt_utils')(model, column_name, values, quote)) }}
{% endtest %}

{% macro default__test_not_accepted_values(model, column_name, values, quote=True) %}
with all_values as (

    select distinct
        {{ column_name }} as value_field

    from {{ model }}

),

validation_errors as (

    select
        value_field

    from all_values
    where value_field in (
        {% for value in values -%}
            {% if quote -%}
            '{{ value }}'
            {%- else -%}
            {{ value }}
            {%- endif -%}
            {%- if not loop.last -%},{%- endif %}
        {%- endfor %}
        )

)

select *
from validation_errors

{% endmacro %}
