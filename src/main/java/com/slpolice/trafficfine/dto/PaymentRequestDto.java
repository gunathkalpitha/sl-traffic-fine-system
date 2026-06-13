package com.slpolice.trafficfine.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PaymentRequestDto {

    @NotBlank(message = "Reference number is required")
    private String referenceNumber;

    @NotBlank(message = "Category code is required")
    private String categoryCode;

    @NotBlank(message = "Payer name is required")
    private String payerName;

    @NotBlank(message = "Payer email is required")
    private String payerEmail;

    private String payerPhone;

    @NotBlank(message = "Payment method is required")
    private String paymentMethod; // CARD or ONLINE

    // Card details
    private String cardNumber;
    private String cardExpiry;
    private String cardCvv;
    private String cardHolderName;
}