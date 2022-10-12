{% test fewer_rows_than(model, compare_model) %}
  {{ return(adapter.dispatch('test_fewer_rows_than', 'dbt_utils')(model, compare_model)) }}
{% endtest %}

{% macro default__test_fewer_rows_than(model, compare_model) %}

{{ config(fail_calc = 'coalesce(row_count_delta, 0)') }}

with a as (

    select count(*) as count_our_model from {{ model }}

),
b as (

    select count(*) as count_comparison_model from {{ compare_model }}

),
counts as (

    select
        count_our_model,
        count_comparison_model
    from a
    cross join b

),
final as (

    select *,
        case
            -- fail the test if we have more rows than the reference model and return the row count delta
            when count_our_model > count_comparison_model then (count_our_model - count_comparison_model)
            -- fail the test if they are the same number
            when count_our_model = count_comparison_model then 1
            -- pass the test if the delta is positive (i.e. return the number 0)
            else 0
    end as row_count_delta
    from counts

)

select * from final

{% endmacro %}
