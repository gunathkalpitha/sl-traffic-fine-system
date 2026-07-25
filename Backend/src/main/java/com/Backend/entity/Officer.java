package com.Backend.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "officers")
@Data
public class Officer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String badgeNumber;

    private String phoneNumber;

    @ManyToOne
    @JoinColumn(name = "district_id")
    private District district;
}
