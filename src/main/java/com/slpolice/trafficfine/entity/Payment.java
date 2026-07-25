package com.slpolice.trafficfine.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fine_id", unique = true, nullable = false)
    private Fine fine;

    @Column(name = "transaction_id", unique = true, nullable = false)
    private String transactionId;

    @Column(name = "amount_paid", nullable = false, precision = 10, scale = 2)
    private BigDecimal amountPaid;

    @Column(name = "payment_method", nullable = false)
    private String paymentMethod;  // CARD, ONLINE

    @Column(name = "card_last_four")
    private String cardLastFour;

    @Column(name = "payer_name")
    private String payerName;

    @Column(name = "payer_email")
    private String payerEmail;

    @Column(name = "payer_phone")
    private String payerPhone;

    @Column(name = "paid_at", nullable = false)
    private LocalDateTime paidAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PaymentStatus status = PaymentStatus.SUCCESS;

    @Column(name = "gateway_reference")
    private String gatewayReference;

    @Column(name = "sms_sent")
    private Boolean smsSent = false;

    @Column(name = "email_sent")
    private Boolean emailSent = false;

    public enum PaymentStatus {
        SUCCESS, FAILED, REFUNDED
    }
}