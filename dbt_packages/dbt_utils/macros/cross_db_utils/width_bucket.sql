{% macro width_bucket(expr, min_value, max_value, num_buckets) %}
  {{ return(adapter.dispatch('width_bucket', 'dbt_utils') (expr, min_value, max_value, num_buckets)) }}
{% endmacro %}


{% macro default__width_bucket(expr, min_value, max_value, num_buckets) -%}

    {% set bin_size -%}
    (( {{ max_value }} - {{ min_value }} ) / {{ num_buckets }} )
    {%- endset %}
    (
        -- to break ties when the amount is eaxtly at the bucket egde
        case
            when
                mod(
                    {{ dbt_utils.safe_cast(expr, dbt_utils.type_numeric() ) }},
                    {{ dbt_utils.safe_cast(bin_size, dbt_utils.type_numeric() ) }}
                ) = 0
            then 1
            else 0
        end
    ) +
      -- Anything over max_value goes the N+1 bucket
    least(
        ceil(
            ({{ expr }} - {{ min_value }})/{{ bin_size }}
        ),
        {{ num_buckets }} + 1
    )
{%- endmacro %}

{% macro redshift__width_bucket(expr, min_value, max_value, num_buckets) -%}

    {% set bin_size -%}
    (( {{ max_value }} - {{ min_value }} ) / {{ num_buckets }} )
    {%- endset %}
    (
        -- to break ties when the amount is exactly at the bucket edge
        case
            when
                {{ dbt_utils.safe_cast(expr, dbt_utils.type_numeric() ) }} %
                {{ dbt_utils.safe_cast(bin_size, dbt_utils.type_numeric() ) }}
                 = 0
            then 1
            else 0
        end
    ) +
      -- Anything over max_value goes the N+1 bucket
    least(
        ceil(
            ({{ expr }} - {{ min_value }})/{{ bin_size }}
        ),
        {{ num_buckets }} + 1
    )
{%- endmacro %}

{% macro snowflake__width_bucket(expr, min_value, max_value, num_buckets) %}
    width_bucket({{ expr }}, {{ min_value }}, {{ max_value }}, {{ num_buckets }} )
{% endmacro %}
