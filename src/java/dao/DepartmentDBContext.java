package dao;

import dal.DBContext;
import model.Department;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDBContext extends DBContext<Department> {

    // Phương thức lấy tất cả các chuyên khoa
    @Override
    public ArrayList<Department> list() {
        ArrayList<Department> departments = new ArrayList<>();
        String sql = "SELECT * FROM Department";  // Truy vấn lấy tất cả các chuyên khoa

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Department department = new Department();
                department.setId(rs.getInt("id"));
                department.setName(rs.getString("name"));
                departments.add(department);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return departments;
    }

    // Phương thức tìm kiếm chuyên khoa với các tham số
    public ArrayList<Department> search(Integer id, String name) {
        String sql = "SELECT * FROM Department WHERE (1=1)";
        ArrayList<Department> departments = new ArrayList<>();
        ArrayList<Object> paramValues = new ArrayList<>();

        if (id != null) {
            sql += " AND id = ?";
            paramValues.add(id);
        }

        if (name != null && !name.trim().isEmpty()) {
            sql += " AND name LIKE ?";
            paramValues.add("%" + name + "%");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            // Gán giá trị cho các tham số trong truy vấn
            for (int i = 0; i < paramValues.size(); i++) {
                ps.setObject(i + 1, paramValues.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Department department = new Department();
                    department.setId(rs.getInt("id"));
                    department.setName(rs.getString("name"));
                    departments.add(department);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return departments;
    }

    @Override
    public Department get(String id) {
        Department department = null;
        String sql = "SELECT * FROM Department WHERE id = ?";  // Truy vấn lấy chuyên khoa theo ID

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                department = new Department();
                department.setId(rs.getInt("id"));
                department.setName(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return department;
    }

    @Override
    public void insert(Department model) {
        String sql = "INSERT INTO Department (name) VALUES (?)";  // Truy vấn thêm chuyên khoa mới

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getName());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Department model) {
        String sql = "UPDATE Department SET name = ? WHERE id = ?";  // Truy vấn cập nhật chuyên khoa

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getName());
            ps.setInt(2, model.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Department model) {
        String sql = "DELETE FROM Department WHERE id = ?";  // Truy vấn xóa chuyên khoa

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
