with 

source as (

    select * from {{ source('staging', 'green_tripdata') }}

),

renamed as (

    select
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'lpep_pickup_datetime'])}} as tripid, 
        unique_row_id,
        filename,
        vendorid,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        store_and_fwd_flag,
        ratecodeid,
        pulocationid,
        dolocationid,
        passenger_count,
        trip_distance,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee,
        improvement_surcharge,
        total_amount,
        payment_type,
        {{ get_payment_type_description('payment_type') }} as payment_type_descripted, 
        trip_type,
        congestion_surcharge

    from source

)

select * from renamed
