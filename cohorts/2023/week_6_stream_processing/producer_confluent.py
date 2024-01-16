from confluent_kafka import Producer

import argparse
import csv
from typing import Dict
from time import sleep

from settings import CONFLUENT_CLOUD_CONFIG, \
    GREEN_TAXI_TOPIC, FHV_TAXI_TOPIC, \
    GREEN_TRIP_DATA_PATH, FHV_TRIP_DATA_PATH


class RideCSVProducer:
    def __init__(self, probs: Dict, ride_type: str):

        self.producer = Producer(**probs)
        self.ride_type = ride_type

    def parse_row(self, row):
        if self.ride_type == 'green':
            record = f'{row[5]}, {row[6]}'  # PULocationID, DOLocationID
            key = str(row[0])  # vendor_id
        elif self.ride_type == 'fhv':
            record = f'{row[3]}, {row[4]}'  # PULocationID, DOLocationID,
            key = str(row[0])  # dispatching_base_num
        return key, record

    def read_records(self, resource_path: str):
        records, ride_keys = [], []
        with open(resource_path, 'r') as f:
            reader = csv.reader(f)
            header = next(reader)  # skip the header
            for row in reader:
                key, record = self.parse_row(row)
                ride_keys.append(key)
                records.append(record)
        return zip(ride_keys, records)

    def publish(self, records: [str, str], topic: str):
        for key_value in records:
            key, value = key_value
            try:
                self.producer.poll(0)
                self.producer.produce(topic=topic, key=key, value=value)
                print(f"Producing record for <key: {key}, value:{value}>")
            except KeyboardInterrupt:
                break
            except BufferError as bfer:
                self.producer.poll(0.1)
            except Exception as e:
                print(f"Exception while producing record - {value}: {e}")

        self.producer.flush()
        sleep(10)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Kafka Consumer')
    parser.add_argument('--type', type=str, default='green')
    args = parser.parse_args()

    if args.type == 'green':
        kafka_topic = GREEN_TAXI_TOPIC
        data_path = GREEN_TRIP_DATA_PATH
    elif args.type == 'fhv':
        kafka_topic = FHV_TAXI_TOPIC
        data_path = FHV_TRIP_DATA_PATH

    producer = RideCSVProducer(ride_type=args.type, probs=CONFLUENT_CLOUD_CONFIG)
    ride_records = producer.read_records(resource_path=data_path)
    producer.publish(records=ride_records, topic=kafka_topic)
