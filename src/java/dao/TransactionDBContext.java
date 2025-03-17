/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Transaction;

/**
 *
 * @author Golden Lightning
 */
public class TransactionDBContext extends DBContext<Transaction> {

    // Method to get transactions for a specific invoice
    public List<Transaction> getTransactionsByInvoiceId(int invoiceId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM [Transaction] WHERE invoice_id = ?";  // Assuming the relation is by invoice_id

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);  // Set the invoice ID parameter

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setId(rs.getInt("id"));
                transaction.setVnpTxnRef(rs.getString("vnp_TxnRef"));
                transaction.setBankCode(rs.getString("bankCode"));
                transaction.setPaymentMethod(rs.getString("paymentMethod"));
                transaction.setPaymentUrl(rs.getString("paymentUrl"));
                transaction.setStatus(rs.getString("status"));
                transaction.setTransactionDate(rs.getTimestamp("transactionDate"));

                // Set the associated invoice
                // If you need to load the related Invoice, you can also query the invoice here
                // For simplicity, we assume that the Transaction object already has a reference to the Invoice
                transactions.add(transaction);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.err.println("Error while fetching transactions for invoice ID " + invoiceId + ": " + ex.getMessage());
        }

        return transactions;
    }

    @Override
    public void insert(Transaction transaction) {
        String sql = "INSERT INTO [Transaction] (invoice_id, vnp_TxnRef, bank_code, payment_method, payment_url, status, transaction_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, transaction.getInvoice().getId());
            stmt.setString(2, transaction.getVnpTxnRef()); // Add vnp_TxnRef
            stmt.setString(3, transaction.getBankCode());
            stmt.setString(4, transaction.getPaymentMethod());
            stmt.setString(5, transaction.getPaymentUrl());
            stmt.setString(6, transaction.getStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    transaction.setId(generatedKeys.getInt(1));
                    System.out.println("Transaction inserted with ID: " + transaction.getId());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Transaction model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Transaction model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Transaction> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Transaction get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
