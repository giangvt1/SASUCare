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
        try {
            connection.setAutoCommit(false); // Bắt đầu transaction

            // 0. Kiểm tra xem user có là Doctor hay không trong bảng Staff
            boolean isDoctor = false;
            String sqlCheck = "SELECT isDoctor FROM [Staff] WHERE staff_username = ?";
            try (PreparedStatement psCheck = connection.prepareStatement(sqlCheck)) {
                psCheck.setString(1, username);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        isDoctor = rs.getBoolean("isDoctor");
                    }
                }
            }
            System.out.println("isDoctor = " + isDoctor);

            // 1. Nếu user là Doctor, xóa các bản ghi trong bảng Doctor
            int rowsDoctor = 0;
            if (isDoctor) {
                String sql_delete_doctor = "DELETE FROM [Doctor] WHERE staff_id IN (SELECT id FROM [Staff] WHERE staff_username = ?)";
                try (PreparedStatement stmDoctor = connection.prepareStatement(sql_delete_doctor)) {
                    stmDoctor.setString(1, username);
                    rowsDoctor = stmDoctor.executeUpdate();
                }
            }
            System.out.println("Rows deleted from Doctor: " + rowsDoctor);

            // 2. Xóa từ bảng Staff
            int rowsStaff = 0;
            try (PreparedStatement stmStaff = connection.prepareStatement("DELETE FROM [Staff] WHERE staff_username = ?")) {
                stmStaff.setString(1, username);
                rowsStaff = stmStaff.executeUpdate();
            }
            System.out.println("Rows deleted from Staff: " + rowsStaff);

            // 3. Xóa từ bảng UserRole
            int rowsUserRole = 0;
            try (PreparedStatement stmUserRole = connection.prepareStatement("DELETE FROM [UserRole] WHERE username = ?")) {
                stmUserRole.setString(1, username);
                rowsUserRole = stmUserRole.executeUpdate();
            }
            System.out.println("Rows deleted from UserRole: " + rowsUserRole);

            // 4. Xóa từ bảng User
            int rowsUser = 0;
            try (PreparedStatement stmUser = connection.prepareStatement("DELETE FROM [User] WHERE username = ?")) {
                stmUser.setString(1, username);
                rowsUser = stmUser.executeUpdate();
            }
            System.out.println("Rows deleted from User: " + rowsUser);

            connection.commit(); // Commit transaction nếu tất cả thành công
            System.out.println("User '" + username + "' deleted successfully.");

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
    public void insert(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void insert(User model, User createdBy) {
        // SQL cho các bảng
        String sql_insert_user = "INSERT INTO [User](username, password, displayname, gmail, phone) VALUES (?,?,?,?,?)";
        String sql_insert_user_role = "INSERT INTO [UserRole](username, role_id) VALUES (?,?)";
        String sql_insert_staff = "INSERT INTO [Staff](staff_username, createby, createat) VALUES (?,?,?)";
        String sql_insert_doctor = "INSERT INTO [Doctor](staff_id) VALUES (?)";
        String hashedPassword = BCrypt.hashpw(model.getPassword(), BCrypt.gensalt(12));

        try (PreparedStatement stmUser = connection.prepareStatement(sql_insert_user); PreparedStatement stmUserRole = connection.prepareStatement(sql_insert_user_role); // Dùng RETURN_GENERATED_KEYS để lấy id của Staff
                 PreparedStatement stmStaff = connection.prepareStatement(sql_insert_staff, Statement.RETURN_GENERATED_KEYS); PreparedStatement stmDoctor = connection.prepareStatement(sql_insert_doctor)) {

            connection.setAutoCommit(false);
            stmUser.setString(1, model.getUsername());
            stmUser.setString(2, hashedPassword);
            stmUser.setString(3, model.getDisplayname());
            stmUser.setString(4, model.getGmail());
            stmUser.setString(5, model.getPhone());
            stmUser.executeUpdate();
            if (model.getRoles() != null) {
                for (Role role : model.getRoles()) {
                    stmUserRole.setString(1, model.getUsername());
                    stmUserRole.setInt(2, role.getId());
                    stmUserRole.executeUpdate();
                }
            }
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
            boolean isDoctor = false;
            if (model.getRoles() != null) {
                for (Role role : model.getRoles()) {
                    if (role.getId() == 5) {
                        isDoctor = true;
                        break;
                    }
                }
            }

            if (isDoctor && generatedStaffId != -1) {
                stmDoctor.setInt(1, generatedStaffId);
                stmDoctor.executeUpdate();
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
