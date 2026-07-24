package com.slpolice.trafficfine.repository;

import com.slpolice.trafficfine.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    Optional<Payment> findByFineId(Long fineId);
    Optional<Payment> findByTransactionId(String transactionId);
    List<Payment> findByPaidAtBetween(LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT COALESCE(SUM(p.amountPaid), 0) FROM Payment p WHERE p.status = 'SUCCESS' AND p.paidAt BETWEEN :startDate AND :endDate")
    BigDecimal sumAmountByDateRange(@Param("startDate") LocalDateTime startDate,
                                    @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COALESCE(SUM(p.amountPaid), 0) FROM Payment p " +
           "WHERE p.status = 'SUCCESS' AND p.fine.district.id = :districtId " +
           "AND p.paidAt BETWEEN :startDate AND :endDate")
    BigDecimal sumAmountByDistrictAndDateRange(@Param("districtId") Long districtId,
                                               @Param("startDate") LocalDateTime startDate,
                                               @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.status = 'SUCCESS' AND p.paidAt BETWEEN :startDate AND :endDate")
    Long countByDateRange(@Param("startDate") LocalDateTime startDate,
                          @Param("endDate") LocalDateTime endDate);

    @Query("SELECT p FROM Payment p WHERE p.fine.district.id = :districtId AND p.paidAt BETWEEN :startDate AND :endDate")
    List<Payment> findByDistrictAndDateRange(@Param("districtId") Long districtId,
                                             @Param("startDate") LocalDateTime startDate,
                                             @Param("endDate") LocalDateTime endDate);

    @Query("SELECT p FROM Payment p WHERE f.fine.category.id = :categoryId AND p.paidAt BETWEEN :startDate AND :endDate")
    List<Payment> findByCategoryAndDateRange(@Param("categoryId") Long categoryId,
                                             @Param("startDate") LocalDateTime startDate,
                                             @Param("endDate") LocalDateTime endDate);
}