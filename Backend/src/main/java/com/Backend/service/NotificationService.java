package com.Backend.service;

import com.Backend.entity.Fine;
import com.Backend.entity.Payment;
import com.Backend.repository.OfficerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final EmailService emailService;
    private final SmsService smsService;
    private final OfficerRepository officerRepository;

    public void notifyPaymentConfirmation(Payment payment, Fine fine) {
        emailService.sendPaymentConfirmation(payment, fine);
        
        String officerPhone = getOfficerPhone(fine.getOfficerBadge());
        smsService.sendPaymentConfirmationSms(payment, fine, officerPhone);
    }

    public void notifyFineIssued(Fine fine) {
        emailService.sendFineIssuedNotice(fine);
        
        String officerPhone = getOfficerPhone(fine.getOfficerBadge());
        smsService.sendFineIssuedSms(fine, officerPhone);
    }
    
    private String getOfficerPhone(String badge) {
        if (badge == null || badge.isBlank()) return null;
        return officerRepository.findByBadgeNumber(badge)
                .map(o -> o.getPhoneNumber())
                .orElse(null);
    }
}
