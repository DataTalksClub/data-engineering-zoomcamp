import json
import time
import logging
import datetime

from kafka import KafkaProducer

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)-8s %(message)s',
)


def json_serializer(data):
    return json.dumps(data).encode('utf-8')


server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer,
    # log_level=logging.DEBUG,
)

producer.bootstrap_connected()

topic_name = 'test-topic'

times = []

for i in range(10):
    message = {'number': i}
    time_send = time.time()
    producer.send(topic_name, value=message)
    print(f"Sent: {message}")
    times.append(time_send)
    time.sleep(0.05)

time_flush = time.time()
producer.flush()

times.append(time_flush)

send_time = sum(times[i + 1] - times[i] for i in range(len(times) - 1))
flush_time = times[-1] - times[-2]

t1 = time.time()
print(f'took {(t1 - times[0]):.2f} seconds')
print(f'Send time: {send_time:.2f} seconds')
print(f'Flush time: {flush_time:.2f} seconds')
#
# if send_time > flush_time:
#     print('More time was spent sending messages')
# else:
#     print('More time was spent flushing messages')
#
#
# # Преобразование значений массива times в понятное время
#
# def to_time(timestamp):
#     return datetime.datetime.fromtimestamp(timestamp, tz=datetime.timezone.utc).time()
#
#
# formatted_times = [to_time(timestamp) for timestamp in times]
#
# # Print results
# for time in formatted_times:
#     print(time)
