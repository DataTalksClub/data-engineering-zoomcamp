{% macro get_intervals_between(start_date, end_date, datepart) -%}
    {{ return(adapter.dispatch('get_intervals_between', 'dbt_utils')(start_date, end_date, datepart)) }}
{%- endmacro %}

{% macro default__get_intervals_between(start_date, end_date, datepart) -%}
    {%- call statement('get_intervals_between', fetch_result=True) %}

        select {{dbt_utils.datediff(start_date, end_date, datepart)}}

    {%- endcall -%}

    {%- set value_list = load_result('get_intervals_between') -%}

    {%- if value_list and value_list['data'] -%}
        {%- set values = value_list['data'] | map(attribute=0) | list %}
        {{ return(values[0]) }}
    {%- else -%}
        {{ return(1) }}
    {%- endif -%}

{%- endmacro %}




{% macro date_spine(datepart, start_date, end_date) %}
    {{ return(adapter.dispatch('date_spine', 'dbt_utils')(datepart, start_date, end_date)) }}
{%- endmacro %}

{% macro default__date_spine(datepart, start_date, end_date) %}

/*
call as follows:

date_spine(
    "day",
    "to_date('01/01/2016', 'mm/dd/yyyy')",
    "dateadd(week, 1, current_date)"
)

*/

with rawdata as (

    {{dbt_utils.generate_series(
        dbt_utils.get_intervals_between(start_date, end_date, datepart)
    )}}

),

all_periods as (

    select (
        {{
            dbt_utils.dateadd(
                datepart,
                "row_number() over (order by 1) - 1",
                start_date
            )
        }}
    ) as date_{{datepart}}
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_{{datepart}} <= {{ end_date }}

)

select * from filtered

{% endmacro %}
