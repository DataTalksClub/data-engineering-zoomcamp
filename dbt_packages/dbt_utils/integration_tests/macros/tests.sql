
{% test assert_equal(model, actual, expected) %}
select * from {{ model }} where {{ actual }} != {{ expected }}

{% endtest %}


{% test not_empty_string(model, column_name) %}

select * from {{ model }} where {{ column_name }} = ''

{% endtest %}
