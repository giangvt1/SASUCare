package model;

import java.util.Date;

public class Invoice {

    private int id;
    private long amount;
    private String orderInfo;
    private String orderType;
    private int customerId;
    private int serviceId;
    private Date createdDate;
    private Date expireDate;
    private String txnRef;
    private int appointmentId; // Added appointmentId field
    private String status;

   
    
    

    // Default constructor
    public Invoice() {}

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getOrderInfo() {
        return orderInfo;
    }

    public void setOrderInfo(String orderInfo) {
        this.orderInfo = orderInfo;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getExpireDate() {
        return expireDate;
    }

    public void setExpireDate(Date expireDate) {
        this.expireDate = expireDate;
    }

    public String getTxnRef() {
        return txnRef;
    }

    public void setTxnRef(String txnRef) {
        this.txnRef = txnRef;
    }

    // Getter and setter for appointmentId
    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    
     public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    @Override
public String toString() {
    return "Invoice{" +
            "id=" + id +
            ", amount=" + amount +
            ", orderInfo='" + orderInfo + '\'' +
            ", orderType='" + orderType + '\'' +
            ", customerId=" + customerId +
            ", serviceId=" + serviceId +
            ", createdDate=" + createdDate +
            ", expireDate=" + expireDate +
            ", txnRef='" + txnRef + '\'' +
            ", appointmentId=" + appointmentId +
            ", status='" + status + '\'' +
            '}';
}
}
