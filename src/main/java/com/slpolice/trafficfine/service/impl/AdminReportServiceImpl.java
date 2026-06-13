package com.slpolice.trafficfine.service.impl;

import com.slpolice.trafficfine.dto.AdminReportDto;
import com.slpolice.trafficfine.repository.PaymentRepository;
import com.slpolice.trafficfine.service.AdminReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;

@Service
public class AdminReportServiceImpl implements AdminReportService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Override
    public AdminReportDto getFullReport(LocalDateTime startDate, LocalDateTime endDate) {
        // Calculate collections for the specified date range
        BigDecimal totalCollection = paymentRepository.sumAmountByDateRange(startDate, endDate);
        Long totalPayments = paymentRepository.countByDateRange(startDate, endDate);

        // Fetch metrics specifically for today
        LocalDateTime startOfToday = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime endOfToday = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
        BigDecimal todayCollection = paymentRepository.sumAmountByDateRange(startOfToday, endOfToday);
        Long todayPayments = paymentRepository.countByDateRange(startOfToday, endOfToday);

        return AdminReportDto.builder()
                .totalCollection(totalCollection != null ? totalCollection : BigDecimal.ZERO)
                .totalPayments(totalPayments != null ? totalPayments : 0L)
                .todayCollection(todayCollection != null ? todayCollection : BigDecimal.ZERO)
                .todayPayments(todayPayments != null ? todayPayments : 0L)
                .districtCollections(new ArrayList<>()) // Can be dynamically expanded using custom aggregation rows
                .categoryCollections(new ArrayList<>())
                .build();
    }

    @Override
    public AdminReportDto getTodayReport() {
        return getFullReport(LocalDateTime.of(LocalDate.now(), LocalTime.MIN), LocalDateTime.of(LocalDate.now(), LocalTime.MAX));
    }

    @Override
    public AdminReportDto getWeekReport() {
        return getFullReport(LocalDateTime.now().minusDays(7), LocalDateTime.now());
    }

    @Override
    public AdminReportDto getMonthReport() {
        return getFullReport(LocalDateTime.now().minusMonths(1), LocalDateTime.now());
    }
}