import json
from datetime import datetime

from kafka import KafkaConsumer

server = 'localhost:9092'
topic_name = 'test-topic'

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='test-consumer-group',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print(f"Listening to {topic_name}...")

count = 0
for message in consumer:
    data = message.value
    timestamp = datetime.fromtimestamp(data['event_timestamp'] / 1000)
    print(f"Received: test_data={data['test_data']}, timestamp={timestamp}")
    count += 1
    if count >= 10:
        print(f"\n... received {count} messages so far (stopping after 10 for demo)")
        break

consumer.close()
