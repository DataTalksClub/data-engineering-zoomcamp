-- Data Quality Analysis for Trip Data
-- This analysis identifies records that fail basic data quality checks
-- Run with: dbt compile -s trips_data_quality

select
    vendor_id,
    service_type,
    pickup_datetime,
    dropoff_datetime,
    pickup_location_id,
    dropoff_location_id,
    trip_distance,
    passenger_count,
    fare_amount,
    total_amount,

    -- Simple data quality flags (returns true if there's an issue)
    pickup_datetime is null as missing_pickup_datetime,
    dropoff_datetime is null as missing_dropoff_datetime,
    dropoff_datetime < pickup_datetime as invalid_trip_duration,
    trip_distance < 0 as negative_trip_distance,
    passenger_count < 1 or passenger_count > 8 as invalid_passenger_count,
    fare_amount < 0 as negative_fare_amount,
    total_amount < 0 as negative_total_amount

from {{ ref('int_trips_unioned') }}

-- Show only records with at least one data quality issue
where
    pickup_datetime is null
    or dropoff_datetime is null
    or dropoff_datetime < pickup_datetime
    or trip_distance < 0
    or passenger_count < 1
    or passenger_count > 8
    or fare_amount < 0
    or total_amount < 0

order by pickup_datetime desc
