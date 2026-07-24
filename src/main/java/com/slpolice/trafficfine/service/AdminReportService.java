package com.slpolice.trafficfine.service;

import com.slpolice.trafficfine.dto.AdminReportDto;
import java.time.LocalDateTime;

public interface AdminReportService {
    
    /**
     * Generates a custom collection report between two specific dates.
     */
    AdminReportDto getFullReport(LocalDateTime startDate, LocalDateTime endDate);
    
    /**
     * Generates a summary report for today's collections.
     */
    AdminReportDto getTodayReport();
    
    /**
     * Generates a summary report for the past 7 days.
     */
    AdminReportDto getWeekReport();
    
    /**
     * Generates a summary report for the past 30 days.
     */
    AdminReportDto getMonthReport();
}