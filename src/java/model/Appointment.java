package model;

import java.sql.Date;

public class Appointment {
    private int id;
    private Customer customer;
    private Doctor doctor;
    private DoctorSchedule doctorSchedule;
    private String status;
    private Date createAt;
    private Date updateAt;

    public Appointment() {}

    public Appointment(int id, Customer customer, Doctor doctor, DoctorSchedule doctorSchedule, String status, Date createAt, Date updateAt) {
        this.id = id;
        this.customer = customer;
        this.doctor = doctor;
        this.doctorSchedule = doctorSchedule;
        this.status = status;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }

    // Getters and Setters
    public Date getCreateAt() { return createAt; }
    public void setCreateAt(Date createAt) { this.createAt = createAt; }

    public Date getUpdateAt() { return updateAt; }
    public void setUpdateAt(Date updateAt) { this.updateAt = updateAt; }

    @Override
    public String toString() {
        return "Appointment{" +
                "id=" + id +
                ", customer=" + (customer != null ? customer.getFullname() : "N/A") +
                ", doctor=" + (doctor != null ? doctor.getId() : "N/A") +
                ", status='" + status + '\'' +
                ", createAt=" + createAt +
                ", updateAt=" + updateAt +
                '}';
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

   

    public DoctorSchedule getDoctorSchedule() {
        return doctorSchedule;
    }

    public void setDoctorSchedule(DoctorSchedule doctorSchedule) {
        this.doctorSchedule = doctorSchedule;
    }
}
