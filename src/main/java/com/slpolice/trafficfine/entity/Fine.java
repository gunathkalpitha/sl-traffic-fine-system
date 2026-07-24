package com.slpolice.trafficfine.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "fines")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Fine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "reference_number", unique = true, nullable = false)
    private String referenceNumber;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id", nullable = false)
    private FineCategory category;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "officer_id", nullable = false)
    private Officer issuingOfficer;

    @Column(name = "driver_name", nullable = false)
    private String driverName;

    @Column(name = "driver_license", nullable = false)
    private String driverLicense;

    @Column(name = "vehicle_number", nullable = false)
    private String vehicleNumber;

    @Column(name = "driver_phone")
    private String driverPhone;

    @Column(name = "driver_email")
    private String driverEmail;

    @Column(name = "fine_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal fineAmount;

    @Column(name = "issued_at", nullable = false)
    private LocalDateTime issuedAt;

    @Column(name = "due_date")
    private LocalDateTime dueDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private FineStatus status = FineStatus.PENDING;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "district_id")
    private District district;

    @Column(name = "location")
    private String location;

    @Column(name = "notes")
    private String notes;

    public enum FineStatus {
        PENDING, PAID, OVERDUE, CANCELLED
    }
}