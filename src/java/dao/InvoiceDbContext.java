/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import model.Invoice;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Golden Lightning
 */
public class InvoiceDbContext extends DBContext<Invoice>{

    @Override
    public void insert(Invoice model) {
              String sql = "INSERT INTO Invoices (vnp_TxnRef, order_info, created_date, customer_id, service_id) " +
                     "VALUES (?, ?, GETDATE(), ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            // Set the values for the SQL query
            stmt.setString(1, model.getTxnRef());  // vnp_TxnRef
            stmt.setString(2, model.getOrderInfo());  // order_info
            stmt.setInt(3, model.getCustomerId());    // customer_id
            stmt.setInt(4, model.getServiceId());     // service_id

            // Execute the update (insert)
            int rowsAffected = stmt.executeUpdate();  // Returns the number of rows affected

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    model.setId(generatedKeys.getInt(1));
                    System.out.println("Appointment inserted with ID: " + model.getId());
                }
            } else {
                System.out.println("Failed to insert appointment.");
            }
        } catch (SQLException ex) {
//            LOGGER.log(Level.SEVERE, "Error inserting appointment: {0}", ex.getMessage());
            ex.printStackTrace();
        }

    }

    @Override
    public void update(Invoice model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Invoice model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Invoice> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Invoice get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
