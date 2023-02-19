## KSQL DB Examples
### Create streams
```sql
CREATE STREAM ride_streams (
    VendorId varchar, 
    trip_distance double,
    payment_type varchar
)  WITH (KAFKA_TOPIC='rides',
        VALUE_FORMAT='JSON');
```

### Query stream
```sql
select * from RIDE_STREAMS 
EMIT CHANGES;
```

### Query stream count
```sql
SELECT VENDORID, count(*) FROM RIDE_STREAMS 
GROUP BY VENDORID
EMIT CHANGES;
```

### Query stream with filters
```sql
SELECT payment_type, count(*) FROM RIDE_STREAMS 
WHERE payment_type IN ('1', '2')
GROUP BY payment_type
EMIT CHANGES;
```

### Query stream with window functions
```sql
CREATE TABLE payment_type_sessions AS
  SELECT payment_type,
         count(*)
  FROM  RIDE_STREAMS 
  WINDOW SESSION (60 SECONDS)
  GROUP BY payment_type
  EMIT CHANGES;
```

## KSQL documentation for details
[KSQL DB Documentation](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-reference/quick-reference/)

[KSQL DB Java client](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-clients/java-client/)