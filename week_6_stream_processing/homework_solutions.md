## Question 1

1. Kafka logs are divided in partitions and distributed among the different kafka nodes so there is no unique node that stores all logs.
2. Zookeeper was substituted by kafka Quorum in the 2.8 version.
3. Retention configuration ensures that messages are stored during a specific period of time.
4. Group-Id of a message does ensure that it is distributed to a certain set of consumers of the same group.

Correct statements: Group-Id ensures the messages are distributed to associated consumers

## Question 2

Topic replication provides reliability and availability.
Topic partitioning provides reliability and availability.

Group id is a way to load balance the messages.

Ack all configuration provides reliability but it does not provide availability and it can also hinder performance.

## Question 3

Topic replication supports scaling.
Topic partitioning supports scaling.
Consumer grop id supports scaling.

## Question 4

Good partitioning keys

payment_type
vendor_id
tpep_pickup_datetime
tpep_dropoff_datetime

## Question 5

Configurations for kafka consumers, not for producers

Deserializer Configuration
Topics Subscription
Group-id
Offset

## Question 6
