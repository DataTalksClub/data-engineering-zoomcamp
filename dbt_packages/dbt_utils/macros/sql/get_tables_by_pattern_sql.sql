{% macro get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}
    {{ return(adapter.dispatch('get_tables_by_pattern_sql', 'dbt_utils')
        (schema_pattern, table_pattern, exclude, database)) }}
{% endmacro %}

{% macro default__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}

        select distinct
            table_schema as "table_schema",
            table_name as "table_name",
            case table_type
                when 'BASE TABLE' then 'table'
                when 'EXTERNAL TABLE' then 'external'
                when 'MATERIALIZED VIEW' then 'materializedview'
                else lower(table_type)
            end as "table_type"
        from {{ database }}.information_schema.tables
        where table_schema ilike '{{ schema_pattern }}'
        and table_name ilike '{{ table_pattern }}'
        and table_name not ilike '{{ exclude }}'

{% endmacro %}


{% macro bigquery__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}

    {% if '%' in schema_pattern %}
        {% set schemata=dbt_utils._bigquery__get_matching_schemata(schema_pattern, database) %}
    {% else %}
        {% set schemata=[schema_pattern] %}
    {% endif %}

    {% set sql %}
        {% for schema in schemata %}
            select distinct
                table_schema,
                table_name,
                case table_type
                    when 'BASE TABLE' then 'table'
                    else lower(table_type)
                end as table_type

            from {{ adapter.quote(database) }}.{{ schema }}.INFORMATION_SCHEMA.TABLES
            where lower(table_name) like lower ('{{ table_pattern }}')
                and lower(table_name) not like lower ('{{ exclude }}')

            {% if not loop.last %} union all {% endif %}

        {% endfor %}
    {% endset %}

    {{ return(sql) }}

{% endmacro %}


{% macro _bigquery__get_matching_schemata(schema_pattern, database) %}
    {% if execute %}

        {% set sql %}
        select schema_name from {{ adapter.quote(database) }}.INFORMATION_SCHEMA.SCHEMATA
        where lower(schema_name) like lower('{{ schema_pattern }}')
        {% endset %}

        {% set results=run_query(sql) %}

        {% set schemata=results.columns['schema_name'].values() %}

        {{ return(schemata) }}

    {% else %}

        {{ return([]) }}

    {% endif %}


{% endmacro %}
