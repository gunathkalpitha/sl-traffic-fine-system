package com.Backend.controller;

import com.Backend.dto.CreateUserRequest;
import com.Backend.entity.User;
import com.Backend.service.AdminReportService;
import com.Backend.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

/**
 * Admin-only endpoints. All routes under /api/admin/** require ADMIN role
 * (enforced in SecurityConfig).
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminController {

    private final AdminReportService reportService;
    private final AuthService authService;

    // GET /api/admin/reports/district?from=2025-01-01&to=2025-12-31
    @GetMapping("/reports/district")
    public ResponseEntity<?> districtCollections(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return ResponseEntity.ok(reportService.districtWiseCollections(from, to));
    }

    // GET /api/admin/reports/category?from=2025-01-01&to=2025-12-31
    @GetMapping("/reports/category")
    public ResponseEntity<?> categoryBreakdown(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return ResponseEntity.ok(reportService.categoryBreakdown(from, to));
    }

    // GET /api/admin/reports/summary?from=2025-01-01&to=2025-12-31
    @GetMapping("/reports/summary")
    public ResponseEntity<?> summaryStats(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return ResponseEntity.ok(reportService.summaryStats(from, to));
    }

    // POST /api/admin/users - Create a new OFFICER or ADMIN user
    @PostMapping("/users")
    public ResponseEntity<?> createUser(@Valid @RequestBody CreateUserRequest request) {
        try {
            User user = authService.createUser(request);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
