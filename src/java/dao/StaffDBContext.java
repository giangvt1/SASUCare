package dao;

import dal.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.system.*;

public class StaffDBContext extends DBContext<Staff> {

    public ArrayList<Role> getRoles(String username) {
        ArrayList<Role> roles = new ArrayList<>();
        String sql = """
                SELECT r.id, r.name, f.id, f.name, f.url
                                 FROM Staff s
                                 JOIN StaffRole sr ON sr.staff_id = s.id
                                 JOIN [Role] r ON r.id = sr.role_id
                                 JOIN RoleFeature rf ON rf.role_id = r.id
                                 JOIN Feature f ON f.id = rf.feature_id
                                 WHERE s.username = ?
                                 ORDER BY f.id ASC""";

        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            rs = stm.executeQuery();

            Role currentRole = null; // Initialize current role
            while (rs.next()) {
                int role_id = rs.getInt("r.id");
                if (currentRole == null || role_id != currentRole.getId()) {
                    currentRole = new Role();
                    currentRole.setId(role_id);
                    currentRole.setName(rs.getString("r.name"));
                    currentRole.setFeatures(new ArrayList<>());
                    roles.add(currentRole);
                }
                Feature feature = new Feature();
                feature.setId(rs.getInt("f.id"));
                feature.setName(rs.getString("f.name"));
                feature.setUrl(rs.getString("url"));
                currentRole.getFeatures().add(feature);
            }
        } catch (SQLException e) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stm != null) {
                    stm.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
            }
        }
        return roles; // Return the list of roles
    }

    @Override
    public void insert(Staff model) {
        String sql_insert_staff = """
                INSERT INTO [dbo].[Staff]
                        ([username]
                        ,[password]
                        ,[gender]
                        ,[email]
                        ,[phone_number]
                        ,[fullname]
                        ,[dob]
                        ,[address])
                VALUES
                        (?
                        ,?
                        ,?
                        ,?
                        ,?
                        ,?
                        ,?
                        ,?)""";

        String sql_insert_staff_role = """
                INSERT INTO [dbo].[StaffRole]
                        ([staff_id]
                        ,[role_id])
                VALUES
                        (?
                        ,?)""";

        try (PreparedStatement stmStaff = connection.prepareStatement(sql_insert_staff,
                Statement.RETURN_GENERATED_KEYS); PreparedStatement stmRole = connection.prepareStatement(sql_insert_staff_role)) {

            connection.setAutoCommit(false);

            // Insert into Staff
            stmStaff.setString(1, model.getUsername());
            stmStaff.setString(2, model.getPassword());
            stmStaff.setBoolean(3, model.isGender());
            stmStaff.setString(4, model.getEmail());
            stmStaff.setString(5, model.getPhonenumber());
            stmStaff.setNString(6, model.getFullname());
            stmStaff.setDate(7, model.getDob());
            stmStaff.setString(8, model.getAddress());
            stmStaff.executeUpdate();

            // Get generated staff_id
            ResultSet generatedKeys = stmStaff.getGeneratedKeys();
            if (generatedKeys.next()) {
                int staffId = generatedKeys.getInt(1);

                // Insert into StaffRole
                for (Role role : model.getRole()) {
                    stmRole.setInt(1, staffId);
                    stmRole.setInt(2, role.getId());
                    stmRole.executeUpdate();
                }
            }

            connection.commit();
        } catch (SQLException ex) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException e) {
                Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    public void update(Staff model) {
        String sql = """
                UPDATE [dbo].[Staff]
                SET [gender] = ?
                   ,[email] = ?
                   ,[phone_number] = ?
                   ,[fullname] = ?
                   ,[dob] = ?
                   ,[address] = ?
                WHERE [id] = ?""";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setBoolean(1, model.isGender());
            stm.setString(2, model.getEmail());
            stm.setString(3, model.getPhonenumber());
            stm.setNString(4, model.getFullname());
            stm.setDate(5, model.getDob());
            stm.setString(6, model.getAddress());
            stm.setInt(7, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void delete(Staff model) {
        String sql = "DELETE FROM [dbo].[Staff] WHERE [id] = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public ArrayList<Staff> list() {
        ArrayList<Staff> staffList = new ArrayList<>();
        String sql = """
                SELECT [id]
                      ,[username]
                      ,[password]
                      ,[gender]
                      ,[email]
                      ,[phone_number]
                      ,[fullname]
                      ,[dob]
                      ,[address]
                FROM [dbo].[Staff]""";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Staff staff = new Staff();
                staff.setId(rs.getInt("id"));
                staff.setUsername(rs.getString("username"));
                staff.setPassword(rs.getString("password"));
                staff.setGender(rs.getBoolean("gender"));
                staff.setEmail(rs.getString("email"));
                staff.setPhonenumber(rs.getString("phone_number"));
                staff.setFullname(rs.getNString("fullname"));
                staff.setDob(rs.getDate("dob"));
                staff.setAddress(rs.getString("address"));
                staffList.add(staff);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return staffList;
    }

    public Staff get(String username, String password) {
        String sql = """
                SELECT [id]
                      ,[username]
                      ,[password]
                      ,[gender]
                      ,[email]
                      ,[phone_number]
                      ,[fullname]
                      ,[dob]
                      ,[address]
                  FROM [test1].[dbo].[Staff]
                  where [username]=? and [password]=?
                """;
        PreparedStatement stm = null;
        Staff staff = null;
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                staff = new Staff();
                staff.setId(rs.getInt("id"));
                staff.setUsername(username);
                staff.setEmail(rs.getString("email"));
                staff.setFullname(rs.getNString("fullname"));
                staff.setAddress(rs.getString("address"));
                staff.setDob(rs.getDate("dob"));
                staff.setPhonenumber(rs.getString("phone_number"));
                staff.setGender(rs.getBoolean("gender"));
            }
        } catch (SQLException e) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            try {
                if (stm != null) {
                    stm.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
            }
        }
        return staff;
    }

    @Override
    public Staff get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
        // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Staff getById(int id) {
        String sql = """
                SELECT [id]
                      ,[username]
                      ,[password]
                      ,[gender]
                      ,[email]
                      ,[phone_number]
                      ,[fullname]
                      ,[dob]
                      ,[address]
                  FROM [test1].[dbo].[Staff]
                  where [id]=?
                """;
        PreparedStatement stm = null;
        Staff staff = null;
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                staff = new Staff();
                staff.setId(rs.getInt("id"));
                staff.setUsername(rs.getString("username"));
                staff.setEmail(rs.getString("email"));
                staff.setFullname(rs.getNString("fullname"));
                staff.setAddress(rs.getString("address"));
                staff.setDob(rs.getDate("dob"));
                staff.setPhonenumber(rs.getString("phone_number"));
                staff.setGender(rs.getBoolean("gender"));
            }
        } catch (SQLException e) {
            Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            try {
                if (stm != null) {
                    stm.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                Logger.getLogger(StaffDBContext.class.getName()).log(Level.SEVERE, null, e);
            }

        }
        return staff;
    }

    public static void main(String[] args) {
        StaffDBContext d = new StaffDBContext();
        Staff s = d.getById(1);
        System.out.println(s.getFullname());
    }
}
