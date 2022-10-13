select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select tripid
from `basic-strata-359416`.`trips_data_all`.`stg_yellow_tripdata`
where tripid is null



      
    ) dbt_internal_test