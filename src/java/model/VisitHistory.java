package model;

import java.sql.Timestamp;

/**
 *
 * @author TRUNG
 */
public class VisitHistory {

    private int id, doctorId, customerId;
    private Timestamp visitDate;
    private String reasonForVisit, diagnoses, treatmentPlan;
    private Timestamp nextAppointment;

    public VisitHistory() {
    }

    public VisitHistory(int id, int doctorId, int customerId, Timestamp visitDate, String reasonForVisit, String diagnoses, String treatmentPlan, Timestamp nextAppointment) {
        this.id = id;
        this.doctorId = doctorId;
        this.customerId = customerId;
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

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Timestamp getVisitDate() { // Thay đổi kiểu trả về
        return visitDate;
    }

    public void setVisitDate(Timestamp visitDate) { // Thay đổi kiểu tham số
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

    public Timestamp getNextAppointment() { // Thay đổi kiểu trả về
        return nextAppointment;
    }

    public void setNextAppointment(Timestamp nextAppointment) { // Thay đổi kiểu tham số
        this.nextAppointment = nextAppointment;
    }

}