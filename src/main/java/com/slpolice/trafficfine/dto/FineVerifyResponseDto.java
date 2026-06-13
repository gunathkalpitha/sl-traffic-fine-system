package com.slpolice.trafficfine.dto;

import lombok.Data;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class FineVerifyResponseDto {
    private String referenceNumber;
    private String categoryCode;
    private String categoryName;
    private String driverName;
    private String driverLicense;
    private String vehicleNumber;
    private BigDecimal fineAmount;
    private LocalDateTime issuedAt;
    private LocalDateTime dueDate;
    private String status;
    private String districtName;
    private String officerName;
    private String officerBadge;
}