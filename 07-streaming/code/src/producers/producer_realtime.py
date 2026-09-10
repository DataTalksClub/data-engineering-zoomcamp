import dataclasses
import json
import random
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from kafka import KafkaProducer
from models import Ride

# Top pickup locations from the actual NYC yellow taxi data.
# PULocationID is a taxi zone ID (1-263) defined by the NYC TLC.
# See https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
PICKUP_LOCATIONS = [
    79,   # East Village, Manhattan
    107,  # Gramercy, Manhattan
    48,   # Clinton East (Hell's Kitchen), Manhattan
    132,  # JFK Airport
    234,  # Union Sq, Manhattan
    148,  # Lower East Side, Manhattan
    249,  # West Village, Manhattan
    68,   # East Chelsea, Manhattan
    90,   # Flatiron, Manhattan
    263,  # Yorkville West, Manhattan
    138,  # LaGuardia Airport
    230,  # Times Sq/Theatre District, Manhattan
    161,  # Midtown Center, Manhattan
    162,  # Midtown East, Manhattan
    170,  # Murray Hill, Manhattan
    237,  # Upper East Side South, Manhattan
    239,  # Upper West Side South, Manhattan
    186,  # Penn Station/Madison Sq West, Manhattan
    164,  # Midtown South, Manhattan
    236,  # Upper East Side North, Manhattan
]

DROPOFF_LOCATIONS = PICKUP_LOCATIONS  # same pool for simplicity


def make_ride(delay_seconds=0):
    now_ms = int(time.time() * 1000) - delay_seconds * 1000
    return Ride(
        PULocationID=random.choice(PICKUP_LOCATIONS),
        DOLocationID=random.choice(DROPOFF_LOCATIONS),
        trip_distance=round(random.uniform(0.5, 20.0), 2),
        total_amount=round(random.uniform(5.0, 100.0), 2),
        tpep_pickup_datetime=now_ms,
    )


def ride_serializer(ride):
    return json.dumps(dataclasses.asdict(ride)).encode('utf-8')


server = 'localhost:9092'
producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=ride_serializer,
)

topic_name = 'rides'
count = 0

print("Sending events (Ctrl+C to stop)...")
print()

try:
    while True:
        # ~20% chance of a late event (3-10 seconds old)
        if random.random() < 0.2:
            delay = random.randint(3, 10)
            ride = make_ride(delay_seconds=delay)
            ts = datetime.fromtimestamp(ride.tpep_pickup_datetime / 1000, tz=timezone.utc)
            print(f"  LATE ({delay}s) -> PU={ride.PULocationID} ts={ts:%H:%M:%S}")
        else:
            ride = make_ride()
            ts = datetime.fromtimestamp(ride.tpep_pickup_datetime / 1000, tz=timezone.utc)
            print(f"  on time   -> PU={ride.PULocationID} ts={ts:%H:%M:%S}")

        producer.send(topic_name, value=ride)
        count += 1
        time.sleep(0.5)

except KeyboardInterrupt:
    producer.flush()
    print(f"\nSent {count} events")
