package com.slpolice.trafficfine.dto;

import lombok.Data;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResponseDto {
    private String transactionId;
    private String referenceNumber;
    private BigDecimal amountPaid;
    private String paymentMethod;
    private String payerName;
    private LocalDateTime paidAt;
    private String status;
    private String gatewayReference;
}