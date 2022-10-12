{% macro _is_ephemeral(obj, macro) %}
    {%- if obj.is_cte -%}
        {% set ephemeral_prefix = api.Relation.add_ephemeral_prefix('') %}
        {% if obj.name.startswith(ephemeral_prefix) %}
            {% set model_name = obj.name[(ephemeral_prefix|length):] %}
        {% else %}
            {% set model_name = obj.name %}
        {%- endif -%}
        {% set error_message %}
The `{{ macro }}` macro cannot be used with ephemeral models, as it relies on the information schema.

`{{ model_name }}` is an ephemeral model. Consider making it a view or table instead.
        {% endset %}
        {%- do exceptions.raise_compiler_error(error_message) -%}
    {%- endif -%}
{% endmacro %}
