with 

source as (

    select * from {{ source('staging', 'green_tripdata') }}

),

renamed as (

    select
        {{dbt_utils.generate_surrogate_key(['vendorid','lpep_pickup_datetime'])}} as tripid,
        vendorid,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        store_and_fwd_flag,
        ratecodeid,
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
        {{get_payment_type_description('payment_type')}} as get_payment_type_descripted,
        distance_between_service,
        time_between_service,
        trip_type,
        improvement_surcharge,
        pulocationid,
        dolocationid,
        data_file_year,
        data_file_month

    from source

)

select * from renamed
