
{% if target.type == 'postgres' %}

select
    {{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as today

{% else %}

select
    cast({{ dbt_utils.date_trunc('day', dbt_utils.current_timestamp()) }} as datetime) as today
    
{% endif %}
