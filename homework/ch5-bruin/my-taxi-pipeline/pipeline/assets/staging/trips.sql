/* @bruin
name: staging.trips
type: duckdb.sql

depends:
  - ingestion.trips
  - ingestion.payment_lookup

materialization:
  type: table
  strategy: time_interval
  incremental_key: pickup_datetime
  time_granularity: timestamp

columns:
  - name: pickup_datetime
    type: timestamp
    primary_key: true
    checks:
      - name: not_null

# custom_checks:
#  - name: row_count_greater_than_zero
#    query: |
#      SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
#      FROM staging.trips
#   value: 1
@bruin */

SELECT
    t.tpep_pickup_datetime as pickup_datetime,
    t.tpep_dropoff_datetime as dropoff_datetime,
    t.pu_location_id as pickup_location_id,
    t.do_location_id as dropoff_location_id,
    t.fare_amount,
    t.vendor_id as taxi_type,
    p.payment_type_name
FROM ingestion.trips t
LEFT JOIN ingestion.payment_lookup p
    ON t.payment_type = p.payment_type_id
WHERE t.tpep_pickup_datetime >= '{{ start_datetime }}'
  AND t.tpep_pickup_datetime < '{{ end_datetime }}'
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY t.tpep_pickup_datetime, t.tpep_dropoff_datetime,
                 t.pu_location_id, t.do_location_id, t.fare_amount
    ORDER BY t.tpep_pickup_datetime
) = 1
