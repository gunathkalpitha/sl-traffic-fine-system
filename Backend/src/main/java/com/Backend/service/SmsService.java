package com.Backend.service;

import com.Backend.entity.Fine;
import com.Backend.entity.Payment;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * SMS notification service using Twilio.
 * Sends SMS to the traffic police officer when a fine payment is confirmed,
 * so the officer knows the driver can collect their license.
 */
@Service
@Slf4j
public class SmsService {

    @Value("${app.twilio.enabled:false}")
    private boolean twilioEnabled;

    @Value("${app.twilio.account-sid:}")
    private String accountSid;

    @Value("${app.twilio.auth-token:}")
    private String authToken;

    @Value("${app.twilio.phone-number:}")
    private String fromPhoneNumber;

    /**
     * Initialize Twilio SDK on application startup.
     */
    @PostConstruct
    public void init() {
        if (twilioEnabled && !accountSid.isBlank() && !authToken.isBlank()) {
            Twilio.init(accountSid, authToken);
            log.info("Twilio SMS service initialized successfully");
        } else {
            log.warn("Twilio SMS service is DISABLED. Set app.twilio.enabled=true with valid credentials to enable.");
        }
    }

    @Async
    public void sendPaymentConfirmationSms(Payment payment, Fine fine, String officerPhone) {
        if (!twilioEnabled || officerPhone == null || officerPhone.isBlank()) {
            log.info("SMS skipped for fine {} - Twilio disabled or no officer phone", fine.getReferenceNumber());
            return;
        }

        String messageBody = String.format(
                "Payment confirmed for fine %s. Amount: LKR %.2f. Driver can collect their license. - SL Traffic Fine System",
                fine.getReferenceNumber(),
                payment.getAmount()
        );

        sendSms(officerPhone, messageBody);
    }

    /**
     * Send SMS to the OFFICER when a fine is issued (optional confirmation).
     */
    @Async
    public void sendFineIssuedSms(Fine fine, String officerPhone) {
        if (!twilioEnabled || officerPhone == null || officerPhone.isBlank()) {
            return;
        }

        String messageBody = String.format(
                "Fine %s issued. Amount: LKR %.2f. Category: %s. - SL Traffic Fine System",
                fine.getReferenceNumber(),
                fine.getAmount(),
                fine.getCategoryName() != null ? fine.getCategoryName() : "N/A"
        );

        sendSms(officerPhone, messageBody);
    }

    /**
     * Core method: sends an SMS via Twilio API.
     */
    private void sendSms(String toPhoneNumber, String messageBody) {
        try {
            Message message = Message.creator(
                    new PhoneNumber(toPhoneNumber),   // to: officer's phone
                    new PhoneNumber(fromPhoneNumber),  // from: your Twilio number
                    messageBody
            ).create();

            log.info("SMS sent successfully! SID: {}, To: {}, Status: {}",
                    message.getSid(), toPhoneNumber, message.getStatus());
        } catch (Exception e) {
            log.error("Failed to send SMS to {}: {}", toPhoneNumber, e.getMessage());
        }
    }
}
