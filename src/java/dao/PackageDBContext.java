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
        String sql = "INSERT INTO ServicePackage (name, description, price, duration_minutes, category, service_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, pkg.getName());
            ps.setString(2, pkg.getDescription());
            ps.setDouble(3, pkg.getPrice());
            ps.setInt(4, pkg.getDurationMinutes());
            ps.setString(5, pkg.getCategory());
            ps.setInt(6, pkg.getServiceId()); // Thêm service_id vào câu lệnh INSERT
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
    }

    // Phương thức cập nhật gói khám
    @Override
    public void update(Package pkg) {
        String sql = "UPDATE ServicePackage  SET name = ?, description = ?, price = ?, duration_minutes = ?, category = ? WHERE id = ?";
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
        String sql = "DELETE FROM ServicePackage  WHERE id = ?";
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
        String sql = "SELECT * FROM ServicePackage ";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        String sql = "SELECT * FROM ServicePackage  WHERE id = ?";
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
    public List<Package> searchPackages1(String keyword, String category, int pageIndex, int pageSize) {
//        List<Package> packages = new ArrayList<>();
//        String sql = "SELECT * FROM ServicePackage  WHERE name LIKE ?";
//
//        if (category != null && !category.isEmpty() && !category.equals("all")) {
//            sql += " AND category = ?";
//        }
//
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setString(1, "%" + keyword + "%");
////            ps.setString(2, "%" + keyword + "%");
//
//            if (category != null && !category.isEmpty() && !category.equals("all")) {
//                ps.setString(2, category);
//            }
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Package pkg = new Package(
//                    rs.getInt("id"),
//                    rs.getString("name"),
//                    rs.getString("description"),
//                    rs.getDouble("price"),
//                    rs.getInt("duration_minutes"),
//                    rs.getString("category")
//                );
//                packages.add(pkg);
//            }
//        } catch (SQLException ex) {
//            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
//        }
//        return packages;
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM ServicePackage WHERE REPLACE(name, ' ', '') LIKE ?";

        if (category != null && !category.isEmpty() && !category.equals("all")) {
            sql += " AND category = ?";
        }
        sql += " ORDER BY name OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String filter = "%" + (keyword != null ? keyword.replaceAll("\\s+", "") : "") + "%";
            ps.setString(1, filter);

            int paramIndex = 2;
            if (category != null && !category.isEmpty() && !category.equals("all")) {
                ps.setString(paramIndex++, category);
            }
            ps.setInt(paramIndex++, (pageIndex - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                packages.add(new Package(
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
        return packages;

    }

    public List<Package> searchPackages(String keyword, String category, int pageIndex, int pageSize) {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT [id]\n"
                + "      ,[name]\n"
                + "      ,[description]\n"
                + "      ,[price]\n"
                + "      ,[duration_minutes]\n"
                + "      ,[category] FROM ServicePackage WHERE name LIKE ?";

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

            // 🔥 Debug query
            System.out.println("Executing SQL: " + ps.toString());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                packages.add(new Package(
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
        return packages;
    }

    // Đếm tổng số gói khám để tính tổng số trang
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

    public List<String> getAllCategories1() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM ServicePackage";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return categories;
    }

    // Phương thức lấy tất cả danh mục để hiển thị trong bộ lọc  
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM ServicePackage WHERE category = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "Packages");  // Chỉ lấy các category có giá trị là "Test"

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
