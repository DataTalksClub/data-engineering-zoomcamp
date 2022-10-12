{% macro _is_relation(obj, macro) %}
    {%- if not (obj is mapping and obj.get('metadata', {}).get('type', '').endswith('Relation')) -%}
        {%- do exceptions.raise_compiler_error("Macro " ~ macro ~ " expected a Relation but received the value: " ~ obj) -%}
    {%- endif -%}
{% endmacro %}
