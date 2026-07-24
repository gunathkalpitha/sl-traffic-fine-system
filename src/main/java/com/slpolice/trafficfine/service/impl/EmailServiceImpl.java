package com.slpolice.trafficfine.service.impl;

import com.slpolice.trafficfine.entity.Payment;
import com.slpolice.trafficfine.service.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.time.format.DateTimeFormatter;

@Service
public class EmailServiceImpl implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailServiceImpl.class);
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Value("${app.admin.email}")
    private String adminEmail;

    @Override
    public boolean sendPaymentReceiptToDriver(Payment payment) {
        if (payment.getPayerEmail() == null || payment.getPayerEmail().isEmpty()) {
            logger.warn("No driver email profile found for transaction context: {}", payment.getTransactionId());
            return false;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(payment.getPayerEmail());
            helper.setSubject("Traffic Fine Payment Receipt - " + payment.getFine().getReferenceNumber());
            helper.setText(buildDriverReceiptHtml(payment), true);

            mailSender.send(message);
            logger.info("Payment receipt email sent successfully to: {}", payment.getPayerEmail());
            return true;
        } catch (MessagingException e) {
            logger.error("Failed to compile or deliver receipt mailing context: {}", e.getMessage());
            return false;
        }
    }

    @Override
    public boolean sendPaymentNotificationToAdmin(Payment payment) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(adminEmail);
            helper.setSubject("[ADMIN] New Traffic Fine Payment Captured - " + payment.getFine().getReferenceNumber());
            helper.setText(buildAdminNotificationHtml(payment), true);

            mailSender.send(message);
            logger.info("Admin system audit report dispatched: {}", payment.getTransactionId());
            return true;
        } catch (MessagingException e) {
            logger.error("Failed to route notification context loop: {}", e.getMessage());
            return false;
        }
    }

    private String buildDriverReceiptHtml(Payment payment) {
        return "<!DOCTYPE html><html><head><style>" +
               "body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 0; padding: 0; }" +
               ".container { max-width: 600px; margin: 40px auto; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }" +
               ".header { background: #1a3a5c; color: white; padding: 24px; text-align: center; }" +
               ".header h1 { margin: 0; font-size: 22px; }" +
               ".body { padding: 28px; }" +
               ".success-badge { background: #e6f9f0; border: 1px solid #2ecc71; color: #27ae60; padding: 10px 16px; border-radius: 6px; text-align: center; font-weight: bold; margin-bottom: 20px; }" +
               ".row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; font-size: 14px; }" +
               ".label { color: #777; }" +
               ".value { font-weight: bold; color: #333; }" +
               ".amount-row { font-size: 18px; color: #1a3a5c; margin-top: 8px; }" +
               ".footer { background: #f9f9f9; padding: 16px; text-align: center; font-size: 12px; color: #aaa; }" +
               "</style></head><body><div class='container'>" +
               "  <div class='header'><h1>Sri Lanka Police Department</h1><p>Traffic Fine Payment Receipt</p></div>" +
               "  <div class='body'><div class='success-badge'>✓ Payment Successful</div>" +
               "    <div class='row'><span class='label'>Transaction ID</span><span class='value'>" + payment.getTransactionId() + "</span></div>" +
               "    <div class='row'><span class='label'>Fine Reference</span><span class='value'>" + payment.getFine().getReferenceNumber() + "</span></div>" +
               "    <div class='row'><span class='label'>Driver Name</span><span class='value'>" + payment.getFine().getDriverName() + "</span></div>" +
               "    <div class='row'><span class='label'>Vehicle Number</span><span class='value'>" + payment.getFine().getVehicleNumber() + "</span></div>" +
               "    <div class='row'><span class='label'>Payment Method</span><span class='value'>" + payment.getPaymentMethod() + "</span></div>" +
               "    <div class='row amount-row'><span class='label'>Amount Paid</span><span class='value'>LKR " + payment.getAmountPaid() + "</span></div>" +
               "  </div><div class='footer'>Official dispatch from Sri Lanka Police IT Core. Keep this record.</div>" +
               "</div></body></html>";
    }

    private String buildAdminNotificationHtml(Payment payment) {
        return "<!DOCTYPE html><html><head><style>" +
               "body { font-family: Arial, sans-serif; }" +
               ".container { max-width: 600px; margin: 20px auto; background: white; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }" +
               ".header { background: #2c3e50; color: white; padding: 16px 24px; }" +
               ".body { padding: 24px; }" +
               ".row { padding: 8px 0; border-bottom: 1px solid #eee; font-size: 14px; }" +
               ".label { color: #666; display: inline-block; width: 160px; }" +
               ".value { font-weight: bold; }" +
               "</style></head><body><div class='container'>" +
               "  <div class='header'><h2 style='margin:0'>System Audit Update</h2></div>" +
               "  <div class='body'><p>A payment has successfully closed fine context criteria validation.</p>" +
               "    <div class='row'><span class='label'>Transaction Ref:</span> <span class='value'>" + payment.getTransactionId() + "</span></div>" +
               "    <div class='row'><span class='label'>Fine Code:</span> <span class='value'>" + payment.getFine().getReferenceNumber() + "</span></div>" +
               "    <div class='row'><span class='label'>Collection Yield:</span> <span class='value'>LKR " + payment.getAmountPaid() + "</span></div>" +
               "  </div>" +
               "</div></body></html>";
    }
}