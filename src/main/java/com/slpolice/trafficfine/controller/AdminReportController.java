package com.slpolice.trafficfine.controller;

import com.slpolice.trafficfine.dto.AdminReportDto;
import com.slpolice.trafficfine.dto.ApiResponseDto;
import com.slpolice.trafficfine.service.AdminReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/reports")
@PreAuthorize("hasRole('ADMIN')")
public class AdminReportController {

    @Autowired
    private AdminReportService reportService;

    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponseDto<AdminReportDto>> getDashboardSummary() {
        try {
            AdminReportDto data = reportService.getTodayReport();
            return ResponseEntity.ok(ApiResponseDto.success("Admin statistics report loaded successfully", data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponseDto.error(e.getMessage()));
        }
    }
}