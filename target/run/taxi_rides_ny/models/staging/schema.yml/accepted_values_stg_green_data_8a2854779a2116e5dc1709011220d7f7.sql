select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        Payment_type as value_field,
        count(*) as n_records

    from `basic-strata-359416`.`trips_data_all`.`stg_green_data`
    group by Payment_type

)

select *
from all_values
where value_field not in (
    1,2,3,4,5,6
)



      
    ) dbt_internal_test