{% macro replace(field, old_chars, new_chars) -%}
    {{ return(adapter.dispatch('replace', 'dbt_utils') (field, old_chars, new_chars)) }}
{% endmacro %}


{% macro default__replace(field, old_chars, new_chars) %}

    replace(
        {{ field }},
        {{ old_chars }},
        {{ new_chars }}
    )
    

{% endmacro %}