package com.Backend.service;

import com.Backend.entity.Fine;
import com.Backend.entity.Payment;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${app.mail.from}")
    private String fromAddress;

    @Value("${app.mail.from-name}")
    private String fromName;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    /**
     * Sends a payment receipt/confirmation email. Runs asynchronously so it
     * never blocks or fails the payment API response.
     */
    @Async
    public void sendPaymentConfirmation(Payment payment, Fine fine) {
        if (fine.getDriverEmail() == null || fine.getDriverEmail().isBlank()) {
            log.info("No email on file for fine {}, skipping email receipt", fine.getReferenceNumber());
            return;
        }

        String subject = "Payment Confirmation - Fine " + fine.getReferenceNumber();
        String html = buildReceiptHtml(payment, fine);

        try {
            sendHtml(fine.getDriverEmail(), subject, html);
            log.info("Sent payment confirmation email for fine {} to {}", fine.getReferenceNumber(), fine.getDriverEmail());
        } catch (Exception e) {
            log.error("Failed to send payment confirmation email for fine {}: {}", fine.getReferenceNumber(), e.getMessage());
        }
    }

    /**
     * Sends a notice when a fine is first issued.
     */
    @Async
    public void sendFineIssuedNotice(Fine fine) {
        if (fine.getDriverEmail() == null || fine.getDriverEmail().isBlank()) {
            return;
        }

        String subject = "Traffic Fine Issued - " + fine.getReferenceNumber();
        String html = "<div style=\"font-family:Arial,sans-serif;max-width:520px;margin:auto\">"
                + "<h2 style=\"color:#c0392b\">Traffic Fine Notice</h2>"
                + "<p>A traffic fine has been issued to you.</p>"
                + "<table style=\"width:100%;border-collapse:collapse\">"
                + row("Reference Number", fine.getReferenceNumber())
                + row("Category", fine.getCategoryName() != null ? fine.getCategoryName() : "-")
                + row("Amount", "LKR " + fine.getAmount())
                + row("Issued At", fine.getIssuedDate() != null ? fine.getIssuedDate().format(FORMATTER) : "-")
                + "</table>"
                + "<p>Pay online using your reference number to avoid penalties for late payment.</p>"
                + "</div>";

        try {
            sendHtml(fine.getDriverEmail(), subject, html);
        } catch (Exception e) {
            log.error("Failed to send fine issued email for {}: {}", fine.getReferenceNumber(), e.getMessage());
        }
    }

    private String buildReceiptHtml(Payment payment, Fine fine) {
        return "<div style=\"font-family:Arial,sans-serif;max-width:520px;margin:auto\">"
                + "<h2 style=\"color:#1e8449\">Payment Received</h2>"
                + "<p>Your traffic fine payment has been processed successfully.</p>"
                + "<table style=\"width:100%;border-collapse:collapse\">"
                + row("Reference Number", fine.getReferenceNumber())
                + row("Category", fine.getCategoryName() != null ? fine.getCategoryName() : "-")
                + row("Amount Paid", "LKR " + payment.getAmount())
                + row("Payment Method", payment.getPaymentMethod())
                + row("Paid At", payment.getCreatedAt() != null ? payment.getCreatedAt().format(FORMATTER) : "-")
                + row("Status", "PAID")
                + "</table>"
                + "<p style=\"color:#888;font-size:12px\">Keep this email as your receipt. "
                + "This is an automated message from the Sri Lanka Traffic Fine System.</p>"
                + "</div>";
    }

    private String row(String label, String value) {
        return "<tr>"
                + "<td style=\"padding:6px;border-bottom:1px solid #eee;color:#666\">" + escape(label) + "</td>"
                + "<td style=\"padding:6px;border-bottom:1px solid #eee;font-weight:bold\">" + escape(value) + "</td>"
                + "</tr>";
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("<", "&lt;").replace(">", "&gt;");
    }

    private void sendHtml(String to, String subject, String htmlBody) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        helper.setFrom(fromAddress);
        helper.setTo(to);
        helper.setSubject(subject);
        helper.setText(htmlBody, true);
        mailSender.send(message);
    }
}
