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

    // Generate unique reference number
    private String generateReference() {
        return "TF-" + System.currentTimeMillis();
    }

    // Issue a new fine
    public Fine issueFine(Map<String, Object> body) {

        Long categoryId = Long.valueOf(body.get("categoryId").toString());
        Long officerId  = Long.valueOf(body.get("officerId").toString());
        Long districtId = Long.valueOf(body.get("districtId").toString());

        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        Officer officer = officerRepository.findById(officerId)
                .orElseThrow(() -> new RuntimeException("Officer not found"));

        District district = districtRepository.findById(districtId)
                .orElseThrow(() -> new RuntimeException("District not found"));

        Fine fine = new Fine();
        fine.setReferenceNumber(generateReference());
        fine.setCategory(category);
        fine.setOfficer(officer);
        fine.setDistrict(district);
        fine.setVehicleNumber(body.get("vehicleNumber").toString());
        fine.setDriverName(body.get("driverName").toString());
        fine.setAmount(category.getFineAmount());
        fine.setStatus("PENDING");

        return fineRepository.save(fine);
    }

    // Get fine by reference number
    public Optional<Fine> getFineByReference(String referenceNumber) {
        return fineRepository.findByReferenceNumber(referenceNumber);
    }

    // Get fine by reference number and category
    public Optional<Fine> getFineByReferenceAndCategory(
            String referenceNumber, Long categoryId) {
        return fineRepository
                .findByReferenceNumberAndCategory_Id(
                        referenceNumber, categoryId
                );
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
}
