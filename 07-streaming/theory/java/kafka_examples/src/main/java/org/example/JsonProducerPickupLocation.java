package org.example;

import com.opencsv.exceptions.CsvException;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.example.data.PickupLocation;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

public class JsonProducerPickupLocation {
    private Properties props = new Properties();

    public JsonProducerPickupLocation() {
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='"+Secrets.KAFKA_CLUSTER_KEY+"' password='"+Secrets.KAFKA_CLUSTER_SECRET+"';");
        props.put("sasl.mechanism", "PLAIN");
        props.put("client.dns.lookup", "use_all_dns_ips");
        props.put("session.timeout.ms", "45000");
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "io.confluent.kafka.serializers.KafkaJsonSerializer");
    }

    public void publish(PickupLocation pickupLocation) throws ExecutionException, InterruptedException {
        KafkaProducer<String, PickupLocation> kafkaProducer = new KafkaProducer<String, PickupLocation>(props);
        var record = kafkaProducer.send(new ProducerRecord<>("rides_location", String.valueOf(pickupLocation.PULocationID), pickupLocation), (metadata, exception) -> {
            if (exception != null) {
                System.out.println(exception.getMessage());
            }
        });
        System.out.println(record.get().offset());
    }


    public static void main(String[] args) throws IOException, CsvException, ExecutionException, InterruptedException {
        var producer = new JsonProducerPickupLocation();
        producer.publish(new PickupLocation(186, LocalDateTime.now()));
    }
}
