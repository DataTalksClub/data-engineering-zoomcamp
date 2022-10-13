{%- macro safe_add() -%}
    {# needed for safe_add to allow for non-keyword arguments see SO post #}
    {# https://stackoverflow.com/questions/13944751/args-kwargs-in-jinja2-macros #}
    {% set frustrating_jinja_feature = varargs %}
    {{ return(adapter.dispatch('safe_add', 'dbt_utils')(*varargs)) }}
{% endmacro %}

{%- macro default__safe_add() -%}

{% set fields = [] %}

{%- for field in varargs -%}

    {% do fields.append("coalesce(" ~ field ~ ", 0)") %}

{%- endfor -%}

{{ fields|join(' +\n  ') }}

{%- endmacro -%}
