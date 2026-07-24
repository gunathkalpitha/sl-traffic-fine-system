package com.slpolice.trafficfine.dto;

import lombok.Data;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminReportDto {

    private BigDecimal totalCollection;
    private Long totalPayments;
    private BigDecimal todayCollection;
    private Long todayPayments;

    private List<DistrictCollectionDto> districtCollections;
    private List<CategoryCollectionDto> categoryCollections;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DistrictCollectionDto {
        private String districtCode;
        private String districtName;
        private String province;
        private BigDecimal totalAmount;
        private Long totalCount;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CategoryCollectionDto {
        private String categoryCode;
        private String categoryName;
        private BigDecimal totalAmount;
        private Long totalCount;
        private BigDecimal baseAmount;
    }
}