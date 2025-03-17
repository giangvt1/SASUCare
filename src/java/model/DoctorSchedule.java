package model;

import java.sql.Date;

public class DoctorSchedule {
    private int id;
    private Doctor doctor;
    private Date scheduleDate;
    private Shift shift;
    private boolean available;
    

    public DoctorSchedule() {}

    public DoctorSchedule(int id, Doctor doctor, Date scheduleDate, Shift shift, boolean available) {
        this.id = id;
        this.doctor = doctor;
        this.scheduleDate = scheduleDate;
        this.shift = shift;
        this.available = available; // Chuyển đổi từ int sang boolean
    }

    // Getter và Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public Date getScheduleDate() { return scheduleDate; }
    public void setScheduleDate(Date scheduleDate) { this.scheduleDate = scheduleDate; }

    public Shift getShift() { return shift; }
    public void setShift(Shift shift) { this.shift = shift; }

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    @Override
    public String toString() {
        return "DoctorSchedule{" +
                "id=" + id +
                ", doctor=" + (doctor != null ? doctor.getStaff().getFullname() : "N/A") +
                ", scheduleDate=" + scheduleDate +
                ", shift=" + shift +
                ", available=" + available +
                '}';
    }
}