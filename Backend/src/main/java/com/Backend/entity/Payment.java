package com.Backend.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.OffsetDateTime;

@Entity
@Table(name = "payments")
@Data
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String paymentId;

    private String fineReference;

    @Column(columnDefinition = "numeric")
    private Double amount;

    private String paymentMethod;

    private String cardHolder;
    
    private String status;

    private OffsetDateTime createdAt = OffsetDateTime.now();
}
