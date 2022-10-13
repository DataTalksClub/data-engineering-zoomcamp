
-- snowflake messes with these tests pretty badly since the
-- output of the macro considers the casing of the source
-- table columns. Using some hacks here to get this to work,
-- but we should consider lowercasing the unpivot macro output
-- at some point in the future for consistency

{% if target.name == 'snowflake' %}
    {% set exclude = ['CUSTOMER_ID', 'CREATED_AT'] %}
{% else %}
    {% set exclude = ['customer_id', 'created_at'] %}
{% endif %}


select
    customer_id,
    created_at,
    case
        when '{{ target.name }}' = 'snowflake' then lower(prop)
        else prop
    end as prop,
    val

from (
    {{ dbt_utils.unpivot(
        relation=ref('data_unpivot_bool'),
        cast_to=dbt_utils.type_string(),
        exclude=exclude,
        field_name='prop',
        value_name='val'
    ) }}
) as sbq
