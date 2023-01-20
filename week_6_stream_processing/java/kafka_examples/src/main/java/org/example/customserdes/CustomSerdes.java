package org.example.customserdes;

import io.confluent.kafka.serializers.KafkaJsonDeserializer;
import io.confluent.kafka.serializers.KafkaJsonSerializer;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.common.serialization.Serializer;
import org.example.data.PickupLocation;
import org.example.data.Ride;
import org.example.data.VendorInfo;

import java.util.HashMap;
import java.util.Map;

public class CustomSerdes {
    public static Serde<Ride> getRideSerdes() {
        Map<String, Object> serdeProps = new HashMap<>();
        serdeProps.put("json.value.type", Ride.class);
        final Serializer<Ride> mySerializer = new KafkaJsonSerializer<>();
        mySerializer.configure(serdeProps, false);

        final Deserializer<Ride> myDeserializer = new KafkaJsonDeserializer<>();
        myDeserializer.configure(serdeProps, false);
        return Serdes.serdeFrom(mySerializer, myDeserializer);
    }

    public static  Serde<PickupLocation> getPickuLocationSerde() {
        Map<String, Object> serdeProps = new HashMap<>();
        serdeProps.put("json.value.type", PickupLocation.class);
        final Serializer<PickupLocation> mySerializer = new KafkaJsonSerializer<>();
        mySerializer.configure(serdeProps, false);

        final Deserializer<PickupLocation> myDeserializer = new KafkaJsonDeserializer<>();
        myDeserializer.configure(serdeProps, false);
        return Serdes.serdeFrom(mySerializer, myDeserializer);
    }
    public static Serde<VendorInfo> getVendorSerde() {
        Map<String, Object> serdeProps = new HashMap<>();
        serdeProps.put("json.value.type", VendorInfo.class);
        final Serializer<VendorInfo> mySerializer = new KafkaJsonSerializer<>();
        mySerializer.configure(serdeProps, false);

        final Deserializer<VendorInfo> myDeserializer = new KafkaJsonDeserializer<>();
        myDeserializer.configure(serdeProps, false);
        return Serdes.serdeFrom(mySerializer, myDeserializer);
    }


}
