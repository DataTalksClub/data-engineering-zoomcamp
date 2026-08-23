package org.example;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import io.confluent.kafka.serializers.AbstractKafkaAvroSerDeConfig;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.streams.StreamsConfig;
import schemaregistry.RideRecord;

import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

public class AvroProducer {

    private Properties props = new Properties();

    public AvroProducer() {
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='"+Secrets.KAFKA_CLUSTER_KEY+"' password='"+Secrets.KAFKA_CLUSTER_SECRET+"';");
        props.put("sasl.mechanism", "PLAIN");
        props.put("client.dns.lookup", "use_all_dns_ips");
        props.put("session.timeout.ms", "45000");
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class.getName());

        props.put(AbstractKafkaAvroSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, "https://psrc-kk5gg.europe-west3.gcp.confluent.cloud");
        props.put("basic.auth.credentials.source", "USER_INFO");
        props.put("basic.auth.user.info", Secrets.SCHEMA_REGISTRY_KEY+":"+Secrets.SCHEMA_REGISTRY_SECRET);
    }

    public List<RideRecord> getRides() throws IOException, CsvException {
        var ridesStream = this.getClass().getResource("/rides.csv");
        var reader = new CSVReader(new FileReader(ridesStream.getFile()));
        reader.skip(1);

        return reader.readAll().stream().map(row ->
            RideRecord.newBuilder()
                    .setVendorId(row[0])
                    .setTripDistance(Double.parseDouble(row[4]))
                    .setPassengerCount(Integer.parseInt(row[3]))
                    .build()
                ).collect(Collectors.toList());
    }

    public void publishRides(List<RideRecord> rides) throws ExecutionException, InterruptedException {
        KafkaProducer<String, RideRecord> kafkaProducer = new KafkaProducer<>(props);
        for (RideRecord ride : rides) {
            var record = kafkaProducer.send(new ProducerRecord<>("rides_avro", String.valueOf(ride.getVendorId()), ride), (metadata, exception) -> {
                if (exception != null) {
                    System.out.println(exception.getMessage());
                }
            });
            System.out.println(record.get().offset());
            Thread.sleep(500);
        }
    }

    public static void main(String[] args) throws IOException, CsvException, ExecutionException, InterruptedException {
        var producer = new AvroProducer();
        var rideRecords = producer.getRides();
        producer.publishRides(rideRecords);
    }
}
