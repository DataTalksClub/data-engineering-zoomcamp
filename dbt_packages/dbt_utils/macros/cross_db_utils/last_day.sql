/*
This function has been tested with dateparts of month and quarters. Further
testing is required to validate that it will work on other dateparts.
*/

{% macro last_day(date, datepart) %}
  {{ return(adapter.dispatch('last_day', 'dbt_utils') (date, datepart)) }}
{% endmacro %}


{%- macro default_last_day(date, datepart) -%}
    cast(
        {{dbt_utils.dateadd('day', '-1',
        dbt_utils.dateadd(datepart, '1', dbt_utils.date_trunc(datepart, date))
        )}}
        as date)
{%- endmacro -%}


{% macro default__last_day(date, datepart) -%}
    {{dbt_utils.default_last_day(date, datepart)}}
{%- endmacro %}


{% macro postgres__last_day(date, datepart) -%}

    {%- if datepart == 'quarter' -%}
    -- postgres dateadd does not support quarter interval.
    cast(
        {{dbt_utils.dateadd('day', '-1',
        dbt_utils.dateadd('month', '3', dbt_utils.date_trunc(datepart, date))
        )}}
        as date)
    {%- else -%}
    {{dbt_utils.default_last_day(date, datepart)}}
    {%- endif -%}

{%- endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__last_day(date, datepart) %}

    {{ return(dbt_utils.default__last_day(date, datepart)) }}

{% endmacro %}
