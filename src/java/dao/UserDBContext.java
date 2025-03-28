/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import org.mindrot.jbcrypt.BCrypt;
import dal.DBContext;
import java.util.ArrayList;
import model.system.User;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.system.Feature;
import model.system.Role;
import model.system.UserAccountDTO;

/**
 *
 * @author acer
 */
public class UserDBContext extends DBContext<User> {

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM [User] WHERE gmail = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean resetPassword(String username, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE username = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Hash mật khẩu mới sử dụng hàm hashPassword đã có trong class
            String hashedPassword = hashPassword(newPassword);
            stm.setString(1, hashedPassword);
            stm.setString(2, username);
            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean resetPasswordwithgmail(String gmail, String newPassword) {
        String sql = "UPDATE [User] SET password = ? WHERE gmail = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Hash mật khẩu mới sử dụng hàm hashPassword đã có trong class
            String hashedPassword = hashPassword(newPassword);
            stm.setString(1, hashedPassword);
            stm.setString(2, gmail);
            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public ArrayList<UserAccountDTO> listAccounts(String search, int pageIndex, int pageSize) {
        ArrayList<UserAccountDTO> list = new ArrayList<>();

        // Xử lý tìm kiếm (tạo pattern LIKE với khoảng trắng thành "%")
        String searchPattern = "%";
        if (search != null && !search.trim().isEmpty()) {
            searchPattern += search.trim().replaceAll("\\s+", "%") + "%";
        }

        String sql = """
        SELECT s.staff_username, s.fullname, u.displayname, u.gmail, u.phone,
               s.gender, s.dob, s.createat, s.createby, s.updateat, s.updateby, r.name as roleName
        FROM [User] u
        JOIN UserRole ur ON ur.username = u.username
        JOIN [Role] r ON r.id = ur.role_id
        JOIN Staff s ON s.staff_username = u.username
        WHERE u.username LIKE ? OR u.displayname LIKE ? OR s.fullname LIKE ?
        ORDER BY s.staff_username ASC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, searchPattern);
            stm.setString(2, searchPattern);
            stm.setString(3, searchPattern);
            stm.setInt(4, (pageIndex - 1) * pageSize);
            stm.setInt(5, pageSize);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    UserAccountDTO dto = new UserAccountDTO();
                    dto.setStaffUsername(rs.getString("staff_username"));
                    dto.setFullname(rs.getString("fullname"));
                    dto.setDisplayname(rs.getString("displayname"));
                    dto.setGmail(rs.getString("gmail"));
                    dto.setPhone(rs.getString("phone"));
                    dto.setGender(rs.getBoolean("gender"));
                    dto.setDob(rs.getDate("dob"));
                    dto.setCreateat(rs.getTimestamp("createat"));
                    dto.setCreateby(rs.getString("createby"));
                    dto.setUpdateat(rs.getTimestamp("updateat"));
                    dto.setUpdateby(rs.getString("updateby"));
                    dto.setRoleName(rs.getString("roleName"));
                    list.add(dto);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public int getTotalUserCount(String search) {
        int total = 0;

        // Xử lý tìm kiếm
        String searchPattern = "%";
        if (search != null && !search.trim().isEmpty()) {
            searchPattern += search.trim().replaceAll("\\s+", "%") + "%";
        }

        String sql = """
        SELECT COUNT(*) AS Total
        FROM [User] u
        JOIN UserRole ur ON ur.username = u.username
        JOIN [Role] r ON r.id = ur.role_id
        JOIN Staff s ON s.staff_username = u.username
        WHERE u.username LIKE ? OR u.displayname LIKE ? OR s.fullname LIKE ?
    """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, searchPattern);
            stm.setString(2, searchPattern);
            stm.setString(3, searchPattern);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("Total");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return total;
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM [User] WHERE username = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setDisplayname(rs.getString("displayname"));
                user.setGmail(rs.getString("gmail"));
                user.setPhone(rs.getString("phone"));
                return user;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE [User] SET displayname = ?, gmail = ?, phone = ? WHERE username = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, user.getDisplayname());
            stm.setString(2, user.getGmail());
            stm.setString(3, user.getPhone());
            stm.setString(4, user.getUsername());
            int rowsUpdated = stm.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public void deleteUser(String username) {
        String sqlSelectStaff = "SELECT id, isDoctor FROM Staff WHERE staff_username = ?";
        String sqlDeleteDoctorDepartment = "DELETE FROM Doctor_Department WHERE doctor_id IN (SELECT id FROM Doctor WHERE staff_id = ?)";
        String sqlDeleteDoctorSchedule = "DELETE FROM Doctor_Schedule WHERE doctor_id IN (SELECT id FROM Doctor WHERE staff_id = ?)";
        String sqlDeleteDoctor = "DELETE FROM Doctor WHERE staff_id = ?";
        String sqlDeleteStaff = "DELETE FROM Staff WHERE id = ?";
        String sqlDeleteUserRole = "DELETE FROM UserRole WHERE username = ?";
        String sqlDeleteUser = "DELETE FROM [User] WHERE username = ?";

        try {
            connection.setAutoCommit(false); // Start transaction

            // First, fetch the staff id and isDoctor flag
            int staffId = -1;
            boolean isDoctor = false;
            try (PreparedStatement psSelectStaff = connection.prepareStatement(sqlSelectStaff)) {
                psSelectStaff.setString(1, username);
                try (ResultSet rs = psSelectStaff.executeQuery()) {
                    if (rs.next()) {
                        staffId = rs.getInt("id");
                        isDoctor = rs.getBoolean("isDoctor");
                    } else {
                        throw new SQLException("User with username '" + username + "' not found.");
                    }
                }
            }

            // If the user is a doctor, delete doctor-related records first
            if (isDoctor) {
                try (PreparedStatement psDeleteDoctorDepartment = connection.prepareStatement(sqlDeleteDoctorDepartment); PreparedStatement psDeleteDoctorSchedule = connection.prepareStatement(sqlDeleteDoctorSchedule); PreparedStatement psDeleteDoctor = connection.prepareStatement(sqlDeleteDoctor)) {

                    psDeleteDoctorDepartment.setInt(1, staffId);
                    psDeleteDoctorDepartment.executeUpdate();

                    psDeleteDoctorSchedule.setInt(1, staffId);
                    psDeleteDoctorSchedule.executeUpdate();

                    psDeleteDoctor.setInt(1, staffId);
                    psDeleteDoctor.executeUpdate();
                }
            }

            // Delete the staff record
            try (PreparedStatement psDeleteStaff = connection.prepareStatement(sqlDeleteStaff)) {
                psDeleteStaff.setInt(1, staffId);
                psDeleteStaff.executeUpdate();
            }

            // Delete from UserRole table
            try (PreparedStatement psDeleteUserRole = connection.prepareStatement(sqlDeleteUserRole)) {
                psDeleteUserRole.setString(1, username);
                psDeleteUserRole.executeUpdate();
            }

            // Delete from User table
            try (PreparedStatement psDeleteUser = connection.prepareStatement(sqlDeleteUser)) {
                psDeleteUser.setString(1, username);
                psDeleteUser.executeUpdate();
            }

            connection.commit(); // Commit if all deletes were successful
            System.out.println("User '" + username + "' deleted successfully.");
        } catch (SQLException ex) {
            System.err.println("Error deleting user '" + username + "': " + ex.getMessage());
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            if (connection != null) {
                try {
                    connection.rollback(); // Rollback if an error occurred
                    System.err.println("Transaction rolled back.");
                } catch (SQLException rollbackEx) {
                    System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
                    Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, rollbackEx);
                }
            }
            throw new RuntimeException(ex);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true); // Reset auto-commit mode
                    connection.close(); // Close the connection if you are managing it here
                } catch (SQLException closeEx) {
                    System.err.println("Error closing connection: " + closeEx.getMessage());
                    Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, closeEx);
                }
            }
        }

    }

    @Override
    public void insert(User model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void insert(User model, User createdBy) {
        // SQL cho các bảng
        String sql_insert_user = "INSERT INTO [User](username, password, displayname, gmail, phone) VALUES (?,?,?,?,?)";
        String sql_insert_user_role = "INSERT INTO [UserRole](username, role_id) VALUES (?,?)";
        String sql_insert_staff = "INSERT INTO [Staff](staff_username, createby, createat) VALUES (?,?,?)";
        String sql_insert_doctor = "INSERT INTO [Doctor](staff_id) VALUES (?)";
        String sql_insert_doctor_department = "INSERT INTO [Doctor_Department](doctor_id, department_id) VALUES (?, ?)";

        // Hash mật khẩu sử dụng BCrypt
        String hashedPassword = BCrypt.hashpw(model.getPassword(), BCrypt.gensalt(12));

        try (PreparedStatement stmUser = connection.prepareStatement(sql_insert_user); PreparedStatement stmUserRole = connection.prepareStatement(sql_insert_user_role); // Dùng RETURN_GENERATED_KEYS để lấy id của Staff
                 PreparedStatement stmStaff = connection.prepareStatement(sql_insert_staff, Statement.RETURN_GENERATED_KEYS); // Dùng RETURN_GENERATED_KEYS để lấy id của Doctor
                 PreparedStatement stmDoctor = connection.prepareStatement(sql_insert_doctor, Statement.RETURN_GENERATED_KEYS); PreparedStatement stmDoctorDept = connection.prepareStatement(sql_insert_doctor_department)) {

            connection.setAutoCommit(false);

            // 1. Insert vào bảng [User]
            stmUser.setString(1, model.getUsername());
            stmUser.setString(2, hashedPassword);
            stmUser.setString(3, model.getDisplayname());
            stmUser.setString(4, model.getGmail());
            stmUser.setString(5, model.getPhone());
            stmUser.executeUpdate();

            // 2. Insert vào bảng [UserRole]
            if (model.getRoles() != null) {
                for (Role role : model.getRoles()) {
                    stmUserRole.setString(1, model.getUsername());
                    stmUserRole.setInt(2, role.getId());
                    stmUserRole.executeUpdate();
                }
            }

            // 3. Insert vào bảng [Staff]
            Timestamp createAt = new Timestamp(System.currentTimeMillis());
            stmStaff.setString(1, model.getUsername());
            stmStaff.setString(2, createdBy.getUsername());
            stmStaff.setTimestamp(3, createAt);
            stmStaff.executeUpdate();

            int generatedStaffId = -1;
            try (ResultSet rs = stmStaff.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedStaffId = rs.getInt(1);
                }
            }

            // 4. Kiểm tra nếu user có role là Doctor
            boolean isDoctor = false;
            if (model.getRoles() != null) {
                for (Role role : model.getRoles()) {
                    // Giả sử role_id = 5 là Doctor
                    if (role.getId() == 5) {
                        isDoctor = true;
                        break;
                    }
                }
            }

            int generatedDoctorId = -1;
            if (isDoctor && generatedStaffId != -1) {
                stmDoctor.setInt(1, generatedStaffId);
                stmDoctor.executeUpdate();

                try (ResultSet rs = stmDoctor.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedDoctorId = rs.getInt(1);
                    }
                }
            }

            // 5. Nếu là Doctor và có thông tin phòng ban (departments) được set,
            //    duyệt qua danh sách phòng ban và insert vào bảng Doctor_Department
            if (isDoctor && generatedDoctorId != -1
                    && model.getDep() != null && !model.getDep().isEmpty()) {
                for (model.Department dept : model.getDep()) {
                    stmDoctorDept.setInt(1, generatedDoctorId);
                    stmDoctorDept.setInt(2, dept.getId());
                    stmDoctorDept.executeUpdate();
                }
            }

            connection.commit();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException e) {
                Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, "Rollback failed", e);
            }
            if (ex.getMessage().contains("Violation of PRIMARY KEY constraint")) {
                throw new RuntimeException("Username is duplicated", ex);
            } else {
                throw new RuntimeException("Error inserting user: " + ex.getMessage(), ex);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, "Failed to reset auto-commit", ex);
            }
        }
    }

    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12)); // Độ mạnh 12
    }

    public User login(String username, String password) {
        String sql = "SELECT username, password, displayname, gmail FROM [User] WHERE username = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password"); // Mật khẩu đã hash trong DB

                // Kiểm tra mật khẩu nhập vào có khớp với mật khẩu đã hash không
                if (BCrypt.checkpw(password, storedPassword)) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setDisplayname(rs.getString("displayname"));
                    user.setGmail(rs.getString("gmail"));
                    return user;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public void update(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<User> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public User get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public ArrayList<Role> getRoles(String username) {
        ArrayList<Role> roles = new ArrayList<>();
        String sql = """
            SELECT r.id, r.name, f.id as feature_id, f.name as feature_name, f.url 
            FROM UserRole ur 
            JOIN Role r ON ur.role_id = r.id 
            LEFT JOIN RoleFeature rf ON r.id = rf.role_id
            LEFT JOIN Feature f ON rf.feature_id = f.id
            WHERE ur.username = ?
    """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            ResultSet rs = stm.executeQuery();

            Map<Integer, Role> roleMap = new HashMap<>();

            while (rs.next()) {
                int roleId = rs.getInt("id");

                // Get or create role
                Role role = roleMap.computeIfAbsent(roleId, k -> {
                    Role newRole = new Role();
                    newRole.setId(roleId);
                    try {
                        newRole.setName(rs.getString("name"));
                    } catch (SQLException ex) {
                        Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    newRole.setFeatures(new ArrayList<>());
                    return newRole;
                });

                // Add feature if exists
                int featureId = rs.getInt("feature_id");
                if (!rs.wasNull()) {
                    Feature feature = new Feature();
                    feature.setId(featureId);
                    feature.setName(rs.getString("feature_name"));
                    feature.setUrl(rs.getString("url"));
                    role.getFeatures().add(feature);
                }
            }

            roles.addAll(roleMap.values());

        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName())
                    .log(Level.SEVERE, "Error getting roles and features", ex);
        }
        return roles;
    }

}
