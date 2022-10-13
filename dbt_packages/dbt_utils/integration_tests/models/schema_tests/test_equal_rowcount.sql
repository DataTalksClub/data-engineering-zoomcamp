with data as (

    select * from {{ ref('data_test_equal_rowcount') }}

)

select
    field
from data