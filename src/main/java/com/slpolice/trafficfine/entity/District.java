package com.slpolice.trafficfine.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "districts")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class District {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "district_code", unique = true, nullable = false)
    private String districtCode;

    @Column(name = "district_name", nullable = false)
    private String districtName;

    @Column(name = "province")
    private String province;
}