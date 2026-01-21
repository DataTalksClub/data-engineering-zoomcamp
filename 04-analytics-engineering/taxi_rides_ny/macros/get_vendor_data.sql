{#
    Macro to generate vendor lookup data using Jinja dictionary.

    This approach works seamlessly across BigQuery, DuckDB, Snowflake, etc.
    by generating UNION ALL statements at compile time.

    Returns: SQL that creates vendor rows with vendor_id and vendor_name
#}

{% macro get_vendor_data() %}

{% set vendors = {
    1: 'Creative Mobile Technologies',
    2: 'VeriFone Inc.',
    4: 'Unknown/Other'
} %}

{% for vendor_id, vendor_name in vendors.items() %}
    select {{ vendor_id }} as vendor_id, '{{ vendor_name }}' as vendor_name
    {% if not loop.last %}union all{% endif %}
{% endfor %}

{% endmacro %}
