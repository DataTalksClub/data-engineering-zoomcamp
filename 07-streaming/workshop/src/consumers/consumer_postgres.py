import json
from datetime import datetime

import psycopg2
from kafka import KafkaConsumer

server = 'localhost:9092'
topic_name = 'test-topic'

# Connect to PostgreSQL
conn = psycopg2.connect(
    host='localhost',
    port=5432,
    database='postgres',
    user='postgres',
    password='postgres'
)
conn.autocommit = True
cur = conn.cursor()

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='test-consumer-postgres',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print(f"Listening to {topic_name} and writing to PostgreSQL...")

count = 0
for message in consumer:
    data = message.value
    timestamp = datetime.fromtimestamp(data['event_timestamp'] / 1000)
    cur.execute(
        "INSERT INTO processed_events (test_data, event_timestamp) VALUES (%s, %s)",
        (data['test_data'], timestamp)
    )
    count += 1
    if count % 100 == 0:
        print(f"Inserted {count} rows...")

consumer.close()
cur.close()
conn.close()
