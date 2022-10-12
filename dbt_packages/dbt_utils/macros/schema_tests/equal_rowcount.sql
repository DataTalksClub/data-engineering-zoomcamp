{% test equal_rowcount(model, compare_model) %}
  {{ return(adapter.dispatch('test_equal_rowcount', 'dbt_utils')(model, compare_model)) }}
{% endtest %}

{% macro default__test_equal_rowcount(model, compare_model) %}

{#-- Needs to be set at parse time, before we return '' below --#}
{{ config(fail_calc = 'coalesce(diff_count, 0)') }}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

with a as (

    select count(*) as count_a from {{ model }}

),
b as (

    select count(*) as count_b from {{ compare_model }}

),
final as (

    select
        count_a,
        count_b,
        abs(count_a - count_b) as diff_count
    from a
    cross join b

)

select * from final

{% endmacro %}
