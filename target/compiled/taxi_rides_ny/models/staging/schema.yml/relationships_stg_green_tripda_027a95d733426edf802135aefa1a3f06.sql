
    
    

with child as (
    select dropoff_locationid as from_field
    from `basic-strata-359416`.`trips_data_all`.`stg_green_tripdata`
    where dropoff_locationid is not null
),

parent as (
    select locationid as to_field
    from `basic-strata-359416`.`trips_data_all_eu`.`taxi_zone`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


