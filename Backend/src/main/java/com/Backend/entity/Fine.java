package com.Backend.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "fines")
@Data
public class Fine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "reference_number")
    private String referenceNumber;

    @Column(name = "amount")
    private Double amount;

    @Column(name = "status")
    private String status; // PENDING or PAID

    @Column(name = "category_id")
    private String categoryId;

    @Column(name = "category_name")
    private String categoryName;

    @Column(name = "violation_description")
    private String violationDescription;

    @Column(name = "officer_name")
    private String officerName;

    @Column(name = "officer_badge")
    private String officerBadge;

    @Column(name = "location")
    private String location; // this was districtId

    @Column(name = "driver_name")
    private String driverName; // we will store vehicle and name here or in violationDescription

    @Column(name = "driver_email")
    private String driverEmail;

    @Column(name = "driver_id")
    private UUID driverId;

    @Transient
    private String vehicleNumber; // This is not a column in the database; it is parsed into violationDescription

    @Transient
    private String driverPhone; // Transient field to hold input from frontend and send SMS

    @Column(name = "issued_at")
    private LocalDateTime issuedAt = LocalDateTime.now();
}
