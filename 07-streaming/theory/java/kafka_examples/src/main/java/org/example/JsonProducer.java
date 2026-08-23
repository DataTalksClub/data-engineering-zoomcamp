package org.example;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import org.apache.kafka.clients.producer.*;
import org.apache.kafka.streams.StreamsConfig;
import org.example.data.Ride;

import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

public class JsonProducer {
    private Properties props = new Properties();
    public JsonProducer() {
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='"+Secrets.KAFKA_CLUSTER_KEY+"' password='"+Secrets.KAFKA_CLUSTER_SECRET+"';");
        props.put("sasl.mechanism", "PLAIN");
        props.put("client.dns.lookup", "use_all_dns_ips");
        props.put("session.timeout.ms", "45000");
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "io.confluent.kafka.serializers.KafkaJsonSerializer");
    }

    public List<Ride> getRides() throws IOException, CsvException {
        var ridesStream = this.getClass().getResource("/rides.csv");
        var reader = new CSVReader(new FileReader(ridesStream.getFile()));
        reader.skip(1);
        return reader.readAll().stream().map(arr -> new Ride(arr))
                .collect(Collectors.toList());

    }

    public void publishRides(List<Ride> rides) throws ExecutionException, InterruptedException {
        KafkaProducer<String, Ride> kafkaProducer = new KafkaProducer<String, Ride>(props);
        for(Ride ride: rides) {
            ride.tpep_pickup_datetime = LocalDateTime.now().minusMinutes(20);
            ride.tpep_dropoff_datetime = LocalDateTime.now();
            var record = kafkaProducer.send(new ProducerRecord<>("rides", String.valueOf(ride.DOLocationID), ride), (metadata, exception) -> {
                if(exception != null) {
                    System.out.println(exception.getMessage());
                }
            });
            System.out.println(record.get().offset());
            System.out.println(ride.DOLocationID);
            Thread.sleep(500);
        }
    }

    public static void main(String[] args) throws IOException, CsvException, ExecutionException, InterruptedException {
        var producer = new JsonProducer();
        var rides = producer.getRides();
        producer.publishRides(rides);
    }
}