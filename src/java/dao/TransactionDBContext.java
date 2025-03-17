/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.util.ArrayList;
import model.Transaction;
import java.sql.*;

/**
 *
 * @author Golden Lightning
 */
public class TransactionDBContext extends DBContext<Transaction>{

    @Override
    public void insert(Transaction transaction) {
        String sql = "INSERT INTO [Transaction] (invoice_id, vnp_TxnRef, bank_code, payment_method, payment_url, status, transaction_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

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
        }}

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