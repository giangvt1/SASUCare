package com.fptu.swp391_group6.exception;

public enum ErrorCode {
    USER_EXISTED(1000, "User Existed!"),
    LOGIN_FAILED(1001, "Username or password is incorrect!"),
    INVALID_PASS(1002, "Invalid password!"),
    INVALID_EMAIL(1003, "The email address is invalid."),
    INVALID_INPUT(1004, "Username must be at least 4 characters long!"),
    USER_NOT_FOUND(1006, "User not found!"),
    PASS_NOT_MATCH(1007, "Password not match! Please try again!")
    ;

    private int code;
    private String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
