package com.Backend.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "profiles")
@Data
public class Profile {

    @Id
    private UUID id;

    private String fullName;

    private String licenseNumber;

    private String email;

    private String phoneNumber;

    private String role;

    private OffsetDateTime updatedAt;
}
