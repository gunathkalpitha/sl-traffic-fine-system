package com.Backend.controller;

import com.Backend.entity.Category;
import com.Backend.entity.District;
import com.Backend.entity.Fine;
import com.Backend.entity.Officer;
import com.Backend.service.FineService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/fines")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FineController {

    private final FineService fineService;

    // POST /api/fines/issue
    @PostMapping("/issue")
    public ResponseEntity<?> issueFine(@RequestBody Map<String, Object> body) {
        try {
            Fine fine = fineService.issueFine(body);
            return ResponseEntity.ok(fine);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // GET /api/fines/lookup/{referenceNumber}
    @GetMapping("/lookup/{referenceNumber}")
    public ResponseEntity<?> lookupFine(
            @PathVariable String referenceNumber) {
        Optional<Fine> fine =
                fineService.getFineByReference(referenceNumber);

        if (fine.isPresent()) {
            return ResponseEntity.ok(fine.get());
        } else {
            return ResponseEntity.badRequest()
                    .body("Fine not found");
        }
    }

    // GET /api/fines/categories
    @GetMapping("/categories")
    public ResponseEntity<List<Category>> getCategories() {
        return ResponseEntity.ok(fineService.getAllCategories());
    }

    // GET /api/fines/districts
    @GetMapping("/districts")
    public ResponseEntity<List<District>> getDistricts() {
        return ResponseEntity.ok(fineService.getAllDistricts());
    }

    // GET /api/fines/officers
    @GetMapping("/officers")
    public ResponseEntity<List<Officer>> getOfficers() {
        return ResponseEntity.ok(fineService.getAllOfficers());
    }

    // GET /api/fines/driver?driverId={driverId}&email={email}
    @GetMapping("/driver")
    public ResponseEntity<?> getFinesByDriver(
            @RequestParam(required = false) String driverId,
            @RequestParam(required = false) String email) {
        try {
            java.util.UUID uuid = null;
            if (driverId != null && !driverId.isBlank() && !driverId.equals("undefined")) {
                uuid = java.util.UUID.fromString(driverId);
            }
            List<Fine> fines = fineService.getFinesByDriver(uuid, email);
            return ResponseEntity.ok(fines);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // GET /api/fines/driver/stats?driverId={driverId}&email={email}
    @GetMapping("/driver/stats")
    public ResponseEntity<?> getDriverStats(
            @RequestParam(required = false) String driverId,
            @RequestParam(required = false) String email) {
        try {
            java.util.UUID uuid = null;
            if (driverId != null && !driverId.isBlank() && !driverId.equals("undefined")) {
                uuid = java.util.UUID.fromString(driverId);
            }
            Map<String, Object> stats = fineService.getDriverStats(uuid, email);
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}