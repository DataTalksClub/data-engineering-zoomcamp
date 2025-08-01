with source as (
    select * from {{ source('staging','green_trip_data')}}
),

renamed as (
    selectvendor_id,	
pickup_datetime,	
dropoff_datetime,	
store_and_fwd_flag,	
rate_code,	
passenger_count,
trip_distance,
fare_amount,	
extra,
mta_tax,
tip_amount,
tolls_amount,
ehail_fee,
airport_fee,
total_amount,
payment_type,
distance_between_service,
time_between_service,
trip_type,
imp_surcharge,
pickup_location_id,
dropoff_location_id,
data_file_year,
data_file_month
from source
)

select * from renamed
