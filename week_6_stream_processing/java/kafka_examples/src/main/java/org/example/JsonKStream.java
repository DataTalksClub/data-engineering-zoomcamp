package org.example;

import io.confluent.kafka.serializers.KafkaJsonDeserializer;
import io.confluent.kafka.serializers.KafkaJsonDeserializerConfig;
import io.confluent.kafka.serializers.KafkaJsonSerializer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.common.serialization.Serializer;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.Topology;
import org.apache.kafka.streams.kstream.Consumed;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.Produced;
import org.example.customserdes.CustomSerdes;
import org.example.data.Ride;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.kafka.streams.StreamsConfig;

public class JsonKStream {
    private Properties props = new Properties();

    public JsonKStream() {
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "pkc-75m1o.europe-west3.gcp.confluent.cloud:9092");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='QA63KEUZ6UWEDIDP' password='o9moc8mvNLXW7YU3vSK74l9OYKqs/m5MyF0PWGrf3V7pLoGEbf3yby50D7hDE+Bk';");
        props.put("sasl.mechanism", "PLAIN");
        props.put("client.dns.lookup", "use_all_dns_ips");
        props.put("session.timeout.ms", "45000");
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "kafka_tutorial.kstream.count.plocation.v1");
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        props.put(StreamsConfig.CACHE_MAX_BYTES_BUFFERING_CONFIG, 0);

    }

    public Topology createTopology() {
        StreamsBuilder streamsBuilder = new StreamsBuilder();
        var ridesStream = streamsBuilder.stream("rides", Consumed.with(Serdes.String(), CustomSerdes.getRideSerdes()));
        var puLocationCount = ridesStream.groupByKey().count().toStream();
        puLocationCount.to("rides-pulocation-count", Produced.with(Serdes.String(), Serdes.Long()));
        return streamsBuilder.build();
    }

    public void countPLocation() {
        var topology = createTopology();
        var kStreams = new KafkaStreams(topology, props);
        kStreams.start();

        Runtime.getRuntime().addShutdownHook(new Thread(kStreams::close));
    }

    public static void main(String[] args) {
        var object = new JsonKStream();
        object.countPLocation();
    }
}
