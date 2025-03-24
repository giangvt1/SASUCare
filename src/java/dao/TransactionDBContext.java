/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Invoice;
import model.Transaction;

/**
 *
 * @author Golden Lightning
 */
public class TransactionDBContext extends DBContext<Transaction> {
    
    

    public Transaction getTransactionByInvoiceId(int invoiceId) {
        Transaction transaction = null;
        String sql = "SELECT [id]\n"
                + "      ,[invoice_id]\n"
                + "      ,[bank_code]\n"
                + "      ,[payment_method]\n"
                + "      ,[payment_url]\n"
                + "      ,[status]\n"
                + "      ,[transaction_date]\n"
                + "      ,[vnp_TxnRef] FROM [Transaction] WHERE invoice_id = ?"; // Ensure the table name matches your schema

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, invoiceId);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                transaction = new Transaction();
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("invoice_id"));

                transaction.setId(rs.getInt("id"));
                transaction.setInvoice(invoice);
                transaction.setVnpTxnRef(rs.getString("vnp_txn_ref"));
                transaction.setBankCode(rs.getString("bank_code"));
                transaction.setPaymentMethod(rs.getString("payment_method"));
                transaction.setPaymentUrl(rs.getString("payment_url"));
                transaction.setStatus(rs.getString("status"));
                transaction.setTransactionDate(rs.getTimestamp("transaction_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return transaction;
    }

    // Method to get transactions for a specific invoice
    public Transaction getTransactionsByInvoiceId(int invoiceId) {
        List<Transaction> transactions = new ArrayList<>();
        Transaction transaction = new Transaction();
        String sql = "SELECT * FROM [Transaction] WHERE invoice_id = ?";  // Assuming the relation is by invoice_id

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);  // Set the invoice ID parameter

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
     
                transaction.setId(rs.getInt("id"));
                transaction.setVnpTxnRef(rs.getString("vnp_TxnRef"));
                transaction.setBankCode(rs.getString("bank_Code"));
                transaction.setPaymentMethod(rs.getString("payment_Method"));
                transaction.setPaymentUrl(rs.getString("payment_Url"));
                transaction.setStatus(rs.getString("status"));
                transaction.setTransactionDate(rs.getTimestamp("transaction_Date"));

                // Set the associated invoice
                // If you need to load the related Invoice, you can also query the invoice here
                // For simplicity, we assume that the Transaction object already has a reference to the Invoice
                transactions.add(transaction);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.err.println("Error while fetching transactions for invoice ID " + invoiceId + ": " + ex.getMessage());
        }

        return transaction;
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
    public void update(Transaction transaction) {
        String sql = "UPDATE [Transaction] SET vnp_txn_ref = ?, bank_code = ?, payment_method = ?, "
                + "payment_url = ?, status = ?, transaction_date = ? WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, transaction.getVnpTxnRef());
            statement.setString(2, transaction.getBankCode());
            statement.setString(3, transaction.getPaymentMethod());
            statement.setString(4, transaction.getPaymentUrl());
            statement.setString(5, transaction.getStatus());
            statement.setTimestamp(6, transaction.getTransactionDate());
            statement.setInt(7, transaction.getId());

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
