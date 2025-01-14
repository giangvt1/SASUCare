package com.fptu.swp391_group6.dto.request;

import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class ChangePasswordRequest {

    private  String username;
    private String currentPassword;

    @Pattern(
            regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,20}$",
            message = "INVALID_PASS"
    )
    private String newPassword;
}
