package com.slpolice.trafficfine.service.impl;

import com.slpolice.trafficfine.service.SmsService;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class SmsServiceImpl implements SmsService {

    private static final Logger logger = LoggerFactory.getLogger(SmsServiceImpl.class);

    @Value("${twilio.phone.number}")
    private String twilioPhoneNumber;

    @Override
    public boolean sendSms(String toPhoneNumber, String message) {
        try {
            String formattedNumber = formatPhoneNumber(toPhoneNumber);

            Message twilioMessage = Message.creator(
                    new PhoneNumber(formattedNumber),
                    new PhoneNumber(twilioPhoneNumber),
                    message
            ).create();

            logger.info("SMS sent successfully. SID: {}, To: {}", twilioMessage.getSid(), formattedNumber);
            return true;
        } catch (Exception e) {
            logger.error("Failed to send SMS to {}: {}", toPhoneNumber, e.getMessage());
            return false;
        }
    }

    @Override
    public boolean sendPaymentConfirmationToOfficer(String officerPhone, String officerName,
                                                    String referenceNumber, String driverName,
                                                    String vehicleNumber, String amount) {
        String message = String.format(
                "SL Traffic Fine System\n" +
                "Dear Officer %s,\n" +
                "Payment Confirmed!\n" +
                "Fine Ref: %s\n" +
                "Driver: %s\n" +
                "Vehicle: %s\n" +
                "Amount: LKR %s\n" +
                "Please release the driver's license.\n" +
                "- SL Police Department",
                officerName, referenceNumber, driverName, vehicleNumber, amount
        );

        return sendSms(officerPhone, message);
    }

    private String formatPhoneNumber(String phoneNumber) {
        if (phoneNumber == null) return phoneNumber;
        String cleaned = phoneNumber.replaceAll("[\\s\\-()]", "");

        if (cleaned.startsWith("+")) {
            return cleaned;
        } else if (cleaned.startsWith("94")) {
            return "+" + cleaned;
        } else if (cleaned.startsWith("0")) {
            return "+94" + cleaned.substring(1);
        }
        return "+94" + cleaned;
    }
}