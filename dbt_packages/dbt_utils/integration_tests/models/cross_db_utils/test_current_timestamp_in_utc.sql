
-- how can we test this better?
select
    {{ dbt_utils.current_timestamp_in_utc() }} as actual,
    {{ dbt_utils.current_timestamp_in_utc() }} as expected