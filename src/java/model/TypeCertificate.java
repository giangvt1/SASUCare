/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author TRUNG
 */
public class TypeCertificate {

    private int id, staffManageId;
    private String name, staffManageName;

    public TypeCertificate() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStaffManageId() {
        return staffManageId;
    }

    public void setStaffManageId(int staffManageId) {
        this.staffManageId = staffManageId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStaffManageName() {
        return staffManageName;
    }

    public void setStaffManageName(String staffManageName) {
        this.staffManageName = staffManageName;
    }

}
