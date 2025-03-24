/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.system;

import java.util.ArrayList;
import model.Department;

/**
 *
 * @author acer
 */
public class User {
    private String username;
    private String password;
    private String displayname;
    private String gmail;
    private String phone;
    private ArrayList<Role> roles=new ArrayList<>();
    private ArrayList<Department> dep=new ArrayList<>();

    public ArrayList<Department> getDep() {
        return dep;
    }

    public void setDep(ArrayList<Department> dep) {
        this.dep = dep;
    }
    
    public User(String username, String password, String displayname, String gmail, String phone) {
        this.username = username;
        this.password = password;
        this.displayname = displayname;
        this.gmail = gmail;
        this.phone = phone;
    }

    public ArrayList<Role> getRoles() {
        return roles;
    }

    public void setRoles(ArrayList<Role> roles) {
        this.roles = roles;
    }
    

    public User() {
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDisplayname() {
        return displayname;
    }

    public void setDisplayname(String displayname) {
        this.displayname = displayname;
    }

    public String getGmail() {
        return gmail;
    }

    public void setGmail(String gmail) {
        this.gmail = gmail;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    
}
