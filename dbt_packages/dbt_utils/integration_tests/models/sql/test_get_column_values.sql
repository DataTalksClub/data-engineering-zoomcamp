
{% set column_values = dbt_utils.get_column_values(ref('data_get_column_values'), 'field', default=[], order_by="field") %}


{% if target.type == 'snowflake' %}

select
    {% for val in column_values -%}

        sum(case when field = '{{ val }}' then 1 else 0 end) as count_{{ val }}
        {%- if not loop.last %},{% endif -%}

    {%- endfor %}

from {{ ref('data_get_column_values') }}

{% else %}

select
    {% for val in column_values -%}

        {{dbt_utils.safe_cast("sum(case when field = '" ~ val ~ "' then 1 else 0 end)", dbt_utils.type_string()) }} as count_{{ val }}
        {%- if not loop.last %},{% endif -%}

    {%- endfor %}

from {{ ref('data_get_column_values') }}

{% endif %}
