package com.fptu.swp391_group6.respiratory;

import com.fptu.swp391_group6.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRespiratory extends JpaRepository<User, String> {
    User findByUsername(String username);
    boolean existsByUsername(String username);
}
