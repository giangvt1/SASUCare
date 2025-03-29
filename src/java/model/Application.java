package model;

import java.sql.Timestamp;

public class Application {

    private int id;
    private int typeId;
    private String typeName;
    private int staffSendId;
    private int staffHandleId;
    private String reason;
    private String status;
    private String reply;
    private Timestamp dateSend;
    private Timestamp dateReply;
    private String staffName;

    public Application() {
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

    public int getStaffHandleId() {
        return staffHandleId;
    }

    public void setStaffHandleId(int staffProgressId) {
        this.staffHandleId = staffProgressId;
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
