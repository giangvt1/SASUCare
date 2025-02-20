package dao;




import dal.DBContext;
import model.Package;
import java.lang.System.Logger;
import java.lang.System.Logger.Level;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author admin
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;

public class PackageDBContext extends DBContext<Package> {

    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(DBContext.class.getName());

    // Phương thức thêm gói khám mới
    @Override
    public void insert(Package pkg) {
        String sql = "INSERT INTO packages (name, description, price, duration_minutes, category) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, pkg.getName());
            ps.setString(2, pkg.getDescription());
            ps.setDouble(3, pkg.getPrice());
            ps.setInt(4, pkg.getDurationMinutes());
            ps.setString(5, pkg.getCategory());
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
    }

    // Phương thức cập nhật gói khám
    @Override
    public void update(Package pkg) {
        String sql = "UPDATE packages SET name = ?, description = ?, price = ?, duration_minutes = ?, category = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pkg.getName());
            ps.setString(2, pkg.getDescription());
            ps.setDouble(3, pkg.getPrice());
            ps.setInt(4, pkg.getDurationMinutes());
            ps.setString(5, pkg.getCategory());
            ps.setInt(6, pkg.getId());
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
    }

    // Phương thức xóa gói khám
    @Override
    public void delete(Package pkg) {
         String sql = "DELETE FROM packages WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pkg.getId());
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
    }

    // Phương thức lấy danh sách tất cả gói khám
    @Override
    public ArrayList<Package> list() {
        ArrayList<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Package pkg = new Package(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category")
                );
                packages.add(pkg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }

    // Phương thức lấy thông tin chi tiết của một gói khám theo ID
    @Override
    public Package get(String id) {
        String sql = "SELECT * FROM packages WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Package(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category")
                );
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return null;
    }

    // Phương thức tìm kiếm gói khám theo từ khóa và danh mục
    public List<Package> searchPackages(String keyword, String category) {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages WHERE name LIKE ?";

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
                Package pkg = new Package(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category")
                );
                packages.add(pkg);
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return packages;
    }

    // Phương thức lấy tất cả danh mục để hiển thị trong bộ lọc
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM packages";
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
