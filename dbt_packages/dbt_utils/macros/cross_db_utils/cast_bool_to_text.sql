{% macro cast_bool_to_text(field) %}
  {{ adapter.dispatch('cast_bool_to_text', 'dbt_utils') (field) }}
{% endmacro %}


{% macro default__cast_bool_to_text(field) %}
    cast({{ field }} as {{ dbt_utils.type_string() }})
{% endmacro %}

{% macro redshift__cast_bool_to_text(field) %}
    case
        when {{ field }} is true then 'true'
        when {{ field }} is false then 'false'
    end::text
{% endmacro %}
