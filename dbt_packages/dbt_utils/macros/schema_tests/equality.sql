{% test equality(model, compare_model, compare_columns=None) %}
  {{ return(adapter.dispatch('test_equality', 'dbt_utils')(model, compare_model, compare_columns)) }}
{% endtest %}

{% macro default__test_equality(model, compare_model, compare_columns=None) %}

{% set set_diff %}
    count(*) + coalesce(abs(
        sum(case when which_diff = 'a_minus_b' then 1 else 0 end) -
        sum(case when which_diff = 'b_minus_a' then 1 else 0 end)
    ), 0)
{% endset %}

{#-- Needs to be set at parse time, before we return '' below --#}
{{ config(fail_calc = set_diff) }}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

-- setup
{%- do dbt_utils._is_relation(model, 'test_equality') -%}

{#-
If the compare_cols arg is provided, we can run this test without querying the
information schema — this allows the model to be an ephemeral model
-#}

{%- if not compare_columns -%}
    {%- do dbt_utils._is_ephemeral(model, 'test_equality') -%}
    {%- set compare_columns = adapter.get_columns_in_relation(model) | map(attribute='quoted') -%}
{%- endif -%}

{% set compare_cols_csv = compare_columns | join(', ') %}

with a as (

    select * from {{ model }}

),

b as (

    select * from {{ compare_model }}

),

a_minus_b as (

    select {{compare_cols_csv}} from a
    {{ dbt_utils.except() }}
    select {{compare_cols_csv}} from b

),

b_minus_a as (

    select {{compare_cols_csv}} from b
    {{ dbt_utils.except() }}
    select {{compare_cols_csv}} from a

),

unioned as (

    select 'a_minus_b' as which_diff, a_minus_b.* from a_minus_b
    union all
    select 'b_minus_a' as which_diff, b_minus_a.* from b_minus_a

)

select * from unioned

{% endmacro %}
