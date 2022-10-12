-- depends_on: {{ ref('data_get_query_results_as_dict') }}

{% set expected_dictionary={
    'col_1': [1, 2, 3],
    'col_2': ['a', 'b', 'c'],
    'col_3': [True, False, none]
} %}

{#- Handle snowflake casing silliness -#}
{% if target.type == 'snowflake' %}
{% set expected_dictionary={
    'COL_1': [1, 2, 3],
    'COL_2': ['a', 'b', 'c'],
    'COL_3': [True, False, none]
} %}
{% endif %}


{% set actual_dictionary=dbt_utils.get_query_results_as_dict(
    "select * from " ~ ref('data_get_query_results_as_dict') ~ " order by 1"
) %}
{#-
For reasons that remain unclear, Jinja won't return True for actual_dictionary == expected_dictionary.
Instead, we'll manually check that the values of these dictionaries are equivalent.
-#}

{% set ns = namespace(
    pass=True,
    err_msg = ""
) %}
{% if execute %}
{#- Check that the dictionaries have the same keys -#}
{% set expected_keys=expected_dictionary.keys() | list | sort %}
{% set actual_keys=actual_dictionary.keys() | list | sort %}

{% if expected_keys != actual_keys %}
    {% set ns.pass=False %}
    {% set ns.err_msg %}
    The two dictionaries have different keys:
      expected_dictionary has keys: {{ expected_keys }}
      actual_dictionary has keys: {{ actual_keys }}
    {% endset %}

{% else %}

{% for key, value in expected_dictionary.items() %}
    {% set expected_length=expected_dictionary[key] | length %}
    {% set actual_length=actual_dictionary[key] | length %}

    {% if expected_length != actual_length %}
        {% set ns.pass=False %}
        {% set ns.err_msg %}
    The {{ key }} column has different lengths:
      expected_dictionary[{{ key }}] has length {{ expected_length }}
      actual_dictionary[{{ key }}] has length {{ actual_length }}
        {% endset %}

    {% else %}

        {% for i in range(value | length) %}
            {% set expected_value=expected_dictionary[key][i] %}
            {% set actual_value=actual_dictionary[key][i] %}
            {% if expected_value != actual_value %}
                {% set ns.pass=False %}
                {% set ns.err_msg %}
    The {{ key }} column has differing values:
      expected_dictionary[{{ key }}][{{ i }}] == {{ expected_value }}
      actual_dictionary[{{ key }}][{{ i }}] == {{ actual_value }}
                {% endset %}

            {% endif %}
        {% endfor %}
    {% endif %}

{% endfor %}

{% endif %}

{{ log(ns.err_msg, info=True) }}
select 1 as col_name {% if ns.pass %} {{ limit_zero() }} {% endif %}
{% endif %}
