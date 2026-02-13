with source as (
    select * from {{ source('raw', 'fhv_tripdata') }}
),

renamed as (
    select
        dispatching_base_num,
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropOff_datetime as timestamp) as dropoff_datetime,
        cast(PUlocationID as integer) as pickup_location_id,
        cast(DOlocationID as integer) as dropoff_location_id,
        SR_Flag as sr_flag
    from source
    where dispatching_base_num is not null
      and pickup_datetime >= '2019-01-01'
      and pickup_datetime < '2020-01-01'
)

select * from renamed
