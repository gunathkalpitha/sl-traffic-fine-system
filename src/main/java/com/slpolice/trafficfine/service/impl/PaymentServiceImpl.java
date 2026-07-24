package com.slpolice.trafficfine.service.impl;

import com.slpolice.trafficfine.dto.FineVerifyResponseDto;
import com.slpolice.trafficfine.dto.PaymentRequestDto;
import com.slpolice.trafficfine.dto.PaymentResponseDto;
import com.slpolice.trafficfine.entity.Fine;
import com.slpolice.trafficfine.entity.Payment;
import com.slpolice.trafficfine.repository.FineRepository;
import com.slpolice.trafficfine.repository.PaymentRepository;
import com.slpolice.trafficfine.service.EmailService;
import com.slpolice.trafficfine.service.PaymentService;
import com.slpolice.trafficfine.service.SmsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    private FineRepository fineRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private SmsService smsService;

    @Autowired
    private EmailService emailService;

    @Override
    public FineVerifyResponseDto verifyFine(String referenceNumber, String categoryCode) {
        Fine fine = fineRepository.findByReferenceNumberAndCategoryCategoryCode(referenceNumber, categoryCode)
                .orElseThrow(() -> new RuntimeException("Fine not found with the given Reference Number and Category Code"));

        return FineVerifyResponseDto.builder()
                .referenceNumber(fine.getReferenceNumber())
                .categoryCode(fine.getCategory().getCategoryCode())
                .categoryName(fine.getCategory().getCategoryName())
                .driverName(fine.getDriverName())
                .driverLicense(fine.getDriverLicense())
                .vehicleNumber(fine.getVehicleNumber())
                .fineAmount(fine.getFineAmount())
                .issuedAt(fine.getIssuedAt())
                .dueDate(fine.getDueDate())
                .status(fine.getStatus().name())
                .districtName(fine.getDistrict() != null ? fine.getDistrict().getDistrictName() : "N/A")
                .officerName(fine.getIssuingOfficer().getFullName())
                .officerBadge(fine.getIssuingOfficer().getBadgeNumber())
                .build();
    }

    @Override
    @Transactional
    public PaymentResponseDto processPayment(PaymentRequestDto request) {
        // 1. Fetch and Verify the Fine exists
        Fine fine = fineRepository.findByReferenceNumberAndCategoryCategoryCode(request.getReferenceNumber(), request.getCategoryCode())
                .orElseThrow(() -> new RuntimeException("Fine verification failed during transaction processing"));

        // 2. Prevent double payment
        if (fine.getStatus() == Fine.FineStatus.PAID) {
            throw new RuntimeException("This traffic fine has already been settled