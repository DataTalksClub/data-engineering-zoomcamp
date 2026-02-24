models:
  - name: int_trips_unioned
    description: Union of green and yellow taxi trip data with normalized schema
    columns:
      - name: vendor_id
        description: Taxi technology provider ID
      - name: rate_code_id
        description: Rate code at end of trip (1=Standard, 2=JFK, 3=Newark, 4=Nassau/Westchester, 5=Negotiated, 6=Group)
      - name: pickup_location_id
        description: TLC Taxi Zone where trip started
      - name: dropoff_location_id
        description: TLC Taxi Zone where trip ended
      - name: pickup_datetime
        description: Timestamp when meter was engaged
      - name: dropoff_datetime
        description: Timestamp when meter was disengaged
      - name: store_and_fwd_flag
        description: Trip record stored in vehicle memory (Y/N)
      - name: passenger_count
        description: Number of passengers in the vehicle
      - name: trip_distance
        description: Trip distance in miles
      - name: trip_type
        description: Trip type (1=Street-hail, 2=Dispatch)
      - name: fare_amount
        description: Time and distance fare
      - name: extra
        description: Miscellaneous extras and surcharges
      - name: mta_tax
        description: MTA tax
      - name: tip_amount
        description: Tip amount (credit card only)
      - name: tolls_amount
        description: Total tolls paid
      - name: ehail_fee
        description: E-hail service fee
      - name: improvement_surcharge
        description: Improvement surcharge
      - name: total_amount
        description: Total amount charged to passenger
      - name: payment_type
        description: Payment method code
      - name: service_type
        description: Type of taxi service (Green or Yellow)

  - name: int_trips
    description: Cleaned, enriched, and deduplicated trip data ready for marts
    columns:
      - name: trip_id
        description: Unique trip identifier (surrogate key)
        data_tests:
          - unique
          - not_null
      - name: vendor_id
        description: Taxi technology provider ID
        data_tests:
          - not_null
      - name: service_type
        description: Type of taxi service (Green or Yellow)
        data_tests:
          - not_null
          - accepted_values:
              arguments:
                values: ['Green', 'Yellow']
      - name: rate_code_id
        description: Rate code at end of trip
      - name: pickup_location_id
        description: TLC Taxi Zone where trip started
      - name: dropoff_location_id
        description: TLC Taxi Zone where trip ended
      - name: pickup_datetime
        description: Timestamp when meter was engaged
        data_tests:
          - not_null
      - name: dropoff_datetime
        description: Timestamp when meter was disengaged
      - name: store_and_fwd_flag
        description: Trip record stored in vehicle memory (Y/N)
      - name: passenger_count
        description: Number of passengers in the vehicle
      - name: trip_distance
        description: Trip distance in miles
      - name: trip_type
        description: Trip type (1=Street-hail, 2=Dispatch)
      - name: fare_amount
        description: Time and distance fare
      - name: extra
        description: Miscellaneous extras and surcharges
      - name: mta_tax
        description: MTA tax
      - name: tip_amount
        description: Tip amount (credit card only)
      - name: tolls_amount
        description: Total tolls paid
      - name: ehail_fee
        description: E-hail service fee
      - name: improvement_surcharge
        description: Improvement surcharge
      - name: total_amount
        description: Total amount charged to passenger
        data_tests:
          - not_null
      - name: payment_type
        description: Payment method code
      - name: payment_type_description
        description: Human-readable payment method description
