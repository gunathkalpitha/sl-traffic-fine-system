package com.Backend.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
@Data
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "fine_id")
    private Fine fine;

    private Double amount;

    private String paymentMethod;

    private LocalDateTime paidAt = LocalDateTime.now();
}
