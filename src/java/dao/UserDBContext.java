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
import java.util.logging.Level;
import java.util.logging.Logger;
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
        String sql_insert_user = "INSERT INTO [User](username, password, displayname, gmail, phone) VALUES (?,?,?,?,?)";
        String sql_insert_user_role = "INSERT INTO [UserRole](username, role_id) VALUES (?,?)";
        String sql_insert_staff = "INSERT INTO [Staff](staff_username, createby, createat) VALUES (?,?,?)";

        // Mã hóa mật khẩu
        String hashedPassword = hashPassword(model.getPassword());

        try (PreparedStatement stmUser = connection.prepareStatement(sql_insert_user); PreparedStatement stmUserRole = connection.prepareStatement(sql_insert_user_role); PreparedStatement stmStaff = connection.prepareStatement(sql_insert_staff)) {

            connection.setAutoCommit(false);

            // Insert vào bảng User
            stmUser.setString(1, model.getUsername());
            stmUser.setString(2, hashedPassword);
            stmUser.setString(3, model.getDisplayname());
            stmUser.setString(4, model.getGmail());
            stmUser.setString(5, model.getPhone());
            stmUser.executeUpdate();

            // Insert vào bảng UserRole
            for (Role role : model.getRoles()) {
                stmUserRole.setString(1, model.getUsername());
                stmUserRole.setInt(2, role.getId());
                stmUserRole.executeUpdate();
            }

            // Insert vào bảng Staff với staff_username là username vừa tạo
            Timestamp createAt = new Timestamp(System.currentTimeMillis());
            stmStaff.setString(1, model.getUsername());
            stmStaff.setString(2, createdBy.getUsername()); // Sử dụng đối tượng logged được truyền vào
            stmStaff.setTimestamp(3, createAt);
            stmStaff.executeUpdate();

            connection.commit();
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException e) {
                Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, e);
            }
            throw new RuntimeException(ex);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
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
        SELECT r.id, r.name 
        FROM UserRole ur 
        JOIN Role r ON ur.role_id = r.id 
        WHERE ur.username = ?
    """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                roles.add(role);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, "Lỗi khi lấy danh sách roles!", ex);
        }

        return roles;
    }
}
