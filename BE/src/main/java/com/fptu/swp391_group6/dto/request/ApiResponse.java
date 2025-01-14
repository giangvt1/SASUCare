package com.fptu.swp391_group6.dto.request;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

@JsonInclude(value = JsonInclude.Include.NON_NULL)
@Data
public class ApiResponse <T>{
    private int code;
    private String message;
    private T result;
}
