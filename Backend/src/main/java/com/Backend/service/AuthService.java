package com.Backend.service;

import com.Backend.dto.AuthResponse;
import com.Backend.dto.CreateUserRequest;
import com.Backend.dto.LoginRequest;
import com.Backend.entity.District;
import com.Backend.entity.User;
import com.Backend.repository.DistrictRepository;
import com.Backend.repository.UserRepository;
import com.Backend.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final DistrictRepository districtRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        String accessToken = jwtUtil.generateAccessToken(user);
        String refreshToken = jwtUtil.generateRefreshToken(user);

        return new AuthResponse(accessToken, refreshToken, user.getUsername(), user.getRole().name(), user.getId());
    }

    public AuthResponse refresh(String refreshToken) {
        if (!"refresh".equals(jwtUtil.extractTokenType(refreshToken)) || jwtUtil.isExpired(refreshToken)) {
            throw new RuntimeException("Invalid or expired refresh token");
        }

        String username = jwtUtil.extractUsername(refreshToken);
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String newAccessToken = jwtUtil.generateAccessToken(user);
        String newRefreshToken = jwtUtil.generateRefreshToken(user);

        return new AuthResponse(newAccessToken, newRefreshToken, user.getUsername(), user.getRole().name(), user.getId());
    }

    // Used by ADMIN to create OFFICER/ADMIN accounts (registration is not public)
    public User createUser(CreateUserRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already taken");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());
        user.setRole(request.getRole());

        if (request.getDistrictId() != null) {
            District district = districtRepository.findById(request.getDistrictId())
                    .orElseThrow(() -> new RuntimeException("District not found"));
            user.setDistrict(district);
        }

        return userRepository.save(user);
    }
}
