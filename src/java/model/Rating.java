/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Date;

public class Rating {
    private int doctorId;
    private String customerUsername;
    private float rating;
    private String comment;
    private Date createdAt;
    private boolean visible;

    public Rating(int doctorId, String customerUsername, float rating, String comment, Date createdAt) {
        this.doctorId = doctorId;
        this.customerUsername = customerUsername;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public Rating(int doctorId, String customerUsername, float rating, String comment, Date createdAt, boolean visible) {
        this.doctorId = doctorId;
        this.customerUsername = customerUsername;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.visible = visible;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }
    
    
    public Rating(int doctorId, String customerUsername, float rating, String comment) {
        this.doctorId = doctorId;
        this.customerUsername = customerUsername;
        this.rating = rating;
        this.comment = comment;
    }

  
    public int getDoctorId() {
        return doctorId;
    }

    public String getCustomerUsername() {
        return customerUsername;
    }

    public float getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public void setCustomerUsername(String customerUsername) {
        this.customerUsername = customerUsername;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Rating{" + "doctorId=" + doctorId + ", customerUsername=" + customerUsername + ", rating=" + rating + ", comment=" + comment + ", createdAt=" + createdAt + '}';
    }
    
    
}
