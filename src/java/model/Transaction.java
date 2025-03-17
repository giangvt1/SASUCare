package model;



import java.sql.Timestamp;

public class Transaction {
    private int id;
    private Invoice invoice;  // Foreign key reference to Invoice
    private String vnpTxnRef; // VNPAY transaction reference
    private String bankCode;
    private String paymentMethod;
    private String paymentUrl;
    private String status;
    private Timestamp transactionDate;

    // Constructor không tham số
    public Transaction() {
        this.transactionDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor đầy đủ
    public Transaction(int id, Invoice invoice, String vnpTxnRef, String bankCode, String paymentMethod, String paymentUrl, String status, Timestamp transactionDate) {
        this.id = id;
        this.invoice = invoice;
        this.vnpTxnRef = vnpTxnRef;
        this.bankCode = bankCode;
        this.paymentMethod = paymentMethod;
        this.paymentUrl = paymentUrl;
        this.status = status;
        this.transactionDate = transactionDate;
    }

    // Constructor không có ID (dùng khi tạo mới)
    public Transaction(Invoice invoice, String vnpTxnRef, String bankCode, String paymentMethod, String paymentUrl, String status) {
        this.invoice = invoice;
        this.vnpTxnRef = vnpTxnRef;
        this.bankCode = bankCode;
        this.paymentMethod = paymentMethod;
        this.paymentUrl = paymentUrl;
        this.status = status;
        this.transactionDate = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Invoice getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice invoice) {
        this.invoice = invoice;
    }

    public String getVnpTxnRef() {
        return vnpTxnRef;
    }

    public void setVnpTxnRef(String vnpTxnRef) {
        this.vnpTxnRef = vnpTxnRef;
    }

    public String getBankCode() {
        return bankCode;
    }

    public void setBankCode(String bankCode) {
        this.bankCode = bankCode;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentUrl() {
        return paymentUrl;
    }

    public void setPaymentUrl(String paymentUrl) {
        this.paymentUrl = paymentUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }
}
