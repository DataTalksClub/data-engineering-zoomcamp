package org.example;

import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.*;
import org.example.customserdes.CustomSerdes;
import org.example.data.Ride;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Properties;

import static org.junit.jupiter.api.Assertions.*;

class JsonKStreamTest {
    private Properties props;
    private static TopologyTestDriver testDriver;
    private TestInputTopic<String, Ride> inputTopic;
    private TestOutputTopic<String, Long> outputTopic;
    @BeforeEach
    public void setup() {
        props =  new Properties();
        props.setProperty(StreamsConfig.APPLICATION_ID_CONFIG, "testing_count_application");
        props.setProperty(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "dummy:1234");
        var streamCountTopology = new JsonKStream().creatTopology();
        testDriver = new TopologyTestDriver(streamCountTopology, props);
        inputTopic = testDriver.createInputTopic("rides", Serdes.String().serializer(), CustomSerdes.getRideSerdes().serializer());
        outputTopic = testDriver.createOutputTopic("rides-pulocation-count", Serdes.String().deserializer(), Serdes.Long().deserializer());

    }

    @AfterAll
    public static void tearDown() {
        testDriver.close();
    }

    @Test
    public void countByKey() {
        Ride ride1 = new Ride(new String[]{"1","2020-07-01 00:25:32","2020-07-01 00:33:39","1","1.50","1","N","238","75","2","8","0.5","0.5","0","0","0.3","9.3","0"});
        Ride ride2 = new Ride(new String[]{"1","2020-07-01 00:25:32","2020-07-01 00:33:39","1","1.50","1","N","238","75","2","8","0.5","0.5","0","0","0.3","9.3","0"});
        inputTopic.pipeInput(String.valueOf(ride1.DOLocationID), ride1);
        inputTopic.pipeInput(String.valueOf(ride2.DOLocationID), ride2);
        assertEquals(outputTopic.readKeyValue(), new KeyValue<>(String.valueOf(ride1.DOLocationID), 1L));
        assertEquals(outputTopic.readKeyValue(), new KeyValue<>(String.valueOf(ride1.DOLocationID), 2L));
    }


}