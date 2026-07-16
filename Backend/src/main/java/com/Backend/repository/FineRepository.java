package com.Backend.repository;


import com.Backend.entity.Fine;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface FineRepository
        extends JpaRepository<Fine, Long> {

    // Find fine by reference number
    Optional<Fine> findByReferenceNumber(String referenceNumber);

    // Find fine by reference number and category
    Optional<Fine> findByReferenceNumberAndCategory_Id(
            String referenceNumber, Long categoryId
    );
}
