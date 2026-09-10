# Produce messages to Kafka

Initialize a Python project and add the dependencies we need:

```bash
uv init -p 3.12
uv add kafka-python pandas pyarrow
```

> If you cloned the repository, `pyproject.toml` already exists.
> Run `uv sync` instead.

We'll send NYC yellow taxi trip data to Kafka. You can run the code below
either as a Python script or in a Jupyter notebook (`uv add jupyter`,
then `uv run jupyter lab`).


*The producer path makes the schema boundary explicit: tabular input becomes an event, then bytes, then a topic record.*

First, download the data. We read a parquet file of yellow taxi trips and
take the first 1000 rows:

```python
import pandas as pd

url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-11.parquet"
columns = ['PULocationID', 'DOLocationID', 'trip_distance', 'total_amount', 'tpep_pickup_datetime']
df = pd.read_parquet(url, columns=columns).head(1000)
df.head()
```

We only read 5 columns to keep things focused. The full dataset has many
more (fare breakdown, rate codes, payment type, etc.).

Define a dataclass for our message. This gives us a clear schema for each
taxi trip:

```python
from dataclasses import dataclass

@dataclass
class Ride:
    PULocationID: int
    DOLocationID: int
    trip_distance: float
    total_amount: float
    tpep_pickup_datetime: int  # epoch milliseconds
```

Write a function to convert a DataFrame row into a `Ride`. We convert the
pandas Timestamp to epoch milliseconds - that's the format Flink expects
later:

```python
def ride_from_row(row):
    return Ride(
        PULocationID=int(row['PULocationID']),
        DOLocationID=int(row['DOLocationID']),
        trip_distance=float(row['trip_distance']),
        total_amount=float(row['total_amount']),
        tpep_pickup_datetime=int(row['tpep_pickup_datetime'].timestamp() * 1000),
    )
```

Test it:

```python
ride = ride_from_row(df.iloc[0])
ride
# Ride(PULocationID=186, DOLocationID=79, trip_distance=1.72,
# total_amount=17.31, tpep_pickup_datetime=1730429702000)
```

Next, connect to Kafka. The `bootstrap_servers` is where the broker accepts
connections - `localhost:9092` because we're running this from our laptop
(outside Docker). In production with multiple brokers, you'd list several
for redundancy - if one is down, the client connects through another.

Kafka works with raw bytes, so we need a serializer that converts Python
dicts to JSON:

```python
import json
from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)
```

Let's send a single ride to try it out. `dataclasses.asdict(ride)` converts
the dataclass to a plain dict, which the serializer turns into JSON bytes.
The broker auto-creates the `rides` topic on first use:

```python
import dataclasses

topic_name = 'rides'

producer.send(topic_name, value=dataclasses.asdict(ride))
producer.flush()
```

This works, but calling `dataclasses.asdict()` every time is tedious. We
can make a serializer that handles dataclasses directly:

```python
def ride_serializer(ride):
    ride_dict = dataclasses.asdict(ride)
    json_str = json.dumps(ride_dict)
    return json_str.encode('utf-8')
```

Now recreate the producer with the new serializer - we can pass `Ride`
objects directly without converting them to dicts first:

```python
producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=ride_serializer
)
```

Send one ride to verify:

```python
producer.send(topic_name, value=ride)
producer.flush()
```

That sent one record. Now let's send all 1000 rides in a loop:

```python
import time

t0 = time.time()

for _, row in df.iterrows():
    ride = ride_from_row(row)
    producer.send(topic_name, value=ride)
    print(f"Sent: {ride}")
    time.sleep(0.01)

producer.flush()

t1 = time.time()
print(f'took {(t1 - t0):.2f} seconds')
```

If you're building from scratch (not using the cloned repo files), create
the source directory structure and save the shared data model. The
producer and consumer scripts both import from this file:

```bash
mkdir -p src/producers src/consumers src/job
```

Create `src/models.py`:

```python
import json
from dataclasses import dataclass

@dataclass
class Ride:
    PULocationID: int
    DOLocationID: int
    trip_distance: float
    total_amount: float
    tpep_pickup_datetime: int  # epoch milliseconds

def ride_from_row(row):
    return Ride(
        PULocationID=int(row['PULocationID']),
        DOLocationID=int(row['DOLocationID']),
        trip_distance=float(row['trip_distance']),
        total_amount=float(row['total_amount']),
        tpep_pickup_datetime=int(row['tpep_pickup_datetime'].timestamp() * 1000),
    )

def ride_deserializer(data):
    json_str = data.decode('utf-8')
    ride_dict = json.loads(json_str)
    return Ride(**ride_dict)
```

`ride_deserializer` is introduced in the next step - we include it here so
the file is complete.

> The complete script is in `src/producers/producer.py`.

Run it:

```bash
uv run python src/producers/producer.py
```

You'll see 1000 taxi trips sent over ~10 seconds:

```
Sent: Ride(PULocationID=..., DOLocationID=..., trip_distance=..., total_amount=..., tpep_pickup_datetime=...)
...
took 10.23 seconds
```
