package com.fptu.swp391_group6.dto.request;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class UserRegisterRequest {
    @Size(min = 4, message = "INVALID_INPUT")
    private String username;

    @Pattern(
            regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,20}$",
            message = "INVALID_PASS"
    )
    private String password;

    @Pattern(
            regexp = "^[A-Za-z0-9+_.-]+@(.+).{1,50}$",
            message = "INVALID_EMAIL"
    )
    private String email;
}
