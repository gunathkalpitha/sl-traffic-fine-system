package com.slpolice.trafficfine.repository;

import com.slpolice.trafficfine.entity.FineCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FineCategoryRepository extends JpaRepository<FineCategory, Long> {
    Optional<FineCategory> findByCategoryCode(String categoryCode);
    List<FineCategory> findByIsActiveTrue();
}