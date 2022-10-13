
{{ dbt_utils.union_relations([
        ref('data_union_table_1'),
        ref('data_union_table_2')]
) }}
