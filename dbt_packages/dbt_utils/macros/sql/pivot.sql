{#
Pivot values from rows to columns.

Example:

    Input: `public.test`

    | size | color |
    |------+-------|
    | S    | red   |
    | S    | blue  |
    | S    | red   |
    | M    | red   |

    select
      size,
      {{ dbt_utils.pivot('color', dbt_utils.get_column_values('public.test',
                                                              'color')) }}
    from public.test
    group by size

    Output:

    | size | red | blue |
    |------+-----+------|
    | S    | 2   | 1    |
    | M    | 1   | 0    |

Arguments:
    column: Column name, required
    values: List of row values to turn into columns, required
    alias: Whether to create column aliases, default is True
    agg: SQL aggregation function, default is sum
    cmp: SQL value comparison, default is =
    prefix: Column alias prefix, default is blank
    suffix: Column alias postfix, default is blank
    then_value: Value to use if comparison succeeds, default is 1
    else_value: Value to use if comparison fails, default is 0
    quote_identifiers: Whether to surround column aliases with double quotes, default is true
    distinct: Whether to use distinct in the aggregation, default is False
#}

{% macro pivot(column,
               values,
               alias=True,
               agg='sum',
               cmp='=',
               prefix='',
               suffix='',
               then_value=1,
               else_value=0,
               quote_identifiers=True,
               distinct=False) %}
    {{ return(adapter.dispatch('pivot', 'dbt_utils')(column, values, alias, agg, cmp, prefix, suffix, then_value, else_value, quote_identifiers, distinct)) }}
{% endmacro %}

{% macro default__pivot(column,
               values,
               alias=True,
               agg='sum',
               cmp='=',
               prefix='',
               suffix='',
               then_value=1,
               else_value=0,
               quote_identifiers=True,
               distinct=False) %}
  {% for v in values %}
    {{ agg }}(
      {% if distinct %} distinct {% endif %}
      case
      when {{ column }} {{ cmp }} '{{ v }}'
        then {{ then_value }}
      else {{ else_value }}
      end
    )
    {% if alias %}
      {% if quote_identifiers %}
            as {{ adapter.quote(prefix ~ v ~ suffix) }}
      {% else %}
        as {{ dbt_utils.slugify(prefix ~ v ~ suffix) }}
      {% endif %}
    {% endif %}
    {% if not loop.last %},{% endif %}
  {% endfor %}
{% endmacro %}
