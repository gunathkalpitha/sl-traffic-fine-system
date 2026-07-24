package com.Backend.dto;

import com.Backend.entity.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateUserRequest {

    @NotBlank
    private String username;

    @NotBlank
    private String password;

    private String fullName;

    @Email
    private String email;

    @NotNull
    private Role role;

    private Long districtId;
}
