package model;

public class TypeApplication {

    private int id;
    private String name;
    private int staffManageId;
    private String staffManageName;

    public TypeApplication() {
    }

    public TypeApplication(int id, String name, int staffManageId, String staffManageName) {
        this.id = id;
        this.name = name;
        this.staffManageId = staffManageId;
        this.staffManageName = staffManageName;
    }

    public int getStaffManageId() {
        return staffManageId;
    }

    public void setStaffManageId(int staffManageId) {
        this.staffManageId = staffManageId;
    }

    public String getStaffManageName() {
        return staffManageName;
    }

    public void setStaffManageName(String staffManageName) {
        this.staffManageName = staffManageName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
