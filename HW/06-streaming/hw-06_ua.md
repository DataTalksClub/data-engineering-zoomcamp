## Модуль 6. Домашнє завдання

У цьому домашньому завданні ми розширимо Домашнє завдання модуля 5 і дізнаємося про потокову передачу даних за допомогою PySpark.

Замість Kafka ми використовуватимемо Red Panda, яка є безпосередньою заміною для Kafka.

Переконайтеся, що у вас налаштовано наступне (якщо ви виконали попереднє домашнє завдання та модуль):
- Docker (see [module 1](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/01-docker-terraform))
- PySpark (see [module 5](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/05-batch/setup))

Для этого домашнего задания мы будем использовать файлы из домашнего задания модуля 5:

- Green 2019-10 data from [here](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz)

## Запустіть RedPanda

Запустим redpanda в docker-контейнере.

В папке с домашним заданием есть файл «docker-compose.yml» (taken from [here](https://github.com/redpanda-data-blog/2023-python-gsg/blob/main/docker-compose.yml))

Скопіюйте цей файл у каталог домашнього завдання та запустіт

```bash
docker-compose up
```

(Добавьте '-d', если вы хотите работать в автономном режиме)

## Вопрос 1: Версия Redpanda

Тепер давайте з'ясуємо версію Redpanda.

Для цього перевірте вивід командиd `rpk help` _всередині контейнера_.  Назва контейнера - `redpanda-1`.

Дізнайтеся, що потрібно виконати, виходячи з виводу команди `help`.

Яка версія, виходячи з результату виконаної вами команди? (скопіюйте всю версію)
```bash
rpk version
v22.3.5 (rev 28b2443)
```
## Запитання 2. Створення теми

Перш ніж ми зможемо надсилати дані на сервер Redpanda, нам потрібно створити тему (топік).
Ми також робимо це за допомогою команди rpk, яку ми використовували раніше, щоб з'ясувати версію Redpanda.

Прочитайте вивід команди `help`  і на основі нього створіть тему з назвою `test-topic`

Що виводить команда для створення теми?

```bash
rpk topic create test-topic

TOPIC       STATUS
test-topic  OK

rpk topic list

NAME        PARTITIONS  REPLICAS
test-topic  1           1

rpk topic consume test-topic
{
  "topic": "test-topic",
  "value": "{\"message\": \"Hello, Redpanda!\"}",
  "timestamp": 1710701713031,
  "partition": 0,
  "offset": 0
}
```
## Запитання 3. Підключення до сервера Kafka

Нам потрібно переконатися, що ми можемо підключитися до сервера, щоб пізніше ми могли надсилати деякі дані до його тем.

Спочатку давайте встановимо конектор Kafka (вам вирішувати, чи потрібно для цього окреме віртуальне середовище).

```bash
pip install kafka-python
```

Використовуйте цей код обачно.
Ви можете запустити блокнот Jupyter у папці рішення або створити скрипт.

Давайте спробуємо підключитися до нашого сервера:

```python
import json
import time

from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)

producer.bootstrap_connected()
```

При условии, что вы можете подключиться к серверу, что будет на выходе
последней команды?

##  Запитання 4. Надсилання даних до потоку

Тепер ми готові надіслати деякі тестові дані:

```python
t0 = time.time()

topic_name = 'test-topic'

for i in range(10):
    message = {'number': i}
    producer.send(topic_name, value=message)
    print(f"Sent: {message}")
    time.sleep(0.05)

producer.flush()

t1 = time.time()
print(f'took {(t1 - t0):.2f} seconds')
```

Скільки часу це зайняло? На що було витрачено більшу частину часу?
took 0.69 seconds
- Надсилання повідомлень
- Збереження даних у буфері (flushing)
- Обидва варіанти зайняли приблизно однакову кількість часу

(Під час відповіді на це запитання не видаляйте`time.sleep`)

##  Зчитування даних за допомогою `rpk`

Ви можете побачити повідомлення, які ви надсилаєте в цю тему, за допомогою `rpk`:

```bash
rpk topic consume test-topic
```

Виконайте наведену вище команду та надішліть повідомлення ще раз, щоб їх побачити.

## Надсилання даних про таксі

Тепер давайте надішлемо наші фактичні дані:

- Прочитайте файл green.csv.gz
- Нам знадобляться лише такі стовпці:
  - `'lpep_pickup_datetime',`
  - `'lpep_dropoff_datetime',`
  - `'PULocationID',`
  - `'DOLocationID',`
  - `'passenger_count',`
  - `'trip_distance',`
  - `'tip_amount'`

Пройдіться по записах у датафреймі

```python
for row in df_green.itertuples(index=False):
    row_dict = {col: getattr(row, col) for col in row._fields}
    print(row_dict)
    break

    # TODO реалізуйте надсилання даних тут
```

Примітка: такий спосіб ітерації за записами є більш ефективним у порівнянні з `iterrows`

## Запитання 5: Надсилання даних про поїздки

- Створіть тему `green-trips` і надішліть туди дані.
- Скільки часу у секундах зайняло надсилання? (Можна округлити до цілого числа)
- Не включайте затримки sleep у свій код.

took 50.44 seconds

## Створення споживача PySpark

Тепер давайте прочитаємо дані за допомогою PySpark

Spark потребує підключення бібліотеки (jar), щоб мати можливість підключатися до Kafka,
тому нам потрібно повідомити PySpark, що він має її використовувати:

```python
import pyspark
from pyspark.sql import SparkSession

pyspark_version = pyspark.__version__
kafka_jar_package = f"org.apache.spark:spark-sql-kafka-0-10_2.12:{pyspark_version}"

spark = SparkSession \
    .builder \
    .master("local[*]") \
    .appName("GreenTripsConsumer") \
    .config("spark.jars.packages", kafka_jar_package) \
    .getOrCreate()
```

Тепер ми можемо підключитися до потоку:

```python
green_stream = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "green-trips") \
    .option("startingOffsets", "earliest") \
    .load()
```

Щоб перевірити, чи можемо ми споживати з потоку, давайте подивимося, яким буде перший запис.

У потоковій передачі Spark потік представлений як послідовність невеликих пакетів,
де кожен пакет є невеликим RDD (або невеликим датафреймом).

Отже, ми можемо виконати функцію для кожного міні-пакету.
Давайте запустимо take(1), щоб побачити, що ми маємо в потоці:

```python
def peek(mini_batch, batch_id):
    first_row = mini_batch.take(1)

    if first_row:
        print(first_row[0])

query = green_stream.writeStream.foreachBatch(peek).start()
```

Ви повинні побачити запис, подібний до цього:

```
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:26:02", "lpep_dropoff_datetime": "2019-10-01 00:39:58", "PULocationID": 112, "DOLocationID": 196, "passenger_count": 1.0, "trip_distance": 5.88, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=0, timestamp=datetime.datetime(2024, 3, 12, 22, 42, 9, 411000), timestampType=0)
```

Тепер зупинімо запит, щоб він не продовжував споживати повідомлення з потоку.

```python
query.stop()
```

## Запитання 6. Розбір даних

Дані представлені у форматі JSON, але зараз вони у бінарному форматі.
Нам потрібно їх розібрати та перетворити на потоковий датафрейм з відповідними стовпцями.

Аналогічно PySpark, ми визначаємо схему:

```python
from pyspark.sql import types

schema = types.StructType() \
    .add("lpep_pickup_datetime", types.StringType()) \
    .add("lpep_dropoff_datetime", types.StringType()) \
    .add("PULocationID", types.IntegerType()) \
    .add("DOLocationID", types.IntegerType()) \
    .add("passenger_count", types.DoubleType()) \
    .add("trip_distance", types.DoubleType()) \
    .add("tip_amount", types.DoubleType())
```

І застосовуємо цю схему:

```python
from pyspark.sql import functions as F

green_stream = green_stream \
  .select(F.from_json(F.col("value").cast('STRING'), schema).alias("data")) \
  .select("data.*")
```

Як виглядає запис після парсингу? Скопіюйте результат.

### Запитання 7. Найпопулярніший пункт призначення

Тепер нарешті зробимо потокову аналітику. Подивимося,
який пункт призначення є найпопулярнішим наразі на основі
нашого потоку даних (який в ідеалі ми мали б надсилати із затримками, як у воркшопі 2).

Ось як це можна зробити:

- Додайте стовпець "timestamp" за допомогою функції `current_timestamp`.
- Згрупуйте за:
  - 5-хвилинним вікном на основі стовпця "timestamp" (`F.window(col("timestamp"), "5 minutes")`)
  - `"DOLocationID"`
- Впорядкуйте за кількістю (order by count)

Вы можете распечатать вывод на консоль с помощью этого
код

```python
query = popular_destinations \
    .writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", "false") \
    .start()

query.awaitTermination()
```
Використовуйте цей код обачно.

Напишіть найпопулярніший пункт призначення. (Вам потрібно буде повторно надіслати дані, щоб це спрацювало).

## Надсилання рішень

- Форма для надсилання: Буде оголошено пізніше.

## Рішення

Ми опублікуємо рішення тут після дедлайну.