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

/**
 *
 * @author acer
 */
public class UserDBContext extends DBContext<User> {

    public ArrayList<User> searchAndPaginate(String keyword, int pageIndex, int pageSize) {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT * FROM [User] WHERE username LIKE ? OR gmail LIKE ? "
                + "ORDER BY username OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, "%" + keyword + "%");
            stm.setString(2, "%" + keyword + "%");
            stm.setInt(3, (pageIndex - 1) * pageSize);
            stm.setInt(4, pageSize);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setDisplayname(rs.getString("displayname"));
                user.setGmail(rs.getString("gmail"));
                user.setPhone(rs.getString("phone"));
                user.setRoles(this.getRoles(user.getUsername()));
                users.add(user);
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
            connection.setAutoCommit(false); // Start transaction

            // 1. Delete from Staff
            try (PreparedStatement stmStaff = connection.prepareStatement("DELETE FROM Staff WHERE staff_username = ?")) {
                stmStaff.setString(1, username);
                stmStaff.executeUpdate();
            }

            // 2. Delete from UserRole
            try (PreparedStatement stmUserRole = connection.prepareStatement("DELETE FROM UserRole WHERE username = ?")) {
                stmUserRole.setString(1, username);
                stmUserRole.executeUpdate();
            }

            // 3. Delete from User
            try (PreparedStatement stmUser = connection.prepareStatement("DELETE FROM [User] WHERE username = ?")) {
                stmUser.setString(1, username);
                stmUser.executeUpdate();
            }

            connection.commit(); // Commit transaction if all operations are successful
            System.out.println("User '" + username + "' deleted successfully.");

        } catch (SQLException ex) {
            System.err.println("Error deleting user '" + username + "': " + ex.getMessage());
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            if (connection != null) {
                try {
                    connection.rollback(); // Rollback if any operation fails
                    System.err.println("Transaction rolled back.");
                } catch (SQLException rollbackEx) {
                    System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
                    Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, rollbackEx);
                }
            }
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true); // Set auto-commit back to true
                    connection.close(); // Close the connection in the finally block
                } catch (SQLException closeEx) {
                    System.err.println("Error closing connection: " + closeEx.getMessage());
                    Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, closeEx);
                }
            }
        }
    }

    public ArrayList<User> listPaginated(int pageIndex, int pageSize) {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT * FROM [User] ORDER BY username OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, (pageIndex - 1) * pageSize);
            stm.setInt(2, pageSize);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setDisplayname(rs.getString("displayname"));
                user.setGmail(rs.getString("gmail"));
                user.setPhone(rs.getString("phone"));
                // Lấy danh sách role nếu cần
                user.setRoles(this.getRoles(user.getUsername()));
                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
    }

    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) AS total FROM [User]";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
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
        // Sửa lại SQL cho Doctor: chỉ có 1 tham số (staff_id)
        String sql_insert_doctor = "INSERT INTO [Doctor](staff_id) VALUES (?)";

        // Mã hóa mật khẩu sử dụng BCrypt với cost = 12
        String hashedPassword = BCrypt.hashpw(model.getPassword(), BCrypt.gensalt(12));

        try (PreparedStatement stmUser = connection.prepareStatement(sql_insert_user); PreparedStatement stmUserRole = connection.prepareStatement(sql_insert_user_role); // Dùng RETURN_GENERATED_KEYS để lấy id của Staff
                 PreparedStatement stmStaff = connection.prepareStatement(sql_insert_staff, Statement.RETURN_GENERATED_KEYS); PreparedStatement stmDoctor = connection.prepareStatement(sql_insert_doctor)) {

            connection.setAutoCommit(false);

            // Insert vào bảng User
            stmUser.setString(1, model.getUsername());
            stmUser.setString(2, hashedPassword);
            stmUser.setString(3, model.getDisplayname());
            stmUser.setString(4, model.getGmail());
            stmUser.setString(5, model.getPhone());
            stmUser.executeUpdate();

            // Insert vào bảng UserRole (nếu có role)
            if (model.getRoles() != null) {
                for (Role role : model.getRoles()) {
                    stmUserRole.setString(1, model.getUsername());
                    stmUserRole.setInt(2, role.getId());
                    stmUserRole.executeUpdate();
                }
            }

            // Tạo timestamp hiện tại dùng chung
            Timestamp createAt = new Timestamp(System.currentTimeMillis());

            // Insert vào bảng Staff (staff_username, createby, createat)
            stmStaff.setString(1, model.getUsername());
            stmStaff.setString(2, createdBy.getUsername());
            stmStaff.setTimestamp(3, createAt);
            stmStaff.executeUpdate();

            // Lấy Staff id được sinh tự động
            int generatedStaffId = -1;
            try (ResultSet rs = stmStaff.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedStaffId = rs.getInt(1);
                }
            }

            // Kiểm tra nếu user có role Doctor (role_id = 5)
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
                // Insert vào bảng Doctor chỉ với staff_id
                stmDoctor.setInt(1, generatedStaffId);
                stmDoctor.executeUpdate();
            }

            connection.commit();  // Commit nếu mọi thứ thành công
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException e) {
                Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, "Rollback failed", e);
            }
            throw new RuntimeException("Error inserting user: " + ex.getMessage(), ex);
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
