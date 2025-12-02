select
    t.tripid,
    t.vendorid,
    t.service_type,
    t.ratecodeid,
    t.pickup_locationid,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    t.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    t.pickup_datetime,
    t.dropoff_datetime,
    t.store_and_fwd_flag,
    t.passenger_count,
    t.trip_distance,
    t.trip_type,
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
from {{ ref('int_trips_unioned') }} as t
left join {{ ref('dim_zones') }} as pickup_zone
    on t.pickup_locationid = pickup_zone.locationid
left join {{ ref('dim_zones') }} as dropoff_zone
    on t.dropoff_locationid = dropoff_zone.locationid
