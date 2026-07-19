package com.Backend.controller;

import com.Backend.entity.Payment;
import com.Backend.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PaymentController {

    private final PaymentService paymentService;

    // POST /api/payments/pay
    @PostMapping("/pay")
    public ResponseEntity<?> pay(@RequestBody Map<String, Object> body) {
        try {
            Payment payment = paymentService.processPayment(body);
            return ResponseEntity.ok(payment);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}