
-- unpivot() was enhanced with 3 new parameters
-- This test targets the original API.

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
        when '{{ target.name }}' = 'snowflake' then lower(FIELD_NAME)
        else field_name
    end as field_name,
    value

from (
    {{ dbt_utils.unpivot(
        table=ref('data_unpivot'),
        cast_to=dbt_utils.type_string(),
        exclude=exclude
    ) }}
) as sbq
