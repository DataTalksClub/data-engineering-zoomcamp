with source as (
    select * from {{ ref('stg_yellow_tripdata') }}
)

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['vendor_id', 'pickup_datetime']) }} as trip_id,  -- Create unique ID from natural key
    vendor_id,
    rate_code_id,
    pickup_location_id,
    dropoff_location_id,

    -- timestamps
    pickup_datetime,
    dropoff_datetime,

    -- trip info
    store_and_fwd_flag,
    passenger_count,
    trip_distance,
    1 as trip_type,  -- Yellow taxis only do street-hail (code 1), no dispatch column in source data

    -- payment info
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    cast(0 as numeric) as ehail_fee,  -- Yellow taxis don't have ehail_fee in source, set to 0 for consistency
    improvement_surcharge,
    total_amount,
    coalesce(payment_type, 0) as payment_type,  -- Default missing payment types to 0 (Unknown)
    {{ get_payment_type_description('payment_type') }} as payment_type_description,

    -- service type
    'Yellow' as service_type  -- Add service type identifier for unioning with green taxi data

from source
-- Deduplicate: Keep only the first dropoff for trips with the same vendor/pickup time
qualify row_number() over(
    partition by vendor_id, pickup_datetime
    order by dropoff_datetime
) = 1
