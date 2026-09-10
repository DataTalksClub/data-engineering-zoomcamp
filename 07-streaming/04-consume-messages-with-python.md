# Consume messages with Python

Now let's read back the messages. The consumer receives raw bytes from
Kafka. Instead of deserializing to a dict and then constructing a `Ride`
manually, let's write a function that does both in one step:


*Consumer groups track progress through the topic: earliest replays available records, while latest starts at new records.*

```python
import json

def ride_deserializer(data):
    json_str = data.decode('utf-8')
    ride_dict = json.loads(json_str)
    return Ride(**ride_dict)
```

Test it with a sample JSON binary string (this is what Kafka delivers):

```python
test_bytes = json.dumps({
    'PULocationID': 186,
    'DOLocationID': 79,
    'trip_distance': 1.72,
    'total_amount': 17.31,
    'tpep_pickup_datetime': 1730429702000
}).encode('utf-8')

ride_deserializer(test_bytes)
# Ride(PULocationID=186, DOLocationID=79, trip_distance=1.72,
# total_amount=17.31, tpep_pickup_datetime=1730429702000)
```

Now we can pass `ride_deserializer` directly as the `value_deserializer` -
Kafka calls it on every message, so `message.value` is already a `Ride`.

Connect to Kafka as a consumer. `auto_offset_reset='earliest'` means we
start reading from the beginning of the topic (without this, new consumers
default to `latest` and only see new messages). `group_id` identifies this
consumer group - Kafka tracks how far each group has read, so restarting
with the same group ID continues where it left off:

```python
from kafka import KafkaConsumer

server = 'localhost:9092'
topic_name = 'rides'

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='rides-console',
    value_deserializer=ride_deserializer
)
```

Read messages and print them. Since `value_deserializer` returns a `Ride`,
`message.value` is already a `Ride` object - no extra conversion needed:

```python
from datetime import datetime

print(f"Listening to {topic_name}...")

count = 0
for message in consumer:
    ride = message.value
    pickup_dt = datetime.fromtimestamp(ride.tpep_pickup_datetime / 1000)
    print(f"Received: PU={ride.PULocationID}, DO={ride.DOLocationID}, "
          f"distance={ride.trip_distance}, amount=${ride.total_amount:.2f}, "
          f"pickup={pickup_dt}")
    count += 1
    if count >= 10:
        print(f"\n... received {count} messages so far (stopping after 10 for demo)")
        break

consumer.close()
```

> The complete script is in `src/consumers/consumer.py`.

Run it:

```bash
uv run python src/consumers/consumer.py
```

```
Listening to rides...
Received: PU=..., DO=..., distance=..., amount=$..., pickup=2025-...
...
... received 10 messages so far (stopping after 10 for demo)
```
