{% test recency(model, field, datepart, interval) %}
  {{ return(adapter.dispatch('test_recency', 'dbt_utils')(model, field, datepart, interval)) }}
{% endtest %}

{% macro default__test_recency(model, field, datepart, interval) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}

with recency as (

    select max({{field}}) as most_recent
    from {{ model }}

)

select

    most_recent,
    {{ threshold }} as threshold

from recency
where most_recent < {{ threshold }}

{% endmacro %}
