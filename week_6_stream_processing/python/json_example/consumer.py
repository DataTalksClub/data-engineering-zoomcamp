from typing import Dict

from kafka import KafkaConsumer
from json import loads

from ride import Ride
from settings import BOOTSTRAP_SERVERS, KAFKA_TOPIC


class JsonConsumer:
    def __init__(self, props: Dict):
        self.consumer = KafkaConsumer(**props)
        self.consumer.subscribe([KAFKA_TOPIC])

    def consume_from_kafka(self):
        print('Consuming from Kafka started')
        print('Available topics to consume: ', self.consumer.subscription())
        while True:
            try:
                # SIGINT can't be handled when polling, limit timeout to 1 second.
                message = self.consumer.poll(1.0)
                if message is None or message == {}:
                    continue
                for message_key, message_value in message.items():
                    for msg_val in message_value:
                        print(msg_val.key, msg_val.value)
            except KeyboardInterrupt:
                break

        self.consumer.close()


if __name__ == '__main__':
    config = {
        'bootstrap_servers': BOOTSTRAP_SERVERS,
        'auto_offset_reset': 'earliest',
        'enable_auto_commit': True,
        'key_deserializer': lambda key: int(key.decode('utf-8')),
        'value_deserializer': lambda x: loads(x.decode('utf-8'), object_hook=lambda d: Ride.from_dict(d)),
        'group_id': 'consumer.group.id.json-example.2',
    }

    json_consumer = JsonConsumer(props=config)
    json_consumer.consume_from_kafka()
