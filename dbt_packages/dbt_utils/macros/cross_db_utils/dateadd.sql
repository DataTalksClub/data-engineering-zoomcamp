{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ return(adapter.dispatch('dateadd', 'dbt_utils')(datepart, interval, from_date_or_timestamp)) }}
{% endmacro %}


{% macro default__dateadd(datepart, interval, from_date_or_timestamp) %}

    dateadd(
        {{ datepart }},
        {{ interval }},
        {{ from_date_or_timestamp }}
        )

{% endmacro %}


{% macro bigquery__dateadd(datepart, interval, from_date_or_timestamp) %}

        datetime_add(
            cast( {{ from_date_or_timestamp }} as datetime),
        interval {{ interval }} {{ datepart }}
        )

{% endmacro %}

{% macro postgres__dateadd(datepart, interval, from_date_or_timestamp) %}

    {{ from_date_or_timestamp }} + ((interval '1 {{ datepart }}') * ({{ interval }}))

{% endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__dateadd(datepart, interval, from_date_or_timestamp) %}

    {{ return(dbt_utils.default__dateadd(datepart, interval, from_date_or_timestamp)) }}

{% endmacro %}
