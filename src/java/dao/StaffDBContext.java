package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.system.Staff;
import model.system.User;

public class StaffDBContext extends DBContext<Staff> {

    private static final Logger LOGGER = Logger.getLogger(StaffDBContext.class.getName());
    

    @Override
    public void insert(Staff staff) {
        // Cập nhật câu lệnh INSERT bao gồm cột "img"
        String sql = "INSERT INTO [Staff] (staff_username, fullname, gender, address, dob, createby, createat, img) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setString(1, staff.getStaffusername().getUsername()); // Lấy username từ đối tượng User
            stm.setString(2, staff.getFullname());
            stm.setBoolean(3, staff.isGender());
            stm.setString(4, staff.getAddress());
            stm.setDate(5, staff.getDob());
            stm.setString(6, staff.getCreateby().getUsername());
            stm.setTimestamp(7, staff.getCreateat());
            stm.setString(8, staff.getImg()); // Giá trị của cột img (có thể null)

            stm.executeUpdate();
            try (ResultSet generatedKeys = stm.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    staff.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error in insert", ex);
            throw new RuntimeException("Lỗi khi insert Staff", ex);
        }
    }

    public Staff getByUsername(String username) {
        String sql = "SELECT * FROM [Staff] WHERE staff_username = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    Staff s = new Staff();
                    s.setId(rs.getInt("id"));
                    s.setFullname(rs.getString("fullname"));
                    s.setGender(rs.getBoolean("gender"));
                    s.setAddress(rs.getString("address"));
                    s.setDob(rs.getDate("dob"));

                    User createby = new User();
                    createby.setUsername(rs.getString("createby"));
                    s.setCreateby(createby);
                    s.setCreateat(rs.getTimestamp("createat"));

                    String updateByStr = rs.getString("updateby");
                    if (updateByStr != null) {
                        User updateby = new User();
                        updateby.setUsername(updateByStr);
                        s.setUpdateby(updateby);
                    }
                    s.setUpdateat(rs.getTimestamp("updateat"));

                    User staffUser = new User();
                    staffUser.setUsername(rs.getString("staff_username"));
                    s.setStaffusername(staffUser);

                    // Lấy cột img
                    s.setImg(rs.getString("img"));

                    return s;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error in getByUsername", ex);
            throw new RuntimeException("Lỗi khi lấy Staff theo username", ex);
        }
        return null;
    }

    @Override
    public void update(Staff staff) {
        String sql = "UPDATE [Staff] SET fullname = ?, gender = ?, address = ?, dob = ?, updateby = ?, updateat = ?, img = ? "
                + "WHERE staff_username = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, staff.getFullname());
            stm.setBoolean(2, staff.isGender());
            stm.setString(3, staff.getAddress());
            stm.setDate(4, staff.getDob());
            stm.setString(5, staff.getUpdateby().getUsername());
            stm.setTimestamp(6, staff.getUpdateat());
            stm.setString(7, staff.getImg()); // Cập nhật cột img
            stm.setString(8, staff.getStaffusername().getUsername());

            stm.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error in update", ex);
            throw new RuntimeException("Lỗi khi update Staff", ex);
        }
    }

    @Override
    public void delete(Staff model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Staff> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Staff get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public String getUserGmailByStaffId(int staffId) {
        String gmail = null;
        String sql = "SELECT u.gmail FROM Staff s JOIN [User] u ON s.staff_username = u.username WHERE s.id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                gmail = rs.getString("gmail");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return gmail;
    }

    public List<Staff> getStaffByRole(int roleId) {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT s.id, s.fullname "
                + "FROM [Staff] s "
                + "JOIN [UserRole] ur ON s.staff_username = ur.username "
                + "WHERE ur.role_id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, roleId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Staff s = new Staff();
                    s.setId(rs.getInt("id"));
                    s.setFullname(rs.getString("fullname"));
                    staffList.add(s);  // Thêm staff vào danh sách
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error in getStaffByRole", ex);
            throw new RuntimeException("Error retrieving staff by role", ex);
        }

        return staffList;
    }

}
