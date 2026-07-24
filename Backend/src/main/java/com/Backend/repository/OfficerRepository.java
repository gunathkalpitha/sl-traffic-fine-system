package com.Backend.repository;

import com.Backend.entity.Officer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

import java.util.Optional;

public interface OfficerRepository
        extends JpaRepository<Officer, Long> {
    
    Optional<Officer> findByNameAndBadgeNumber(String name, String badgeNumber);

    Optional<Officer> findByBadgeNumber(String badgeNumber);
}
