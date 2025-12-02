with source as (
    select * from {{ ref('stg_yellow_tripdata') }}
)

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'pickup_datetime']) }} as tripid,
    vendorid,
    ratecodeid,
    pickup_locationid,
    dropoff_locationid,

    -- timestamps
    pickup_datetime,
    dropoff_datetime,

    -- trip info
    store_and_fwd_flag,
    passenger_count,
    trip_distance,
    1 as trip_type,

    -- payment info
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    cast(0 as numeric) as ehail_fee,
    improvement_surcharge,
    total_amount,
    coalesce(payment_type, 0) as payment_type,
    {{ get_payment_type_description('payment_type') }} as payment_type_description,

    -- service type
    'Yellow' as service_type

from source
qualify row_number() over(
    partition by vendorid, pickup_datetime
    order by dropoff_datetime
) = 1
