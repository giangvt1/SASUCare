package model;

import java.sql.Date;

public class Appointment {
    private int id;
    private Customer customer;
    private Doctor doctor;
    private DoctorSchedule doctorSchedule; // Added TimeSlot object
    private String status;

    public Appointment() {
    }

    public Appointment(int id, Customer customer, Doctor doctor, DoctorSchedule doctorSchedule, String status) {
        this.id = id;
        this.customer = customer;
        this.doctor = doctor;
        this.doctorSchedule = doctorSchedule;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

  

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "id=" + id +
                ", customer=" + customer.getFullname() +
                ", doctor=" + doctor.getId() +
                ", status='" + status + '\'' +
                '}';
    }

    public DoctorSchedule getDoctorSchedule() {
        return doctorSchedule;
    }

    public void setDoctorSchedule(DoctorSchedule doctorSchedule) {
        this.doctorSchedule = doctorSchedule;
    }
}
