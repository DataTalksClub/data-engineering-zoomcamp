
-- TODO: How do we make this work nicely on Snowflake too?

{% if target.type == 'snowflake' %}
    {% set column_values = ['RED', 'BLUE'] %}
    {% set cmp = 'ilike' %}
{% else %}
    {% set column_values = ['red', 'blue'] %}
    {% set cmp = '=' %}
{% endif %}

select
    size,
    {{ dbt_utils.pivot('color', column_values, cmp=cmp) }}

from {{ ref('data_pivot') }}
group by size
