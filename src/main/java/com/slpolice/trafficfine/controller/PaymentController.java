package com.slpolice.trafficfine.controller;

import com.slpolice.trafficfine.dto.ApiResponseDto;
import com.slpolice.trafficfine.dto.FineVerifyResponseDto;
import com.slpolice.trafficfine.dto.PaymentRequestDto;
import com.slpolice.trafficfine.dto.PaymentResponseDto;
import com.slpolice.trafficfine.service.PaymentService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @GetMapping("/verify")
    public ResponseEntity<ApiResponseDto<FineVerifyResponseDto>> verifyFine(
            @RequestParam String referenceNumber, 
            @RequestParam String categoryCode) {
        try {
            FineVerifyResponseDto data = paymentService.verifyFine(referenceNumber, categoryCode);
            return ResponseEntity.ok(ApiResponseDto.success("Fine record verified successfully", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponseDto.error(e.getMessage()));
        }
    }

    @PostMapping("/process")
    public ResponseEntity<ApiResponseDto<PaymentResponseDto>> processPayment(
            @Valid @RequestBody PaymentRequestDto request) {
        try {
            PaymentResponseDto response = paymentService.processPayment(request);
            return ResponseEntity.ok(ApiResponseDto.success("Payment processed successfully context completed", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponseDto.error(e.getMessage()));
        }
    }
}