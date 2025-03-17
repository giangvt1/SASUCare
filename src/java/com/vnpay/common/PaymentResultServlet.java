package com.vnpay.common;

import dao.TransactionDBContext;
import model.Transaction;
import model.Invoice;
import dao.InvoiceDBContext;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment-result")
public class PaymentResultServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Capture payment response
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // Verify signature
        String signValue = Config.hashAllFields(fields);
        boolean isValidSignature = signValue.equals(vnp_SecureHash);

        // Get parameters from request
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_PayDate = request.getParameter("vnp_PayDate");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");

        String status = "00".equals(vnp_ResponseCode) ? "SUCCESS" : "FAILURE";

        InvoiceDBContext invoiceDB = new InvoiceDBContext();
        int invoiceId = invoiceDB.getInvoiceIdByTxnRef(vnp_TxnRef);

        // If invoice exists, store or update transaction in DB
        if (invoiceId != -1) {
            TransactionDBContext transactionDAO = new TransactionDBContext();
            Transaction existingTransaction = transactionDAO.getTransactionByInvoiceId(invoiceId);

            Invoice invoice = new Invoice();
            invoice.setId(invoiceId);

            Transaction transaction = new Transaction();
            transaction.setInvoice(invoice);
            transaction.setVnpTxnRef(vnp_TxnRef);
            transaction.setBankCode(vnp_BankCode);
            transaction.setPaymentMethod("VNPAYQR");
            transaction.setPaymentUrl("https://sandbox.vnpayment.vn/transaction");
            transaction.setStatus(status);
            transaction.setTransactionDate(Timestamp.valueOf(LocalDateTime.now()));

            if (existingTransaction != null) {
                transactionDAO.update(transaction);
            } else {
                transactionDAO.insert(transaction);
            }

            if ("00".equals(vnp_ResponseCode)) {
                invoice.setStatus("Paid");
                invoiceDB.update(invoice);
            }
        }

        // Forward to JSP with payment details
        request.setAttribute("vnp_TxnRef", vnp_TxnRef);
        request.setAttribute("vnp_TransactionNo", vnp_TransactionNo);
        request.setAttribute("vnp_BankCode", vnp_BankCode);
        request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
        request.setAttribute("vnp_PayDate", vnp_PayDate);
        request.setAttribute("vnp_Amount", vnp_Amount);
        request.setAttribute("vnp_OrderInfo", vnp_OrderInfo);
        request.setAttribute("status", isValidSignature ? status : "Invalid signature");

        request.getRequestDispatcher("/vnpay/vnpay_return.jsp").forward(request, response);
    }
}
