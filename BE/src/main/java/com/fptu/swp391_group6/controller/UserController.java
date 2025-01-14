package com.fptu.swp391_group6.controller;

import com.fptu.swp391_group6.dto.request.ApiResponse;
import com.fptu.swp391_group6.dto.request.ChangePasswordRequest;
import com.fptu.swp391_group6.dto.request.UserLoginRequest;
import com.fptu.swp391_group6.dto.request.UserRegisterRequest;
import com.fptu.swp391_group6.entity.User;
import com.fptu.swp391_group6.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {


    @Autowired
    private UserService userService;

    ApiResponse<User> apiResponse = new ApiResponse<>();

    @PostMapping("/register")
    ApiResponse<User> createUser(@RequestBody @Valid UserRegisterRequest userRegisterRequest) {

        apiResponse.setResult(userService.createUser(userRegisterRequest));
        apiResponse.setCode(500);
        apiResponse.setMessage("User create successful!");

        return apiResponse;
    }

    @PostMapping("/login")
    ApiResponse<User> authenciateUser(@RequestBody UserLoginRequest userLoginRequest) {

        if (userService.authenciateUser(userLoginRequest)) {
            apiResponse.setCode(501);
            apiResponse.setMessage("Login success!");
        }

        return apiResponse;
    }

    @PostMapping("/changePassword")
    ApiResponse<User> changePassword(@RequestBody @Valid ChangePasswordRequest changePasswordRequest) {
        userService.changePassword(changePasswordRequest);

        apiResponse.setCode(502);
        apiResponse.setMessage("Password changed!");

        return apiResponse;
    }

    @GetMapping
    List<User> getUsers() {
        return  userService.getUsers();
    }

    @GetMapping("/id/{userID}")
    User getUserByID(@PathVariable String userID) {
        return userService.getUserByID(userID);
    }

    @GetMapping("/username/{username}")
    User getUserByUsername(@PathVariable String username) {
        return userService.getUserByUsername(username);
    }
}
