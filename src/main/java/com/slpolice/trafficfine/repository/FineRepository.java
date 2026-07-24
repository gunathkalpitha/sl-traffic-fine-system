package com.slpolice.trafficfine.repository;

import com.slpolice.trafficfine.entity.Fine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface FineRepository extends JpaRepository<Fine, Long> {
    Optional<Fine> findByReferenceNumber(String referenceNumber);
    Optional<Fine> findByReferenceNumberAndCategoryCategoryCode(String referenceNumber, String categoryCode);
    List<Fine> findByStatus(Fine.FineStatus status);
    List<Fine> findByDistrictId(Long districtId);

    @Query("SELECT f FROM Fine f WHERE f.issuedAt BETWEEN :startDate AND :endDate")
    List<Fine> findByIssuedAtBetween(@Param("startDate") LocalDateTime startDate,
                                     @Param("endDate") LocalDateTime endDate);

    @Query("SELECT f FROM Fine f WHERE f.district.id = :districtId AND f.issuedAt BETWEEN :startDate AND :endDate")
    List<Fine> findByDistrictAndDateRange(@Param("districtId") Long districtId,
                                          @Param("startDate") LocalDateTime startDate,
                                          @Param("endDate") LocalDateTime endDate);
}