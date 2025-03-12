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
                    return rs.getInt(1) > 0; // Nếu count > 0 nghĩa là email đã tồn tại
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

    public ArrayList<User> listPaginated(int pageIndex, int pageSize) {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT * FROM [User] ORDER BY username OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Tính offset dựa trên trang: (pageIndex - 1) * pageSize
            stm.setInt(1, (pageIndex - 1) * pageSize);
            stm.setInt(2, pageSize);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setDisplayname(rs.getString("displayname"));
                    user.setGmail(rs.getString("gmail"));
                    user.setPhone(rs.getString("phone"));
                    // Nếu cần, lấy danh sách role cho user
                    user.setRoles(this.getRoles(user.getUsername()));
                    users.add(user);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
    }

    public ArrayList<UserAccountDTO> listAccounts(String search, int pageIndex, int pageSize) {
        ArrayList<UserAccountDTO> list = new ArrayList<>();
        String sql = "SELECT s.staff_username, s.fullname, u.displayname, u.gmail, u.phone, "
                + "s.gender, s.dob, s.createat, s.createby, s.updateat, s.updateby, r.name as roleName "
                + "FROM [User] u "
                + "JOIN UserRole ur ON ur.username = u.username "
                + "JOIN [Role] r ON r.id = ur.role_id "
                + "JOIN Staff s ON s.staff_username = u.username "
                + "WHERE u.username LIKE ? OR u.displayname LIKE ? OR s.fullname LIKE ? "
                + "ORDER BY s.staff_username ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Nếu search là null, ta gán chuỗi rỗng, sau đó tạo pattern cho LIKE
            String filter = "%" + (search != null ? search.trim() : "") + "%";
            stm.setString(1, filter);
            stm.setString(2, filter);
            stm.setString(3, filter);
            // Tính toán offset
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

    public ArrayList<User> searchAndPaginate(String keyword, int pageIndex, int pageSize) {
        ArrayList<User> users = new ArrayList<>();
        // Sử dụng REPLACE để loại bỏ khoảng trắng từ username và gmail
        String sql = "SELECT * FROM [User] "
                + "WHERE REPLACE(username, ' ', '') LIKE ? OR REPLACE(gmail, ' ', '') LIKE ? "
                + "ORDER BY username OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Loại bỏ tất cả khoảng trắng trong từ khóa và bọc trong dấu phần trăm để dùng với LIKE
            String filter = "%" + (keyword != null ? keyword.replaceAll("\\s+", "") : "") + "%";
            stm.setString(1, filter);
            stm.setString(2, filter);
            stm.setInt(3, (pageIndex - 1) * pageSize);
            stm.setInt(4, pageSize);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setDisplayname(rs.getString("displayname"));
                    user.setGmail(rs.getString("gmail"));
                    user.setPhone(rs.getString("phone"));
                    // Nếu cần, lấy danh sách role cho user
                    user.setRoles(this.getRoles(user.getUsername()));
                    users.add(user);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
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
        String sqlCheckDoctor = "SELECT isDoctor FROM Staff WHERE staff_username = ?";
        String sqlDeleteDoctorDepartment = "DELETE FROM Doctor_Department WHERE doctor_id IN (SELECT id FROM Doctor WHERE staff_id = (SELECT id FROM Staff WHERE staff_username = ?))";
        String sqlDeleteDoctorSchedule = "DELETE FROM Doctor_Schedule WHERE doctor_id IN (SELECT id FROM Doctor WHERE staff_id = (SELECT id FROM Staff WHERE staff_username = ?))";
        String sqlDeleteDoctor = "DELETE FROM Doctor WHERE staff_id = (SELECT id FROM Staff WHERE staff_username = ?)";
        String sqlDeleteStaff = "DELETE FROM Staff WHERE staff_username = ?";
        String sqlDeleteUserRole = "DELETE FROM UserRole WHERE username = ?";
        String sqlDeleteUser = "DELETE FROM [User] WHERE username = ?";

        try {
            connection.setAutoCommit(false); // Start transaction

            try (PreparedStatement psCheckDoctor = connection.prepareStatement(sqlCheckDoctor); PreparedStatement psDeleteDoctorDepartment = connection.prepareStatement(sqlDeleteDoctorDepartment); PreparedStatement psDeleteDoctorSchedule = connection.prepareStatement(sqlDeleteDoctorSchedule); PreparedStatement psDeleteDoctor = connection.prepareStatement(sqlDeleteDoctor); PreparedStatement psDeleteStaff = connection.prepareStatement(sqlDeleteStaff); PreparedStatement psDeleteUserRole = connection.prepareStatement(sqlDeleteUserRole); PreparedStatement psDeleteUser = connection.prepareStatement(sqlDeleteUser)) {

                // Check if the user is a doctor
                psCheckDoctor.setString(1, username);
                try (ResultSet rs = psCheckDoctor.executeQuery()) {
                    if (rs.next() && rs.getBoolean("isDoctor")) {
                        // Delete related doctor records first due to foreign key constraints
                        psDeleteDoctorDepartment.setString(1, username);
                        psDeleteDoctorDepartment.executeUpdate();

                        psDeleteDoctorSchedule.setString(1, username);
                        psDeleteDoctorSchedule.executeUpdate();

                        psDeleteDoctor.setString(1, username);
                        psDeleteDoctor.executeUpdate();
                    }
                }

                // Delete the staff record
                psDeleteStaff.setString(1, username);
                psDeleteStaff.executeUpdate();

                // Delete from UserRole and User tables
                psDeleteUserRole.setString(1, username);
                psDeleteUserRole.executeUpdate();

                psDeleteUser.setString(1, username);
                psDeleteUser.executeUpdate();

                connection.commit(); // Commit if all deletes were successful
                System.out.println("User '" + username + "' deleted successfully.");
            }

        } catch (SQLException ex) {
            System.err.println("Error deleting user '" + username + "': " + ex.getMessage());
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            if (connection != null) {
                try {
                    connection.rollback(); // Rollback nếu có lỗi
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
                    connection.setAutoCommit(true); // Đặt lại autoCommit
                    connection.close(); // Đóng kết nối (nếu bạn quản lý connection theo cách này)
                } catch (SQLException closeEx) {
                    System.err.println("Error closing connection: " + closeEx.getMessage());
                    Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, closeEx);
                }
            }
        }
    }

    @Override
    public void insert(User model
    ) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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

    try (PreparedStatement stmUser = connection.prepareStatement(sql_insert_user);
         PreparedStatement stmUserRole = connection.prepareStatement(sql_insert_user_role);
         // Dùng RETURN_GENERATED_KEYS để lấy id của Staff
         PreparedStatement stmStaff = connection.prepareStatement(sql_insert_staff, Statement.RETURN_GENERATED_KEYS);
         // Dùng RETURN_GENERATED_KEYS để lấy id của Doctor
         PreparedStatement stmDoctor = connection.prepareStatement(sql_insert_doctor, Statement.RETURN_GENERATED_KEYS);
         PreparedStatement stmDoctorDept = connection.prepareStatement(sql_insert_doctor_department)) {

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
                    generatedStaffId = rs.getInt(1);
                }
            }
        }

        // 5. Nếu là Doctor và có thông tin phòng ban (departments) được set,
        //    duyệt qua danh sách phòng ban và insert vào bảng Doctor_Department
        if (isDoctor && generatedDoctorId != -1 
            && model.getDep()!= null && !model.getDep().isEmpty()) {
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
        String sql = "SELECT username, password, displayname FROM [User] WHERE username = ?";

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

    public int getTotalUserCount(String keyword) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total "
                + "FROM [User] u "
                + "JOIN Staff s ON s.staff_username = u.username "
                + "WHERE REPLACE(REPLACE(u.username, ' ', ''), '+', '') LIKE ? "
                + "OR REPLACE(REPLACE(u.displayname, ' ', ''), '+', '') LIKE ? "
                + "OR REPLACE(REPLACE(s.fullname, ' ', ''), '+', '') LIKE ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Chuẩn hóa từ khóa tìm kiếm
            String filter = "%" + (keyword != null ? keyword.replaceAll("[\\s+]", "") : "") + "%";
            stm.setString(1, filter);
            stm.setString(2, filter);
            stm.setString(3, filter);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return total;
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
