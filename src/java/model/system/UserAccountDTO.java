package model.system;

import java.sql.Date;
import java.sql.Timestamp;

public class UserAccountDTO {
    private String staffUsername;
    private String fullname;
    private String displayname;
    private String gmail;
    private String phone;
    private boolean gender;
    private Date dob;
    private Timestamp createat;
    private String createby;
    private Timestamp updateat;
    private String updateby;
    private String roleName;

    // Getters and setters
    public String getStaffUsername() {
        return staffUsername;
    }
    public void setStaffUsername(String staffUsername) {
        this.staffUsername = staffUsername;
    }
    public String getFullname() {
        return fullname;
    }
    public void setFullname(String fullname) {
        this.fullname = fullname;
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
    public Timestamp getCreateat() {
        return createat;
    }
    public void setCreateat(Timestamp createat) {
        this.createat = createat;
    }
    public String getCreateby() {
        return createby;
    }
    public void setCreateby(String createby) {
        this.createby = createby;
    }
    public Timestamp getUpdateat() {
        return updateat;
    }
    public void setUpdateat(Timestamp updateat) {
        this.updateat = updateat;
    }
    public String getUpdateby() {
        return updateby;
    }
    public void setUpdateby(String updateby) {
        this.updateby = updateby;
    }
    public String getRoleName() {
        return roleName;
    }
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
