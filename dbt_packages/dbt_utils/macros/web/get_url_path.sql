{% macro get_url_path(field) -%}
    {{ return(adapter.dispatch('get_url_path', 'dbt_utils')(field)) }}
{% endmacro %}

{% macro default__get_url_path(field) -%}

    {%- set stripped_url = 
        dbt_utils.replace(
            dbt_utils.replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set first_slash_pos -%}
        coalesce(
            nullif({{dbt_utils.position("'/'", stripped_url)}}, 0),
            {{dbt_utils.position("'?'", stripped_url)}} - 1
            )
    {%- endset -%}

    {%- set parsed_path =
        dbt_utils.split_part(
            dbt_utils.right(
                stripped_url, 
                dbt_utils.length(stripped_url) ~ "-" ~ first_slash_pos
                ), 
            "'?'", 1
            )
    -%}

    {{ dbt_utils.safe_cast(
        parsed_path,
        dbt_utils.type_string()
    )}}
    
{%- endmacro %}
