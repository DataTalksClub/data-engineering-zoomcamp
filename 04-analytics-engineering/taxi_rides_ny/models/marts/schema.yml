models:
  - name: dim_zones
    description: Taxi zone dimension table with location details
    columns:
      - name: location_id
        description: Unique identifier for each taxi zone
        data_tests:
          - unique
          - not_null
      - name: borough
        description: NYC borough name
      - name: zone
        description: Specific zone name within the borough
      - name: service_zone
        description: Service zone classification

  - name: dim_vendors
    description: Taxi technology vendor dimension table
    columns:
      - name: vendor_id
        description: Unique vendor identifier
        data_tests:
          - unique
          - not_null
      - name: vendor_name
        description: Company name of the vendor

  - name: fct_trips
    description: Fact table with all taxi trips including trip and payment details
    config:
      contract:
        enforced: true
    columns:
      - name: trip_id
        description: Unique trip identifier
        data_type: string
        data_tests:
          - unique
          - not_null
      - name: vendor_id
        description: Taxi technology provider
        data_type: integer
        data_tests:
          - not_null
      - name: service_type
        description: Type of taxi service (Green or Yellow)
        data_type: string
        data_tests:
          - accepted_values:
              arguments:
                values: ['Green', 'Yellow']
          - not_null
      - name: rate_code_id
        description: Final rate code
        data_type: integer
      - name: pickup_location_id
        description: TLC Taxi Zone where trip started
        data_type: integer
        data_tests:
          - relationships:
              arguments:
                to: ref('dim_zones')
                field: location_id
      - name: pickup_borough
        description: NYC borough where trip started
        data_type: string
      - name: pickup_zone
        description: Specific zone where trip started
        data_type: string
      - name: dropoff_location_id
        description: TLC Taxi Zone where trip ended
        data_type: integer
        data_tests:
          - relationships:
              arguments:
                to: ref('dim_zones')
                field: location_id
      - name: dropoff_borough
        description: NYC borough where trip ended
        data_type: string
      - name: dropoff_zone
        description: Specific zone where trip ended
        data_type: string
      - name: pickup_datetime
        description: Timestamp when meter was engaged
        data_type: timestamp
        data_tests:
          - not_null
      - name: dropoff_datetime
        description: Timestamp when meter was disengaged
        data_type: timestamp
      - name: store_and_fwd_flag
        description: Trip record stored in vehicle memory (Y/N)
        data_type: string
      - name: passenger_count
        description: Number of passengers
        data_type: integer
      - name: trip_distance
        description: Trip distance in miles
        data_type: numeric
      - name: trip_type
        description: Trip type (1=Street-hail, 2=Dispatch)
        data_type: integer
      - name: trip_duration_minutes
        description: Trip duration in minutes (calculated using cross-database macro)
        data_type: bigint
      - name: fare_amount
        description: Time and distance fare
        data_type: numeric
      - name: extra
        description: Miscellaneous extras and surcharges
        data_type: numeric
      - name: mta_tax
        description: MTA tax
        data_type: numeric
      - name: tip_amount
        description: Tip amount (credit card only)
        data_type: numeric
      - name: tolls_amount
        description: Total tolls paid
        data_type: numeric
      - name: ehail_fee
        description: E-hail service fee
        data_type: numeric
      - name: improvement_surcharge
        description: Improvement surcharge
        data_type: numeric
      - name: total_amount
        description: Total amount charged
        data_type: numeric
        data_tests:
          - not_null
      - name: payment_type
        description: Payment method code
        data_type: integer
      - name: payment_type_description
        description: Human-readable payment method description
        data_type: string