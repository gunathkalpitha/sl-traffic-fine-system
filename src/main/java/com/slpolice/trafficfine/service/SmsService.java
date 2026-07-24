package com.slpolice.trafficfine.service;

public interface SmsService {
    boolean sendSms(String toPhoneNumber, String message);
    boolean sendPaymentConfirmationToOfficer(String officerPhone, String officerName,
                                             String referenceNumber, String driverName,
                                             String vehicleNumber, String amount);
}