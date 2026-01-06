{{
  config(
    materialized='incremental',
    unique_key='trip_id',
    on_schema_change='fail'
  )
}}

-- Fact table containing all taxi trips enriched with zone information
-- This is a classic star schema design: fact table (trips) joined to dimension table (zones)
-- Materialized incrementally to handle large datasets efficiently

select
    -- Trip identifiers
    t.trip_id,
    t.vendor_id,
    t.service_type,
    t.rate_code_id,

    -- Location details (enriched with human-readable zone names from dimension)
    t.pickup_location_id,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    t.dropoff_location_id,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,

    -- Trip timing
    t.pickup_datetime,
    t.dropoff_datetime,
    t.store_and_fwd_flag,

    -- Trip metrics
    t.passenger_count,
    t.trip_distance,
    t.trip_type,
    {{ get_trip_duration_minutes('t.pickup_datetime', 't.dropoff_datetime') }} as trip_duration_minutes,

    -- Payment breakdown
    t.fare_amount,
    t.extra,
    t.mta_tax,
    t.tip_amount,
    t.tolls_amount,
    t.ehail_fee,
    t.improvement_surcharge,
    t.total_amount,
    t.payment_type,
    t.payment_type_description

from {{ ref('int_trips') }} as t
-- LEFT JOIN preserves all trips even if zone information is missing or unknown
left join {{ ref('dim_zones') }} as pickup_zone
    on t.pickup_location_id = pickup_zone.location_id
left join {{ ref('dim_zones') }} as dropoff_zone
    on t.dropoff_location_id = dropoff_zone.location_id

{% if is_incremental() %}
  -- Only process new trips based on pickup datetime
  where t.pickup_datetime > (select max(pickup_datetime) from {{ this }})
{% endif %}
