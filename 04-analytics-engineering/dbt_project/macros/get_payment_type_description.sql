{#
    This macro returns the description of the payment_type

    Payment type codes:
    - 0: Unknown/Not recorded
    - 1: Credit card
    - 2: Cash
    - 3: No charge
    - 4: Dispute
    - 5: Unknown
    - 6: Voided trip
#}

{% macro get_payment_type_description(payment_type) -%}

    case {{ payment_type }}
        when 0 then 'Unknown'
        when 1 then 'Credit card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
        else 'EMPTY'
    end

{%- endmacro %}