[Medium article](https://medium.com/@NYCTLC/what-makes-a-city-street-smart-23496d92f60d)

[Trip record user guide](https://www1.nyc.gov/assets/tlc/downloads/pdf/trip_record_user_guide.pdf)

The data set is divided into 4 parts:

- Yellow cabs
- Green cabs
- For Hire Vehicles
- High volume for hire vehicles



Below I am only concentrating on Yellow and green cabs

### Yellow and green cabs

,

| Columns               | Definition | Example             |
| --------------------- | ---------- | ------------------- |
| VendorID              |            | 2                   |
| lpep_pickup_datetime  |            | 2021-01-01 00:15:56 |
| lpep_dropoff_datetime |            | 2021-01-01 00:19:52 |
| store_and_fwd_flag    |            | N,                  |
| RatecodeID            |            | 1                   |
| PULocationID          |            | 43                  |
| DOLocationID          |            | 151                 |
| passenger_count       |            | 1                   |
| trip_distance         |            | 1.01                |
| fare_amount           |            | 5.5                 |
| extra                 |            | 0.5                 |
| mta_tax               |            | 0.5                 |
| tip_amount            |            | 0                   |
| tolls_amount          |            | 0                   |
| ehail_fee             |            |                     |
| improvement_surcharge |            | 0.3                 |
| total_amount          |            | 6.8                 |
| payment_type          |            | 2                   |
| trip_type             |            | 1                   |
| congestion_surcharge  |            | 0                   |



### Taxi zone Loopup

| Columns      | Definition | Example        |
| ------------ | ---------- | -------------- |
| LocationID   |            | 1              |
| Borough      |            | EWR            |
| Zone         |            | Newark Airport |
| service_zone |            | EWR            |

[Shapefile from S3](https://s3.amazonaws.com/nyctlc/misc/taxi_zones.zip)

[Taxi zones](https://data.cityofnewyork.us/Transportation/NYC-Taxi-Zones/d3c5-ddgc)

