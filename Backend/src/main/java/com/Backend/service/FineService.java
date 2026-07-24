package com.Backend.service;

import com.Backend.entity.*;
import com.Backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FineService {

    private final FineRepository fineRepository;
    private final CategoryRepository categoryRepository;
    private final OfficerRepository officerRepository;
    private final DistrictRepository districtRepository;
    private final NotificationService notificationService;

    // Generate unique reference number
    private String generateReference() {
        return "TF-" + System.currentTimeMillis();
    }

    // Issue a new fine
    public Fine issueFine(Map<String, Object> body) {

        Long categoryId = Long.valueOf(body.get("categoryId").toString());
        Long districtId = Long.valueOf(body.get("districtId").toString());
        String officerName = body.get("officerName") != null ? body.get("officerName").toString() : "Unknown Officer";
        String officerBadge = body.get("officerBadge") != null ? body.get("officerBadge").toString() : "000";

        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        District district = districtRepository.findById(districtId)
                .orElseThrow(() -> new RuntimeException("District not found"));

        officerRepository.findByNameAndBadgeNumber(officerName, officerBadge)
                .orElseGet(() -> {
                    Officer newOfficer = new Officer();
                    newOfficer.setName(officerName);
                    newOfficer.setBadgeNumber(officerBadge);
                    newOfficer.setDistrict(district);
                    return officerRepository.save(newOfficer);
                });

        Fine fine = new Fine();
        fine.setReferenceNumber(generateReference());
        fine.setCategoryId(String.valueOf(categoryId));
        fine.setCategoryName(category.getName());
        fine.setLocation(district.getName());
        fine.setOfficerName(officerName);
        fine.setOfficerBadge(officerBadge);
        fine.setDriverName(body.get("driverName") != null ? body.get("driverName").toString() : null);
        fine.setDriverEmail(body.get("driverEmail") != null ? body.get("driverEmail").toString() : null);
        fine.setVehicleNumber(body.get("vehicleNumber") != null ? body.get("vehicleNumber").toString() : null);
        
        if (body.get("driverId") != null && !body.get("driverId").toString().isBlank()) {
            try {
                fine.setDriverId(java.util.UUID.fromString(body.get("driverId").toString()));
            } catch (Exception e) {
                System.err.println("Failed to parse driverId UUID: " + e.getMessage());
            }
        }

        String driverPhone = body.get("driverPhone") != null ? body.get("driverPhone").toString() : null;
        fine.setDriverPhone(driverPhone);
        
        String phoneSuffix = (driverPhone != null && !driverPhone.isBlank()) ? " | Phone: " + driverPhone : "";
        fine.setViolationDescription("Vehicle: " + fine.getVehicleNumber() + " | Driver: " + fine.getDriverName() + phoneSuffix);
        
        fine.setAmount(category.getFineAmount());
        fine.setViolationDescription(category.getDescription());
        fine.setStatus("PENDING");

        Fine savedFine = fineRepository.save(fine);
        // Retain the transient driverPhone for notifyFineIssued after DB save
        savedFine.setDriverPhone(driverPhone);
        try {
            notificationService.notifyFineIssued(savedFine);
        } catch (Exception e) {
            // Log warning but don't fail the API call
            System.err.println("Failed to send fine issued notification: " + e.getMessage());
        }
        return savedFine;
    }

    // Get fine by reference number
    public Optional<Fine> getFineByReference(String referenceNumber) {
        return fineRepository.findByReferenceNumber(referenceNumber);
    }

    // Get fine by reference number and category
    public Optional<Fine> getFineByReferenceAndCategory(
            String referenceNumber, String categoryId) {
        return fineRepository.findByReferenceNumberAndCategoryId(referenceNumber, categoryId);
    }

    // Get all categories
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    // Get all districts
    public List<District> getAllDistricts() {
        return districtRepository.findAll();
    }

    // Get all officers
    public List<Officer> getAllOfficers() {
        return officerRepository.findAll();
    }

    // Mark fine as PAID
    public Fine markAsPaid(Fine fine) {
        fine.setStatus("PAID");
        return fineRepository.save(fine);
    }

    public List<Fine> getFinesByDriver(java.util.UUID driverId, String email) {
        return fineRepository.findByDriverIdOrDriverEmailOrderByIssuedAtDesc(driverId, email);
    }

    public java.util.Map<String, Object> getDriverStats(java.util.UUID driverId, String email) {
        Long pendingCount = fineRepository.countByDriverAndStatus(driverId, email, "PENDING");
        Long paidCount = fineRepository.countByDriverAndStatus(driverId, email, "PAID");
        Double pendingSum = fineRepository.sumAmountByDriverAndStatus(driverId, email, "PENDING");
        
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("pendingCount", pendingCount != null ? pendingCount : 0L);
        stats.put("paidCount", paidCount != null ? paidCount : 0L);
        stats.put("pendingAmount", pendingSum != null ? pendingSum : 0.0);
        return stats;
    }
}
