with 

source as (

    select * from {{ source('staging', 'yellow_tripdata') }}

),

renamed as (

    select
        vendorid,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        passenger_count,
        trip_distance,
        ratecodeid,
        store_and_fwd_flag,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        airport_fee,
        total_amount,
        pulocationid,
        dolocationid,
        data_file_year,
        data_file_month

    from source

)

select * from renamed
