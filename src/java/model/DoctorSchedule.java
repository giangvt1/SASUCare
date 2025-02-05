package model;

import java.sql.Date;
import java.sql.Time;

public class DoctorSchedule {
    private int id;
    private Doctor doctor;
    private Date scheduleDate;
    private Time timeStart;
    private Time timeEnd;
    private boolean available; // true = available, false = booked

    public DoctorSchedule() {
    }

    public DoctorSchedule(int id, Doctor doctor, Date scheduleDate, Time timeStart, Time timeEnd, boolean available) {
        this.id = id;
        this.doctor = doctor;
        this.scheduleDate = scheduleDate;
        this.timeStart = timeStart;
        this.timeEnd = timeEnd;
        this.available = available;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Date getScheduleDate() {
        return scheduleDate;
    }

    public void setScheduleDate(Date scheduleDate) {
        this.scheduleDate = scheduleDate;
    }

    public Time getTimeStart() {
        return timeStart;
    }

    public void setTimeStart(Time timeStart) {
        this.timeStart = timeStart;
    }

    public Time getTimeEnd() {
        return timeEnd;
    }

    public void setTimeEnd(Time timeEnd) {
        this.timeEnd = timeEnd;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    @Override
    public String toString() {
        return "DoctorSchedule{" +
                "id=" + id +
                ", doctor=" + doctor.getName() +
                ", scheduleDate=" + scheduleDate +
                ", timeStart=" + timeStart +
                ", timeEnd=" + timeEnd +
                ", available=" + available +
                '}';
    }
}
