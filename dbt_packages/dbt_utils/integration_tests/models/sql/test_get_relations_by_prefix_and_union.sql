{{ config(materialized = 'table') }}

{% set relations = dbt_utils.get_relations_by_prefix(target.schema, 'data_events_') %}
{{ dbt_utils.union_relations(relations) }}
