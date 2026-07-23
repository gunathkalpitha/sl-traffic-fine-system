package com.Backend.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "fines")
@Data
public class Fine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String referenceNumber;
    
    private String categoryId;
    
    private String categoryName;

    @Column(columnDefinition = "numeric")
    private Double amount;

    private String violationDescription;

    private String officerName;

    private String officerBadge;

    private OffsetDateTime issuedDate;

    private String location;

    private String status; // PENDING or PAID

    private UUID driverId;

    private String driverEmail;

    private OffsetDateTime createdAt = OffsetDateTime.now();
}
