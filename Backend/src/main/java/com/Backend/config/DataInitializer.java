package com.Backend.config;

import com.Backend.entity.Category;
import com.Backend.entity.District;
import com.Backend.entity.Officer;
import com.Backend.repository.CategoryRepository;
import com.Backend.repository.DistrictRepository;
import com.Backend.repository.OfficerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final DistrictRepository districtRepository;
    private final OfficerRepository officerRepository;

    @Override
    public void run(String... args) throws Exception {
        // Initialize Districts if empty
        if (districtRepository.count() == 0) {
            String[][] districtsData = {
                {"Colombo", "Western"}, {"Gampaha", "Western"}, {"Kalutara", "Western"},
                {"Kandy", "Central"}, {"Matale", "Central"}, {"Nuwara Eliya", "Central"},
                {"Galle", "Southern"}, {"Matara", "Southern"}, {"Hambantota", "Southern"},
                {"Jaffna", "Northern"}, {"Kilinochchi", "Northern"}, {"Mannar", "Northern"},
                {"Vavuniya", "Northern"}, {"Mullaitivu", "Northern"},
                {"Batticaloa", "Eastern"}, {"Ampara", "Eastern"}, {"Trincomalee", "Eastern"},
                {"Kurunegala", "North Western"}, {"Puttalam", "North Western"},
                {"Anuradhapura", "North Central"}, {"Polonnaruwa", "North Central"},
                {"Badulla", "Uva"}, {"Moneragala", "Uva"},
                {"Ratnapura", "Sabaragamuwa"}, {"Kegalle", "Sabaragamuwa"}
            };
            
            for (String[] d : districtsData) {
                District district = new District();
                district.setName(d[0]);
                district.setProvince(d[1]);
                districtRepository.save(district);
            }
        }

        // Initialize Categories if empty
        if (categoryRepository.count() == 0) {
            Category c1 = new Category();
            c1.setCode("C1");
            c1.setName("Speeding");
            c1.setDescription("Exceeding speed limits");
            c1.setFineAmount(3000.0);

            Category c2 = new Category();
            c2.setCode("C2");
            c2.setName("Illegal Parking");
            c2.setDescription("Parking in restricted zones");
            c2.setFineAmount(1500.0);

            Category c3 = new Category();
            c3.setCode("C3");
            c3.setName("No License");
            c3.setDescription("Driving without a valid license");
            c3.setFineAmount(5000.0);

            Category c4 = new Category();
            c4.setCode("C4");
            c4.setName("Reckless Driving");
            c4.setDescription("Driving in a manner that endangers others");
            c4.setFineAmount(10000.0);

            categoryRepository.saveAll(List.of(c1, c2, c3, c4));
        }

        // Initialize Officers if empty
        if (officerRepository.count() == 0) {
            List<District> districts = districtRepository.findAll();
            if (!districts.isEmpty()) {
                Officer o1 = new Officer();
                o1.setName("Officer Bandara");
                o1.setBadgeNumber("B101");
                o1.setPhoneNumber("0712345678");
                o1.setDistrict(districts.get(0)); // assign to colombo

                Officer o2 = new Officer();
                o2.setName("Officer Perera");
                o2.setBadgeNumber("P202");
                o2.setPhoneNumber("0776543210");
                o2.setDistrict(districts.get(1)); // assign to gampaha

                officerRepository.saveAll(List.of(o1, o2));
            }
        }
    }
}
