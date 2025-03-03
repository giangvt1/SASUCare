
package model;

import java.sql.*;

/**
 *
 * @author TRUNG
 */
public class MedicalHistory {

    private int id;
    private int customerId;
    private String name;
    private String detail;

    public MedicalHistory() {
    }

    public MedicalHistory(int id, int customerId, String name, String detail) {
        this.id = id;
        this.customerId = customerId;
        this.name = name;
        this.detail = detail;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

}