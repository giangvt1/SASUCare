package com.fptu.swp391_group6.service;

import com.fptu.swp391_group6.dto.request.ApiResponse;
import com.fptu.swp391_group6.dto.request.ChangePasswordRequest;
import com.fptu.swp391_group6.dto.request.UserLoginRequest;
import com.fptu.swp391_group6.dto.request.UserRegisterRequest;
import com.fptu.swp391_group6.entity.User;
import com.fptu.swp391_group6.exception.AppException;
import com.fptu.swp391_group6.exception.ErrorCode;
import com.fptu.swp391_group6.respiratory.UserRespiratory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRespiratory userRespiratory;
    private BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder(4);

    public User createUser(UserRegisterRequest userRegisterRequest) {

        if (userRespiratory.existsByUsername(userRegisterRequest.getUsername())) {
            throw new AppException(ErrorCode.USER_EXISTED);
        }

        User user = User.builder()
                .username(userRegisterRequest.getUsername())
                .password(bCryptPasswordEncoder.encode(userRegisterRequest.getPassword()))
                .email(userRegisterRequest.getEmail())
                .build();

        return userRespiratory.save(user);
    }

    public boolean authenciateUser(UserLoginRequest userLoginRequest) {

        User user = userRespiratory.findByUsername(userLoginRequest.getUsername());

        System.out.println(!bCryptPasswordEncoder.matches(userLoginRequest.getPassword(), user.getPassword()));

        if (user == null || !bCryptPasswordEncoder.matches(userLoginRequest.getPassword(), user.getPassword())) {
            throw new AppException(ErrorCode.LOGIN_FAILED);
        }

        return true;
    }

    public User changePassword(ChangePasswordRequest changePasswordRequest) {

        User user = userRespiratory.findByUsername(changePasswordRequest.getUsername());

        if (!bCryptPasswordEncoder.matches(changePasswordRequest.getCurrentPassword(), user.getPassword())) {
            throw new AppException(ErrorCode.PASS_NOT_MATCH);
        }
        user.setPassword(bCryptPasswordEncoder.encode(changePasswordRequest.getNewPassword()));


        return userRespiratory.save(user);

    }

    public List<User> getUsers() {
        return userRespiratory.findAll();
    }

    public User getUserByID(String userID) {
        return userRespiratory.findById(userID)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
    }

    public User getUserByUsername(String username) {
        return userRespiratory.findByUsername(username);
    }

}
