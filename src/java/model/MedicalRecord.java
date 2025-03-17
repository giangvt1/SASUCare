/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.util.Date;

/**
 *
 * @author ngoch
 */
public class MedicalRecord {
    private int record_id;
    private int customer_id;
    private String fullName;
    private Date dob;
    private String phone;
    private String gender;
    private String job;
    private String idNumber;
    private String email;
    private String nation;
    private String province;
    private String district;
    private String ward;
    private String addressDetail;

    public MedicalRecord() {
    }

    public MedicalRecord(int customer_id, String fullName, Date dob, String phone, String gender, String job, String idNumber, String email, String nation, String province, String district, String ward, String addressDetail) {
        this.customer_id = customer_id;
        this.fullName = fullName;
        this.dob = dob;
        this.phone = phone;
        this.gender = gender;
        this.job = job;
        this.idNumber = idNumber;
        this.email = email;
        this.nation = nation;
        this.province = province;
        this.district = district;
        this.ward = ward;
        this.addressDetail = addressDetail;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getRecord_id() {
        return record_id;
    }

    public void setRecord_id(int record_id) {
        this.record_id = record_id;
    }
    
    

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNation() {
        return nation;
    }

    public void setNation(String nation) {
        this.nation = nation;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }
    
    
    
}
