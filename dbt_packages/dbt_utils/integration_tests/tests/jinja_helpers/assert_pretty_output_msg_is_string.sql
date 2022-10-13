{% if dbt_utils.pretty_log_format() is string %}
    {# Return 0 rows for the test to pass #}
    select 1 as col_name {{ limit_zero() }}
{% else %}
    {# Return >0 rows for the test to fail #}
    select 1
{% endif %}
