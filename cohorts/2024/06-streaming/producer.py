import argparse
import csv
from time import sleep
from typing import Dict
from kafka import KafkaProducer

from settings import BOOTSTRAP_SERVERS, \
    GREEN_TAXI_TOPIC, FHV_TAXI_TOPIC, \
    GREEN_TRIP_DATA_PATH, FHV_TRIP_DATA_PATH


def delivery_report(err, msg):
    if err is not None:
        print("Delivery failed for record {}: {}".format(msg.key(), err))
        return
    print('Record {} successfully produced to {} [{}] at offset {}'.format(
        msg.key(), msg.topic(), msg.partition(), msg.offset()))

class RideCSVProducer:
    def __init__(self, probs: Dict, ride_type: str):
        self.producer = KafkaProducer(**probs)
        self.ride_type = ride_type


    def parse_row(self, row):
        if self.ride_type == 'green':
            # lpep_pickup_datetime, lpep_dropoff_datetime, PULocationID, DOLocationID
            record = f'{row[1]}, {row[2]},{row[5]}, {row[6]}'  
            key = str(row[0])  # vendor_id
        elif self.ride_type == 'fhv':
            # Pickup_datetime , DropOff_datetime, PULocationID, DOLocationID,
            record = f'{row[1]}, {row[2]}, {row[3]}, {row[4]}'  
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

    def publish(self, topic: str, records: [str, str]):
        for key_value in records:
            key, value = key_value
            try:
                self.producer.send(topic=topic, key=key, value=value)
                print(f"Producing record for <key: {key}, value:{value}>")
            except KeyboardInterrupt:
                break
            except Exception as e:
                print(f"Exception while producing record - {value}: {e}")

        self.producer.flush()
        sleep(1)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Kafka Producer')
    parser.add_argument('--type', type=str, default='green')
    args = parser.parse_args()

    config = {
        'bootstrap_servers': [BOOTSTRAP_SERVERS],
        'key_serializer': lambda x: x.encode('utf-8'),
        'value_serializer': lambda x: x.encode('utf-8')
    }

    if args.type == 'green':
        kafka_topic = GREEN_TAXI_TOPIC
        data_path = GREEN_TRIP_DATA_PATH
    elif args.type == 'fhv':
        kafka_topic = FHV_TAXI_TOPIC
        data_path = FHV_TRIP_DATA_PATH

    producer = RideCSVProducer(ride_type=args.type, probs=config)
    ride_records = producer.read_records(resource_path=data_path)
    print(ride_records)
    producer.publish(records=ride_records, topic=kafka_topic)
