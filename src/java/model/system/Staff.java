package model.system;

import java.sql.*;

public class Staff {
    private int id;
    private User staff_username;
    private boolean gender;
    private String fullname;
    private Date dob;
    private String address;
    private User createby;
    private Timestamp createat;
    private User updateby;
    private Timestamp updateat;
    private boolean isDoctor; // Trường mới, xác định nhân viên có phải là bác sĩ hay không
    private String img;

    public User getStaff_username() {
        return staff_username;
    }

    public void setStaff_username(User staff_username) {
        this.staff_username = staff_username;
    }

    public boolean isIsDoctor() {
        return isDoctor;
    }

    public void setIsDoctor(boolean isDoctor) {
        this.isDoctor = isDoctor;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    // Constructor mặc định
    public Staff() {
    }

    public Staff(int id, User staff_username, boolean gender, String fullname, Date dob, String address, User createby, Timestamp createat, User updateby, Timestamp updateat, boolean isDoctor, String img) {
        this.id = id;
        this.staff_username = staff_username;
        this.gender = gender;
        this.fullname = fullname;
        this.dob = dob;
        this.address = address;
        this.createby = createby;
        this.createat = createat;
        this.updateby = updateby;
        this.updateat = updateat;
        this.isDoctor = isDoctor;
        this.img = img;
    }

    

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getStaffusername() {
        return staff_username;
    }

    public void setStaffusername(User staffusername) {
        this.staff_username = staffusername;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
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

    public User getCreateby() {
        return createby;
    }

    public void setCreateby(User createby) {
        this.createby = createby;
    }

    public Timestamp getCreateat() {
        return createat;
    }

    public void setCreateat(Timestamp createat) {
        this.createat = createat;
    }

    public User getUpdateby() {
        return updateby;
    }

    public void setUpdateby(User updateby) {
        this.updateby = updateby;
    }

    public Timestamp getUpdateat() {
        return updateat;
    }

    public void setUpdateat(Timestamp updateat) {
        this.updateat = updateat;
    }

    public boolean isDoctor() {
        return isDoctor;
    }

    public void setDoctor(boolean isDoctor) {
        this.isDoctor = isDoctor;
    }
}
