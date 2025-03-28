package model;

public class DoctorSalaryStat {
    private int doctorId;
    private String doctorName;
    private int shiftCount;
    private double salaryRate;
    private double totalSalary;
    private double SalaryCoefficient;

    public double getSalaryCoefficient() {
        return SalaryCoefficient;
    }

    public void setSalaryCoefficient(double SalaryCoefficient) {
        this.SalaryCoefficient = SalaryCoefficient;
    }
    

    public DoctorSalaryStat() {}

    public int getDoctorId() {
        return doctorId;
    }
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    public String getDoctorName() {
        return doctorName;
    }
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    public int getShiftCount() {
        return shiftCount;
    }
    public void setShiftCount(int shiftCount) {
        this.shiftCount = shiftCount;
    }
    public double getSalaryRate() {
        return salaryRate;
    }
    public void setSalaryRate(double salaryRate) {
        this.salaryRate = salaryRate;
    }
    public double getTotalSalary() {
        return totalSalary;
    }
    public void setTotalSalary(double totalSalary) {
        this.totalSalary = totalSalary;
    }
}
