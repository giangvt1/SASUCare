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
         String sql = "INSERT INTO TestPackages (name, description, price, duration_minutes, category) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getName());
            ps.setString(2, model.getDescription());
            ps.setDouble(3, model.getPrice());
            ps.setInt(4, model.getDuration_minutes());
            ps.setString(5, model.getCategory());
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Insert TestPackage error", e);
        }
    }

    @Override
    public void update(Test model) {
        String sql = "UPDATE TestPackages SET name = ?, description = ?, price = ?, duration_minutes = ?, category = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getName());
            ps.setString(2, model.getDescription());
            ps.setDouble(3, model.getPrice());
            ps.setInt(4, model.getDuration_minutes());
            ps.setString(5, model.getCategory());
            ps.setInt(6, model.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Update TestPackage error", e);
        }
    }

    @Override
    public void delete(Test model) {
        String sql = "DELETE FROM TestPackages WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Delete TestPackage error", e);
        }
    }

    @Override
    public ArrayList<Test> list() {
    return list("Test");  // Mặc định lọc theo category = "Test"
}

public ArrayList<Test> list(String category) {
    ArrayList<Test> tests = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT * FROM ServicePackage");

    if (category != null && !category.isEmpty()) {
        sql.append(" WHERE category = ?");
    }

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        if (category != null && !category.isEmpty()) {
            ps.setString(1, category);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            tests.add(new Test(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category")
            ));
        }
    } catch (SQLException ex) {
        LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
    }
    return tests;
}
//    public ArrayList<Test> list(String category) {
//        List<Test> tests = new ArrayList<>();
//    String sql = "SELECT * FROM TestPackages WHERE category = ?";
//
//    try (PreparedStatement ps = connection.prepareStatement(sql)) {
//        ps.setString(1, category);
//
//        ResultSet rs = ps.executeQuery();
//        while (rs.next()) {
//            tests.add(new Test(
//                    rs.getInt("id"),
//                    rs.getString("name"),
//                    rs.getString("description"),
//                    rs.getDouble("price"),
//                    rs.getInt("duration_minutes"),
//                    rs.getString("category")
//            ));
//        }
//    } catch (SQLException ex) {
//        LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
//    }
//    return tests;
//    }

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
    

public List<Test> searchPackages(String keyword, String category, int pageIndex, int pageSize) {
    List<Test> tests = new ArrayList<>();
    String sql = "SELECT * FROM ServicePackage WHERE name LIKE ?";

    if (category != null && !category.equals("all")) {
        sql += " AND category = ?";
    }

    sql += " ORDER BY id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, "%" + (keyword != null ? keyword.trim() : "") + "%");

        int paramIndex = 2;
        if (category != null && !category.equals("all")) {
            ps.setString(paramIndex++, category);
        }
        ps.setInt(paramIndex++, (pageIndex - 1) * pageSize);
        ps.setInt(paramIndex, pageSize);

        

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            tests.add(new Test(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category")
            ));
        }
    } catch (SQLException ex) {
        LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
    }
    return tests;
}

public int countTotalPackages(String keyword, String category) {
    String sql = "SELECT COUNT(*) FROM ServicePackage WHERE name LIKE ?";
    if (category != null && !category.equals("all")) {
        sql += " AND category = ?";
    }

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, "%" + (keyword != null ? keyword.trim() : "") + "%");

        if (category != null && !category.equals("all")) {
            ps.setString(2, category);
        }

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException ex) {
        LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
    }
    return 0;
}
    
    public List<String> getAllCategories() {
    List<String> categories = new ArrayList<>();
    String sql = "SELECT DISTINCT category FROM ServicePackage WHERE category = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, "Test");  // Chỉ lấy các category có giá trị là "Test"
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            categories.add(rs.getString("category"));
        }
    } catch (SQLException ex) {
        LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
    }
    return categories;
}
    
}
