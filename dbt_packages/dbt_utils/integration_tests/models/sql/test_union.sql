
select
    id,
    name,
    favorite_color

from {{ ref('test_union_base') }}

