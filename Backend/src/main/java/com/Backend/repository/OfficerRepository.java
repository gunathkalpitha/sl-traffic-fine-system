package com.Backend.repository;


import com.Backend.entity.Officer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OfficerRepository
        extends JpaRepository<Officer, Long> {
}
