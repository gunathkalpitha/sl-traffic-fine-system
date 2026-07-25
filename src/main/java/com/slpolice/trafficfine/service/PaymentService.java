package com.slpolice.trafficfine.service;

import com.slpolice.trafficfine.dto.FineVerifyResponseDto;
import com.slpolice.trafficfine.dto.PaymentRequestDto;
import com.slpolice.trafficfine.dto.PaymentResponseDto;

public interface PaymentService {
    
    /**
     * Verifies if a traffic fine exists in the system based on reference number and category code.
     */
    FineVerifyResponseDto verifyFine(String referenceNumber, String categoryCode);
    
    /**
     * Processes the fine payment, updates fine status, and triggers SMS and Email notifications.
     */
    PaymentResponseDto processPayment(PaymentRequestDto request);
    
    /**
     * Retrieves previous payment receipt logs using a unique transaction ID.
     */
    PaymentResponseDto getPaymentByTransactionId(String transactionId);
}