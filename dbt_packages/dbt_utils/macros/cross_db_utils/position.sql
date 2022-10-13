{% macro position(substring_text, string_text) -%}
    {{ return(adapter.dispatch('position', 'dbt_utils') (substring_text, string_text)) }}
{% endmacro %}


{% macro default__position(substring_text, string_text) %}

    position(
        {{ substring_text }} in {{ string_text }}
    )
    
{%- endmacro -%}

{% macro bigquery__position(substring_text, string_text) %}

    strpos(
        {{ string_text }},
        {{ substring_text }}
        
    )
    
{%- endmacro -%}
