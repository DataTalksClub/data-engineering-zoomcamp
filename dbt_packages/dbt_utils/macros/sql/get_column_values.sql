{% macro get_column_values(table, column, order_by='count(*) desc', max_records=none, default=none) -%}
    {{ return(adapter.dispatch('get_column_values', 'dbt_utils')(table, column, order_by, max_records, default)) }}
{% endmacro %}

{% macro default__get_column_values(table, column, order_by='count(*) desc', max_records=none, default=none) -%}
{% if default is none %}
    {% set default = [] %}
{% endif %}
    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return(default) }}
    {% endif %}

    {# Not all relations are tables. Renaming for internal clarity without breaking functionality for anyone using named arguments #}
    {# TODO: Change the method signature in a future 0.x.0 release #}
    {%- set target_relation = table -%}

    {# adapter.load_relation is a convenience wrapper to avoid building a Relation when we already have one #}
    {% set relation_exists = (load_relation(target_relation)) is not none %}

    {%- call statement('get_column_values', fetch_result=true) %}

        {%- if not relation_exists and default is none -%}

          {{ exceptions.raise_compiler_error("In get_column_values(): relation " ~ target_relation ~ " does not exist and no default value was provided.") }}

        {%- elif not relation_exists and default is not none -%}

          {{ log("Relation " ~ target_relation ~ " does not exist. Returning the default value: " ~ default) }}

          {{ return(default) }}

        {%- else -%}


            select
                {{ column }} as value

            from {{ target_relation }}
            group by {{ column }}
            order by {{ order_by }}

            {% if max_records is not none %}
            limit {{ max_records }}
            {% endif %}

        {% endif %}

    {%- endcall -%}

    {%- set value_list = load_result('get_column_values') -%}

    {%- if value_list and value_list['data'] -%}
        {%- set values = value_list['data'] | map(attribute=0) | list %}
        {{ return(values) }}
    {%- else -%}
        {{ return(default) }}
    {%- endif -%}

{%- endmacro %}
