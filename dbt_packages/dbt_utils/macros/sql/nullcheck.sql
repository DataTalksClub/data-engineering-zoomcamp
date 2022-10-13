{% macro nullcheck(cols) %}
    {{ return(adapter.dispatch('nullcheck', 'dbt_utils')(cols)) }}
{% endmacro %}

{% macro default__nullcheck(cols) %}
{%- for col in cols %}

    {% if col.is_string() -%}

    nullif({{col.name}},'') as {{col.name}}

    {%- else -%}

    {{col.name}}

    {%- endif -%}

{%- if not loop.last -%} , {%- endif -%}

{%- endfor -%}
{% endmacro %}
