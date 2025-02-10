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
import java.util.List;
import model.Test;
import model.Vaccine;

/**
 *
 * @author admin
 */
public class TestPackageDBContext extends DBContext<Test>{
    
    
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(DBContext.class.getName());
    
    

    @Override
    public void insert(Test model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Test model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Test model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Test> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Test get(String id) {
        String sql = "select * from TestPackages where id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                        return new Test(rs.getInt("id")
                                , rs.getString("name")
                                , rs.getString("description")
                                , rs.getDouble("price")
                                , rs.getInt("duration_minutes")
                                , rs.getString("category"));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return null;
    }
    
    
    public List<Test> searchPackages(String keyword, String category) {
        List<Test> Test = new ArrayList<>();
        String sql = "SELECT * FROM TestPackages WHERE name LIKE ?";

        if (category != null && !category.isEmpty() && !category.equals("all")) {
            sql += " AND category = ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
//            ps.setString(2, "%" + keyword + "%");

            if (category != null && !category.isEmpty() && !category.equals("all")) {
                ps.setString(2, category);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test t = new Test(rs.getInt("id")
                                , rs.getString("name")
                                , rs.getString("description")
                                , rs.getDouble("price")
                                , rs.getInt("duration_minutes")
                                , rs.getString("category"));
                Test.add(t);
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return Test;
    }
    
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM TestPackages";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return categories;
    }
    
}
