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
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.GoogleAccount;

/**
 *
 * @author ngoch
 */
public class GoogleDBContext extends DBContext<GoogleAccount>{
    private static final Logger LOGGER = Logger.getLogger(GoogleDBContext.class.getName());
    
    public GoogleAccount findByEmail(String email) {
        String sql = "SELECT * FROM [Google_Authen] WHERE email = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                GoogleAccount account = new GoogleAccount();
                account.setId(rs.getString("account_id")); // Lấy account_id
                account.setEmail(rs.getString("email")); // Lấy email
                account.setName(rs.getString("name")); // Lấy name
                account.setFirst_name(rs.getString("first_name")); // Lấy first_name
                account.setGiven_name(rs.getString("given_name")); // Lấy given_name
                account.setFamily_name(rs.getString("family_name")); // Lấy family_name
                account.setPicture(rs.getString("picture")); // Lấy picture
                account.setVerified_email(rs.getBoolean("verified_email")); // Lấy verified_email
                return account;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: {0}", ex.getMessage());
        }
        return null;
    }
        
    @Override
    public void insert(GoogleAccount model) {
        String sql = """
            INSERT INTO [Google_Authen] (account_id, email, name, first_name, given_name, family_name, picture, verified_email) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getId()); // Sử dụng account_id từ entity
            stm.setString(2, model.getEmail()); // Gán email
            stm.setString(3, model.getName()); // Gán name
            stm.setString(4, model.getFirst_name()); // Gán first_name
            stm.setString(5, model.getGiven_name()); // Gán given_name
            stm.setString(6, model.getFamily_name()); // Gán family_name
            stm.setString(7, model.getPicture()); // Gán picture
            stm.setBoolean(8, model.isVerified_email()); // Gán verified_email (kiểu boolean)

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("GoogleAccount inserted successfully.");
            } else {
                System.out.println("GoogleAccount insert failed.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting GoogleAccount: {0}", ex.getMessage());
        }
    }

    @Override
    public void update(GoogleAccount model) {
        String sql = """
            UPDATE GoogleAccount 
            SET email = ?, name = ?, first_name = ?, given_name = ?, family_name = ?, picture = ?, verified_email = ?
            WHERE account_id = ?
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getEmail()); // Gán email
            stm.setString(2, model.getName()); // Gán name (tương ứng với `username` trong bảng)
            stm.setString(3, model.getFirst_name()); // Gán first_name
            stm.setString(4, model.getGiven_name()); // Gán given_name
            stm.setString(5, model.getFamily_name()); // Gán family_name
            stm.setString(6, model.getPicture()); // Gán picture
            stm.setBoolean(7, model.isVerified_email()); // Gán verified_email (kiểu boolean)
            stm.setString(8, model.getId()); // Gán account_id (khóa chính)

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("GoogleAccount updated successfully.");
            } else {
                System.out.println("No GoogleAccount found with the given account_id.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating GoogleAccount: {0}", ex.getMessage());
        }
    }

    @Override
    public void delete(GoogleAccount model) {
        String sql = "DELETE FROM [Google_Authen] WHERE account_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getId()); // Sử dụng account_id thay cho id

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("GoogleAccount deleted successfully.");
            } else {
                System.out.println("No GoogleAccount found with the given account_id.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting GoogleAccount: {0}", ex.getMessage());
        }
    }

    @Override
    public ArrayList<GoogleAccount> list() {
        ArrayList<GoogleAccount> ggAccounts = new ArrayList<>();
        String sql = "SELECT * FROM GoogleAccount";
        try (Statement stm = connection.createStatement(); ResultSet rs = stm.executeQuery(sql)) {
            while (rs.next()) {
                GoogleAccount account = new GoogleAccount();
                account.setId(rs.getString("account_id")); // Thay 'id' bằng 'account_id'
                account.setEmail(rs.getString("email"));
                account.setName(rs.getString("name")); // Trường 'name' trong bảng GoogleAccount
                account.setFirst_name(rs.getString("first_name")); // Thêm trường 'first_name'
                account.setGiven_name(rs.getString("given_name")); // Thêm trường 'given_name'
                account.setFamily_name(rs.getString("family_name")); // Thêm trường 'family_name'
                account.setPicture(rs.getString("picture"));
                account.setVerified_email(rs.getBoolean("verified_email")); 

                ggAccounts.add(account);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing GoogleAccounts: {0}", ex.getMessage());
        }
        return ggAccounts;
    }
        
    @Override
    public GoogleAccount get(String account_id) {
        GoogleAccount account = null;
        String sql = "SELECT * FROM GoogleAccount WHERE account_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, account_id); // Thay 'id' bằng 'account_id'
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                account = new GoogleAccount();
                account.setId(rs.getString("account_id")); // Dùng 'account_id' thay vì 'id'
                account.setEmail(rs.getString("email"));
                account.setName(rs.getString("name")); // Trường 'name' trong bảng GoogleAccount
                account.setFirst_name(rs.getString("first_name")); // Thêm 'first_name'
                account.setGiven_name(rs.getString("given_name")); // Thêm 'given_name'
                account.setFamily_name(rs.getString("family_name")); // Thêm 'family_name'
                account.setPicture(rs.getString("picture"));
                account.setVerified_email(rs.getBoolean("verified_email"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching GoogleAccount data: {0}", ex.getMessage());
        }
        return account;
    }
    
    
}
