package com.fptu.swp391_group6.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "uid")
    private String uid;

    @Column(name = "eid")
    private Integer eid;

    @Column(name = "username", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Column(name = "active")
    private Boolean active;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "google_id", length = 255)
    private String googleId;

    @Column(name = "provider", columnDefinition = "enum('local','google')")
    private String provider;

}
