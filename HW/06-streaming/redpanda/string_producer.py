from kafka import KafkaProducer
from kafka.errors import KafkaError

producer = KafkaProducer(
    bootstrap_servers = "localhost:9092"
)

topic = "orders"

def on_success(metadata):
  print(f"Message produced to topic '{metadata.topic}' at offset {metadata.offset}")

def on_error(e):
  print(f"Error sending message: {e}")

# Produce asynchronously with callbacks
for i in range(1, 11):
  msg = f"Order with id #{i}"
  future = producer.send(
    topic,
    value=str.encode(msg)
  )
  future.add_callback(on_success)
  future.add_errback(on_error)

producer.flush()
producer.close()