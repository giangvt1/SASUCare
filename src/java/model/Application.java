package model;

import java.sql.Timestamp;

public class Application {

    private int id;
    private int typeId;
    private String typeName;
    private int staffSendId;
    private int staffProgressId;
    private String reason;
    private String status;
    private String reply;
    private Timestamp dateSend;
    private Timestamp dateReply;
    private String staffName;

    public Application() {
    }

    public Application(int id, int typeId, String typeName, int staffSendId, int staffProgressId, String reason, String status, String reply, Timestamp dateSend, Timestamp dateReply, String staffName) {
        this.id = id;
        this.typeId = typeId;
        this.typeName = typeName;
        this.staffSendId = staffSendId;
        this.staffProgressId = staffProgressId;
        this.reason = reason;
        this.status = status;
        this.reply = reply;
        this.dateSend = dateSend;
        this.dateReply = dateReply;
        this.staffName = staffName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public int getStaffSendId() {
        return staffSendId;
    }

    public void setStaffSendId(int staffSendId) {
        this.staffSendId = staffSendId;
    }

    public int getStaffProgressId() {
        return staffProgressId;
    }

    public void setStaffProgressId(int staffProgressId) {
        this.staffProgressId = staffProgressId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Timestamp getDateSend() {
        return dateSend;
    }

    public void setDateSend(Timestamp dateSend) {
        this.dateSend = dateSend;
    }

    public Timestamp getDateReply() {
        return dateReply;
    }

    public void setDateReply(Timestamp dateReply) {
        this.dateReply = dateReply;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

}
