package org.example.data;

import java.time.LocalDateTime;

public class PickupLocation {
    public PickupLocation(long PULocationID, LocalDateTime tpep_pickup_datetime) {
        this.PULocationID = PULocationID;
        this.tpep_pickup_datetime = tpep_pickup_datetime;
    }

    public PickupLocation() {
    }

    public long PULocationID;
    public LocalDateTime tpep_pickup_datetime;
}
