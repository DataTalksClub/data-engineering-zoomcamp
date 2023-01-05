package org.example;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.internals.Topic;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.*;
import org.example.customserdes.CustomSerdes;
import org.example.data.PickupLocation;
import org.example.data.Ride;
import org.example.data.VendorInfo;
import org.example.helper.DataGeneratorHelper;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.xml.crypto.Data;
import java.util.Properties;

import static org.junit.jupiter.api.Assertions.*;

class JsonKStreamJoinsTest {
    private Properties props = new Properties();
    private static TopologyTestDriver testDriver;
    private TestInputTopic<String, Ride> ridesTopic;
    private TestInputTopic<String, PickupLocation> pickLocationTopic;
    private TestOutputTopic<String, VendorInfo> outputTopic;

    private Topology topology = new JsonKStreamJoins().createTopology();
    @BeforeEach
    public void setup() {
        props = new Properties();
        props.setProperty(StreamsConfig.APPLICATION_ID_CONFIG, "testing_count_application");
        props.setProperty(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "dummy:1234");
        if (testDriver != null) {
            testDriver.close();
        }
        testDriver = new TopologyTestDriver(topology, props);
        ridesTopic = testDriver.createInputTopic(Topics.INPUT_RIDE_TOPIC, Serdes.String().serializer(), CustomSerdes.getRideSerdes().serializer());
        pickLocationTopic = testDriver.createInputTopic(Topics.INPUT_RIDE_LOCATION_TOPIC, Serdes.String().serializer(), CustomSerdes.getPickuLocationSerde().serializer());
        outputTopic = testDriver.createOutputTopic(Topics.OUTPUT_TOPIC, Serdes.String().deserializer(), CustomSerdes.getVendorSerde().deserializer());
    }

    @Test
    public void testIfJoinWorksOnSameDropOffPickupLocationId() {
        Ride ride = DataGeneratorHelper.generateRide();
        PickupLocation pickupLocation = DataGeneratorHelper.generatePickUpLocation(ride.DOLocationID);
        ridesTopic.pipeInput(String.valueOf(ride.DOLocationID), ride);
        pickLocationTopic.pipeInput(String.valueOf(pickupLocation.PULocationID), pickupLocation);

        assertEquals(outputTopic.getQueueSize(), 1);
        var expected = new VendorInfo(ride.VendorID, pickupLocation.PULocationID, pickupLocation.tpep_pickup_datetime, ride.tpep_dropoff_datetime);
        var result = outputTopic.readKeyValue();
        assertEquals(result.key, String.valueOf(ride.DOLocationID));
        assertEquals(result.value.VendorID, expected.VendorID);
        assertEquals(result.value.pickupTime, expected.pickupTime);
    }


    @AfterAll
    public static void shutdown() {
        testDriver.close();
    }
}