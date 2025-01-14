package com.fptu.swp391_group6.exception;

import com.fptu.swp391_group6.dto.request.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;


@ControllerAdvice
public class GlobalExceptionHandler {

    ApiResponse apiResponse = new ApiResponse();

    @ExceptionHandler(value = AppException.class)
    ResponseEntity<ApiResponse> handlingAppException(AppException e) {
        ErrorCode errorCode = e.getErrorCode();

        apiResponse.setCode(errorCode.getCode());
        apiResponse.setMessage(errorCode.getMessage());

        return ResponseEntity.badRequest().body(apiResponse);
    }

    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    ResponseEntity<ApiResponse> handlingMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        String numkey = e.getFieldError().getDefaultMessage();
        ErrorCode errorCode = ErrorCode.valueOf(numkey);

        apiResponse.setCode(errorCode.getCode());
        apiResponse.setMessage(errorCode.getMessage());

        return ResponseEntity.badRequest().body(apiResponse);
    }

    @ExceptionHandler(value = NullPointerException.class)
    ResponseEntity<ApiResponse> handlingNullPointerException(NullPointerException e) {

        apiResponse.setCode(1005);
        apiResponse.setMessage("User doesn't exist!");

        return ResponseEntity.badRequest().body(apiResponse);
    }
}
