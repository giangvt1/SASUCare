/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.*;

/**
 *
 * @author TRUNG
 */
public class VisitHistory {

    private int id, Did, Cid;
    private Date visitDate;
    private String reasonForVisit, diagnoses, treatmentPlan;
    private Date nextAppointment;

    public VisitHistory() {
    }

    public VisitHistory(int id, int Did, int Cid, Date visitDate, String reasonForVisit, String diagnoses, String treatmentPlan, Date nextAppointment) {
        this.id = id;
        this.Did = Did;
        this.Cid = Cid;
        this.visitDate = visitDate;
        this.reasonForVisit = reasonForVisit;
        this.diagnoses = diagnoses;
        this.treatmentPlan = treatmentPlan;
        this.nextAppointment = nextAppointment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDid() {
        return Did;
    }

    public void setDid(int Did) {
        this.Did = Did;
    }

    public int getCid() {
        return Cid;
    }

    public void setCid(int Cid) {
        this.Cid = Cid;
    }

    public Date getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(Date visitDate) {
        this.visitDate = visitDate;
    }

    public String getReasonForVisit() {
        return reasonForVisit;
    }

    public void setReasonForVisit(String reasonForVisit) {
        this.reasonForVisit = reasonForVisit;
    }

    public String getDiagnoses() {
        return diagnoses;
    }

    public void setDiagnoses(String diagnoses) {
        this.diagnoses = diagnoses;
    }

    public String getTreatmentPlan() {
        return treatmentPlan;
    }

    public void setTreatmentPlan(String treatmentPlan) {
        this.treatmentPlan = treatmentPlan;
    }

    public Date getNextAppointment() {
        return nextAppointment;
    }

    public void setNextAppointment(Date nextAppointment) {
        this.nextAppointment = nextAppointment;
    }

}
