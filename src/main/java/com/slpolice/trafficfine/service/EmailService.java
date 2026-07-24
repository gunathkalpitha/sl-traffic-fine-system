package com.slpolice.trafficfine.service;

import com.slpolice.trafficfine.entity.Payment;

public interface EmailService {
    boolean sendPaymentReceiptToDriver(Payment payment);
    boolean sendPaymentNotificationToAdmin(Payment payment);
}