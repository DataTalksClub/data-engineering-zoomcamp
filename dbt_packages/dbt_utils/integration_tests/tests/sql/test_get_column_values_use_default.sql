
{% set column_values = dbt_utils.get_column_values(ref('data_get_column_values_dropped'), 'field', default=['y', 'z'], order_by="field") %}

with expected as (
    select {{ dbt_utils.safe_cast("'y'", dbt_utils.type_string()) }} as expected_column_value union all
    select {{ dbt_utils.safe_cast("'z'", dbt_utils.type_string()) }} as expected_column_value
),

actual as (
     
        {% for val in column_values %}
            select {{ dbt_utils.safe_cast("'" ~ val ~ "'", dbt_utils.type_string()) }} as actual_column_value
            {% if not loop.last %}
                union all
            {% endif %}
        {% endfor %}
),

failures as (
    select * from actual
    where actual.actual_column_value not in (
        select expected.expected_column_value from expected
    )
)

select * from failures