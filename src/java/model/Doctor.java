package model;
import java.util.ArrayList;
import model.system.Staff;

public class Doctor {
    private int id;
    private String name;
    private Staff staff;
    private String email;
    private String phoneNumber;
    private boolean gender; // true = Male, false = Female
    private String address;
    private String specialty; // Department name
    private ArrayList<DoctorSchedule> doctorSchedules;
    public Doctor() {
    }

    public Doctor(int id, String name, Staff staff, String email, String phoneNumber, boolean gender, String address, String specialty, ArrayList<DoctorSchedule> doctorSchedules) {
        this.id = id;
        this.name = name;
        this.staff = staff;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.address = address;
        this.specialty = specialty;
        this.doctorSchedules = doctorSchedules;
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

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public ArrayList<DoctorSchedule> getDoctorSchedules() {
        return doctorSchedules;
    }

    public void setDoctorSchedules(ArrayList<DoctorSchedule> doctorSchedules) {
        this.doctorSchedules = doctorSchedules;
    }


}