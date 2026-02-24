package org.example.data;

import java.time.LocalDateTime;

public class VendorInfo {

    public VendorInfo(String vendorID, long PULocationID, LocalDateTime pickupTime, LocalDateTime lastDropoffTime) {
        VendorID = vendorID;
        this.PULocationID = PULocationID;
        this.pickupTime = pickupTime;
        this.lastDropoffTime = lastDropoffTime;
    }

    public VendorInfo() {
    }

    public String VendorID;
    public long PULocationID;
    public LocalDateTime pickupTime;
    public LocalDateTime lastDropoffTime;
}
