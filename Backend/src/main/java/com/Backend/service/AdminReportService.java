package com.Backend.service;

import com.Backend.entity.Fine;
import com.Backend.entity.Payment;
import com.Backend.repository.FineRepository;
import com.Backend.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Admin reporting service: location-wise collections, category breakdown, summary stats.
 * All endpoints require ADMIN role (enforced in SecurityConfig).
 */
@Service
@RequiredArgsConstructor
public class AdminReportService {

    private final PaymentRepository paymentRepository;
    private final FineRepository fineRepository;

    /**
     * Get payments filtered by date range. Pass null for "all time".
     */
    private List<Payment> getPayments(LocalDate from, LocalDate to) {
        List<Payment> all = paymentRepository.findAll();

        return all.stream().filter(p -> {
            OffsetDateTime paidAt = p.getCreatedAt();
            if (paidAt == null) return false;
            if (from != null && paidAt.isBefore(from.atStartOfDay(ZoneOffset.UTC).toOffsetDateTime())) return false;
            if (to != null && paidAt.isAfter(to.atTime(LocalTime.MAX).atOffset(ZoneOffset.UTC))) return false;
            return true;
        }).collect(Collectors.toList());
    }

    /**
     * Location-wise collection totals.
     */
    public List<Map<String, Object>> districtWiseCollections(LocalDate from, LocalDate to) {
        List<Payment> payments = getPayments(from, to);

        Map<String, Double> districtTotals = new LinkedHashMap<>();
        Map<String, Long> districtCounts = new LinkedHashMap<>();

        for (Payment p : payments) {
            String location = "Unknown";
            if (p.getFineReference() != null) {
                location = fineRepository.findByReferenceNumber(p.getFineReference())
                        .map(Fine::getLocation)
                        .orElse("Unknown");
            }

            districtTotals.merge(location, p.getAmount(), Double::sum);
            districtCounts.merge(location, 1L, Long::sum);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (String district : districtTotals.keySet()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("district", district); // keeping key "district" for backwards compatibility in frontend if any
            row.put("totalAmount", districtTotals.get(district));
            row.put("paymentCount", districtCounts.get(district));
            result.add(row);
        }

        // Sort by total descending
        result.sort((a, b) -> Double.compare((Double) b.get("totalAmount"), (Double) a.get("totalAmount")));
        return result;
    }

    /**
     * Category breakdown of collections.
     */
    public List<Map<String, Object>> categoryBreakdown(LocalDate from, LocalDate to) {
        List<Payment> payments = getPayments(from, to);

        Map<String, Double> categoryTotals = new LinkedHashMap<>();
        Map<String, Long> categoryCounts = new LinkedHashMap<>();

        for (Payment p : payments) {
            String category = "Unknown";
            if (p.getFineReference() != null) {
                category = fineRepository.findByReferenceNumber(p.getFineReference())
                        .map(Fine::getCategoryName)
                        .orElse("Unknown");
            }

            categoryTotals.merge(category, p.getAmount(), Double::sum);
            categoryCounts.merge(category, 1L, Long::sum);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (String category : categoryTotals.keySet()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("category", category);
            row.put("totalAmount", categoryTotals.get(category));
            row.put("paymentCount", categoryCounts.get(category));
            result.add(row);
        }

        result.sort((a, b) -> Double.compare((Double) b.get("totalAmount"), (Double) a.get("totalAmount")));
        return result;
    }

    /**
     * Summary stats: total revenue, payment count, average, top district, top category.
     */
    public Map<String, Object> summaryStats(LocalDate from, LocalDate to) {
        List<Payment> payments = getPayments(from, to);

        double totalRevenue = payments.stream().mapToDouble(p -> p.getAmount() != null ? p.getAmount() : 0.0).sum();
        long totalPayments = payments.size();
        double average = totalPayments > 0 ? totalRevenue / totalPayments : 0;

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("totalRevenue", totalRevenue);
        stats.put("totalPayments", totalPayments);
        stats.put("averagePayment", Math.round(average * 100.0) / 100.0);

        // Top district
        List<Map<String, Object>> districts = districtWiseCollections(from, to);
        stats.put("topDistrict", districts.isEmpty() ? null : districts.get(0).get("district"));

        // Top category
        List<Map<String, Object>> categories = categoryBreakdown(from, to);
        stats.put("topCategory", categories.isEmpty() ? null : categories.get(0).get("category"));

        return stats;
    }
}
