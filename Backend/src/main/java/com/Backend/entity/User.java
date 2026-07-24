package com.Backend.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password; // BCrypt hashed, never stored/returned in plain text

    private String fullName;

    @Column(unique = true)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role; // ADMIN or OFFICER

    @ManyToOne
    @JoinColumn(name = "district_id")
    private District district; // relevant for OFFICER accounts

    private boolean enabled = true;

    private LocalDateTime createdAt = LocalDateTime.now();
}
