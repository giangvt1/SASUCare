/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.websocket.Session;

/**
 *
 * @author ngoch
 */
public class UserInfo {
    private String email;
    private String fullName;
    private String role;
    private Session session;
    private String currentChatPartner;

    public UserInfo() {
    }

    public UserInfo(String email, String fullName, String role) {
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.session = session;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Session getSession() {
        return session;
    }

    public void setSession(Session session) {
        this.session = session;
    }
    
    // Getter & Setter
    public String getCurrentChatPartner() {
        return currentChatPartner;
    }

    public void setCurrentChatPartner(String currentChatPartner) {
        this.currentChatPartner = currentChatPartner;
    }

    
}