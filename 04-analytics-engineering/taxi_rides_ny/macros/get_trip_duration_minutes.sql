{#
    Calculate trip duration in minutes from pickup and dropoff timestamps.

    Uses dbts built-in cross-database datediff macro.
    This works seamlessly across DuckDB, BigQuery, Snowflake, Redshift, PostgreSQL, etc.

    Returns: Trip duration as a numeric value in minutes
#}

{% macro get_trip_duration_minutes(pickup_datetime, dropoff_datetime) %}
    {{ dbt.datediff(pickup_datetime, dropoff_datetime, 'minute') }}
{% endmacro %}
