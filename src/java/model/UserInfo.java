/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.websocket.Session;
import java.util.Objects;
import org.json.JSONObject;

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
    
    public JSONObject toJson() {
        JSONObject json = new JSONObject();
        json.put("email", this.email);
        json.put("fullName", this.fullName);
        json.put("role", this.role);
        return json;
    }

    @Override
    public String toString() {
        return "UserInfo{" +
               "email='" + email + '\'' +
               ", fullName='" + fullName + '\'' +
               ", role='" + role + '\'' +
               '}';
    }

     @Override
     public boolean equals(Object o) {
          if (this == o) return true;
          if (o == null || getClass() != o.getClass()) return false;
          UserInfo userInfo = (UserInfo) o;
          return Objects.equals(email, userInfo.getEmail());
     }

     @Override
     public int hashCode() {
          return Objects.hash(email);
     }

    
}