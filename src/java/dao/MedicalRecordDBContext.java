/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.MedicalRecord;

/**
 *
 * @author ngoch
 */

public class MedicalRecordDBContext extends DBContext<MedicalRecord>{
    private static final Logger LOGGER = Logger.getLogger(CustomerDBContext.class.getName());

    @Override
    public void insert(MedicalRecord model) {
        String sql = "INSERT INTO MedicalRecords (customer_id, fullName, dob, phone, gender, job, idNumber, email, nation, province, district, ward, addressDetail)" +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getCustomer_id());
            stm.setString(2, model.getFullName());
            stm.setDate(3, new java.sql.Date(model.getDob().getTime())); // Convert Date to java.sql.Date
            stm.setString(4, model.getPhone());
            stm.setString(5, model.getGender());
            stm.setString(6, model.getJob());
            stm.setString(7, model.getIdNumber());
            stm.setString(8, model.getEmail());
            stm.setString(9, model.getNation());
            stm.setString(10, model.getProvince());
            stm.setString(11, model.getDistrict());
            stm.setString(12, model.getWard());
            stm.setString(13, model.getAddressDetail());

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Customer inserted successfully.");
            } else {
                System.out.println("Customer insert failed.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting customer: {0}", ex.getMessage());
        }
    }

    @Override
    public void update(MedicalRecord model) {
        String sql = "UPDATE MedicalRecords SET fullName = ?, dob = ?, phone = ?, gender = ?, job = ?, idNumber = ?, email = ?, nation = ?, province = ?, district = ?, ward = ?, addressDetail = ? WHERE record_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getFullName());
            stm.setDate(2, new java.sql.Date(model.getDob().getTime()));
            stm.setString(3, model.getPhone());
            stm.setString(4, model.getGender());
            stm.setString(5, model.getJob());
            stm.setString(6, model.getIdNumber());
            stm.setString(7, model.getEmail());
            stm.setString(8, model.getNation());
            stm.setString(9, model.getProvince());
            stm.setString(10, model.getDistrict());
            stm.setString(11, model.getWard());
            stm.setString(12, model.getAddressDetail());
            stm.setInt(13, model.getRecord_id());

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Record updated successfully.");
            } else {
                System.out.println("No record found to update.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating record: {0}", ex.getMessage());
        }
    }


    @Override
    public void delete(MedicalRecord model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    public void deleteById(int record_id) {
        String sql = "DELETE FROM MedicalRecords WHERE record_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, record_id);
            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Record deleted successfully.");
            } else {
                System.out.println("No record found to delete.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting record: {0}", ex.getMessage());
        }
    }

    @Override
    public ArrayList<MedicalRecord> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public MedicalRecord get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    
    
    public ArrayList<MedicalRecord> listByCustomerId(int customerId) {
        ArrayList<MedicalRecord> records = new ArrayList<>();
        String sql = "SELECT record_id, customer_id, fullName, dob, phone, gender, job, idNumber, email, nation, province, district, ward, addressDetail " +
                     "FROM MedicalRecords WHERE customer_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, customerId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setRecord_id(rs.getInt("record_id"));
                    record.setCustomer_id(rs.getInt("customer_id"));
                    record.setFullName(rs.getString("fullName"));
                    record.setDob(rs.getDate("dob")); // Lấy ngày dưới dạng java.sql.Date, có thể chuyển đổi nếu cần
                    record.setPhone(rs.getString("phone"));
                    record.setGender(rs.getString("gender"));
                    record.setJob(rs.getString("job"));
                    record.setIdNumber(rs.getString("idNumber"));
                    record.setEmail(rs.getString("email"));
                    record.setNation(rs.getString("nation"));
                    record.setProvince(rs.getString("province"));
                    record.setDistrict(rs.getString("district"));
                    record.setWard(rs.getString("ward"));
                    record.setAddressDetail(rs.getString("addressDetail"));
                    records.add(record);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing medical records: {0}", ex.getMessage());
        }
        return records;
    }
    
    public MedicalRecord getRecordById(int record_id) {
        String sql = "SELECT record_id, customer_id, fullName, dob, phone, gender, job, idNumber, email, nation, province, district, ward, addressDetail " +
                     "FROM MedicalRecords WHERE record_id = ?";
        MedicalRecord record = new MedicalRecord();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, record_id);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    record.setRecord_id(rs.getInt("record_id"));
                    record.setCustomer_id(rs.getInt("customer_id"));
                    record.setFullName(rs.getString("fullName"));
                    record.setDob(rs.getDate("dob")); // Lấy ngày dưới dạng java.sql.Date, có thể chuyển đổi nếu cần
                    record.setPhone(rs.getString("phone"));
                    record.setGender(rs.getString("gender"));
                    record.setJob(rs.getString("job"));
                    record.setIdNumber(rs.getString("idNumber"));
                    record.setEmail(rs.getString("email"));
                    record.setNation(rs.getString("nation"));
                    record.setProvince(rs.getString("province"));
                    record.setDistrict(rs.getString("district"));
                    record.setWard(rs.getString("ward"));
                    record.setAddressDetail(rs.getString("addressDetail"));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing medical records: {0}", ex.getMessage());
        }
        return record;
    }
}
