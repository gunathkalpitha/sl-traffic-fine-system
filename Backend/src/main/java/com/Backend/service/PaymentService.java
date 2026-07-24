package com.Backend.service;


import com.Backend.entity.Fine;
import com.Backend.entity.Payment;
import com.Backend.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final FineService fineService;
    private final NotificationService notificationService;

    public Payment processPayment(Map<String, Object> body) {

        String referenceNumber = body.get("referenceNumber").toString();
        Long categoryId = Long.valueOf(body.get("categoryId").toString());

        // Find the fine
        Fine fine = fineService
                .getFineByReferenceAndCategory(referenceNumber, categoryId)
                .orElseThrow(() ->
                        new RuntimeException("Fine not found")
                );

        // Check if already paid
        if (fine.getStatus().equals("PAID")) {
            throw new RuntimeException("Fine is already paid");
        }

        // Save payment record
        Payment payment = new Payment();
        payment.setPaymentId("PAY-" + System.currentTimeMillis());
        payment.setFineReference(fine.getReferenceNumber());
        payment.setAmount(fine.getAmount());
        payment.setPaymentMethod(body.get("paymentMethod").toString());
        payment.setStatus("COMPLETED");

        paymentRepository.save(payment);

        // Update fine status to PAID
        fineService.markAsPaid(fine);

        // Send email receipt + SMS notification (async, non-blocking)
        notificationService.notifyPaymentConfirmation(payment, fine);

        return payment;
    }
}

