package com.Backend.repository;


import com.Backend.entity.Fine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;
import java.util.List;
import java.util.UUID;

public interface FineRepository
        extends JpaRepository<Fine, Long> {

    // Find fine by reference number
    Optional<Fine> findByReferenceNumber(String referenceNumber);

    // Find fine by reference number and category
    Optional<Fine> findByReferenceNumberAndCategoryId(String referenceNumber, String categoryId);

    @org.springframework.data.jpa.repository.Query("SELECT SUM(f.amount) FROM Fine f")
    Double sumTotalAmount();

    @org.springframework.data.jpa.repository.Query("SELECT COUNT(f) FROM Fine f WHERE f.status = 'PAID'")
    Long countPaidFines();

    @org.springframework.data.jpa.repository.Query("SELECT COUNT(f) FROM Fine f WHERE f.status = 'PENDING'")
    Long countPendingFines();

    @org.springframework.data.jpa.repository.Query("SELECT COUNT(DISTINCT f.location) FROM Fine f WHERE f.location IS NOT NULL")
    Long countActiveDistricts();

    @org.springframework.data.jpa.repository.Query("SELECT new com.Backend.dto.DistrictReportDTO(f.location, COUNT(f), SUM(f.amount)) " +
            "FROM Fine f WHERE f.location IS NOT NULL GROUP BY f.location")
    java.util.List<com.Backend.dto.DistrictReportDTO> getDistrictReport();

    @org.springframework.data.jpa.repository.Query("SELECT new com.Backend.dto.CategoryReportDTO(f.categoryName, f.categoryId, COUNT(f), SUM(f.amount)) " +
            "FROM Fine f WHERE f.categoryName IS NOT NULL GROUP BY f.categoryName, f.categoryId")
    java.util.List<com.Backend.dto.CategoryReportDTO> getCategoryReport();

    @Query("SELECT f FROM Fine f WHERE f.driverId = :driverId OR f.driverEmail = :driverEmail ORDER BY f.issuedAt DESC")
    List<Fine> findByDriverIdOrDriverEmailOrderByIssuedAtDesc(@Param("driverId") UUID driverId, @Param("driverEmail") String driverEmail);

    @Query("SELECT COUNT(f) FROM Fine f WHERE (f.driverId = :driverId OR f.driverEmail = :driverEmail) AND f.status = :status")
    Long countByDriverAndStatus(@Param("driverId") UUID driverId, @Param("driverEmail") String driverEmail, @Param("status") String status);

    @Query("SELECT SUM(f.amount) FROM Fine f WHERE (f.driverId = :driverId OR f.driverEmail = :driverEmail) AND f.status = :status")
    Double sumAmountByDriverAndStatus(@Param("driverId") UUID driverId, @Param("driverEmail") String driverEmail, @Param("status") String status);
}
