/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.*;
/**
 *
 * @author acer
 */
public class Customer {
    private int id;
    public String username;
    private String password;
    private String gmail;
    private boolean gender;
    private Date dob;
    private String address;
    private String phone_number;
    private GoogleAccount google_id;
    private String fullname;

    public Customer() {
    }

    public Customer(int id, String username, String password, String gmail, boolean gender, Date dob, String address, String phone_number, GoogleAccount google_id, String fullname) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.gmail = gmail;
        this.gender = gender;
        this.dob = dob;
        this.address = address;
        this.phone_number = phone_number;
        this.google_id = google_id;
        this.fullname = fullname;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getGmail() {
        return gmail;
    }

    public void setGmail(String gmail) {
        this.gmail = gmail;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public GoogleAccount getGoogle_id() {
        return google_id;
    }

    public void setGoogle_id(GoogleAccount google_id) {
        this.google_id = google_id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    @Override
    public String toString() {
        return "Customer{" + "id=" + id + ", username=" + username + ", password=" + password + ", gmail=" + gmail + ", gender=" + gender + ", dob=" + dob + ", address=" + address + ", phone_number=" + phone_number + ", google_id=" + google_id + ", fullname=" + fullname + '}';
    }

    
    
    
    
    
}
