package model;

import java.util.ArrayList;
import java.util.List;
import model.system.Staff;

public class Doctor {

    private int id;
    private String name;
    private Staff staff;    
    private String email;
    private String phoneNumber;
    private boolean gender;
    private String address;
    private List<String> specialties;
    private ArrayList<DoctorSchedule> doctorSchedules;

    public Doctor() {
    }

    public Doctor(int id, String name, Staff staff, String email, String phoneNumber, boolean gender, String address, List<String> specialties, ArrayList<DoctorSchedule> doctorSchedules) {
        this.id = id;
        this.name = name;
        this.staff = staff;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.address = address;
        this.specialties = specialties;
        this.doctorSchedules = doctorSchedules;
    }

    public Doctor(int id, String name, List<String> specialties) {
        this.id = id;
        this.name = name;
        this.specialties = specialties;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public List<String> getSpecialties() {
        return specialties;
    }

    public void setSpecialties(List<String> specialties) {
        this.specialties = specialties;
    }

    public ArrayList<DoctorSchedule> getDoctorSchedules() {
        return doctorSchedules;
    }

    public void setDoctorSchedules(ArrayList<DoctorSchedule> doctorSchedules) {
        this.doctorSchedules = doctorSchedules;
    }

}
