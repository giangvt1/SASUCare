package dao;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Application;
import model.TypeApplication;

/**
 *
 * @author acer
 */
public class ApplicationDBContext extends DBContext<Application> {

    private static final Logger LOGGER = Logger.getLogger(ApplicationDBContext.class.getName());

    public List<TypeApplication> getAllTypes(String typeName, int page, int sizeOfEachTable) {
        List<TypeApplication> typeList = new ArrayList<>();
        int offset = (page - 1) * sizeOfEachTable;

        // Xây dựng SQL động
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT t.id, t.name, t.staff_manage_id, s.fullname AS staffManagerName "
                + "FROM Type_Application t "
                + "JOIN Staff s ON t.staff_manage_id = s.id "
        );

        if (typeName != null && !typeName.isEmpty()) {
            sqlBuilder.append(" WHERE t.name LIKE ?");
        }

        sqlBuilder.append(" ORDER BY t.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;

            if (typeName != null && !typeName.isEmpty()) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }

            stm.setInt(paramIndex++, offset);  // OFFSET đi trước
            stm.setInt(paramIndex++, sizeOfEachTable);  // FETCH NEXT đi sau

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    TypeApplication type = new TypeApplication();
                    type.setId(rs.getInt("id"));
                    type.setName(rs.getString("name"));
                    type.setStaffManageId(rs.getInt("staff_manage_id"));
                    type.setStaffManageName(rs.getString("staffManagerName"));
                    typeList.add(type);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return typeList;
    }

    public int getTotalTypes(String typeName) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Type_Application "
                + (typeName != null ? "WHERE name LIKE ?" : "");
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            if (typeName != null) {
                stm.setString(1, "%" + typeName + "%");
            }
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Application> getStaffApplicationsByStaffID(String typeName, String staffName,
            java.sql.Date dateFrom, java.sql.Date dateTo, String status, int staffManageId,
            int page, String sort, int size) {
        List<Application> applications = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT a.id, type_id, a.date_send, a.date_reply, a.staff_send_id,a.staff_handle_id, a.reason, a.status, a.reply, "
                + "t.staff_manage_id AS staffManage, t.name AS typeName, s.fullname AS staffName "
                + "FROM Application a "
                + "JOIN Type_Application t ON a.type_id = t.id "
                + "JOIN Staff s ON a.staff_send_id = s.id "
                + "WHERE staff_manage_id = ?"
        );

        // Add filters
        if (typeName != null && !typeName.isEmpty()) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (staffName != null && !staffName.isEmpty()) {
            sqlBuilder.append(" AND s.fullname LIKE ?");
        }
        if (dateFrom != null) {
            sqlBuilder.append(" AND CONVERT(DATE, a.date_send) >= ?");
        }
        if (dateTo != null) {
            sqlBuilder.append(" AND CONVERT(DATE, a.date_send) <= ?");
        }
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND a.status LIKE ?");
        }

        // Add sorting
        switch (sort) {
            case "dateLTH" ->
                sqlBuilder.append(" ORDER BY a.date_send ASC");
            case "dateHTL" ->
                sqlBuilder.append(" ORDER BY a.date_send DESC");
            default ->
                sqlBuilder.append(" ORDER BY a.id");
        }

        // Add pagination
        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, staffManageId);

            // Set parameters for filters
            if (typeName != null && !typeName.isEmpty()) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }
            if (staffName != null && !staffName.isEmpty()) {
                stm.setString(paramIndex++, "%" + staffName + "%");
            }
            if (dateFrom != null) {
                stm.setDate(paramIndex++, dateFrom);
            }
            if (dateTo != null) {
                stm.setDate(paramIndex++, dateTo);
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

            // Set pagination parameters
            int offset = (page - 1) * size;
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, size);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setId(rs.getInt("id"));
                    app.setTypeName(rs.getString("typeName"));
                    app.setDateSend(rs.getTimestamp("date_send"));
                    app.setDateReply(rs.getTimestamp("date_reply"));
                    app.setStaffSendId(rs.getInt("staff_send_id"));
                    app.setReason(rs.getString("reason"));
                    app.setStatus(rs.getString("status"));
                    app.setReply(rs.getString("reply"));
                    app.setStaffHandleId(rs.getInt("staff_handle_id"));
                    app.setStaffName(rs.getString("staffName"));
                    applications.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }

    public int getStaffApplicationsCountByStaffID(String typeName, String staffName,
            java.sql.Date dateFrom, java.sql.Date dateTo, String status, int staffManageId) {
        int count = 0;
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT COUNT(*) AS total "
                + "FROM Application a "
                + "JOIN Type_Application t ON a.type_id = t.id "
                + "JOIN Staff s ON a.staff_send_id = s.id "
                + "WHERE t.staff_manage_id = ?"
        );

        if (typeName != null && !typeName.isEmpty()) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (staffName != null && !staffName.isEmpty()) {
            sqlBuilder.append(" AND s.fullname LIKE ?");
        }
        if (dateFrom != null) {
            sqlBuilder.append(" AND CONVERT(DATE, a.date_send) >= ?");
        }
        if (dateTo != null) {
            sqlBuilder.append(" AND CONVERT(DATE, a.date_send) <= ?");
        }
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND a.status LIKE ?");
        }

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, staffManageId);

            // Set parameters for filters
            if (typeName != null && !typeName.isEmpty()) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }
            if (staffName != null && !staffName.isEmpty()) {
                stm.setString(paramIndex++, "%" + staffName + "%");
            }
            if (dateFrom != null) {
                stm.setDate(paramIndex++, dateFrom);
            }
            if (dateTo != null) {
                stm.setDate(paramIndex++, dateTo);
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public Application getApplicationById(int id) {
        Application application = null;
        String sql = "SELECT a.id, type_id, a.date_send, a.date_reply, a.staff_send_id,a.staff_handle_id, a.reason, a.status, a.reply, "
                + "t.staff_manage_id AS staffManage, t.name AS typeName, s.fullname AS staffName "
                + "FROM Application a "
                + "JOIN Type_Application t ON a.type_id = t.id "
                + "JOIN Staff s ON a.staff_send_id = s.id "
                + "WHERE a.id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                application = new Application();
                application.setId(rs.getInt("id"));
                application.setTypeName(rs.getString("typeName"));
                application.setDateSend(rs.getTimestamp("date_send"));
                application.setDateReply(rs.getTimestamp("date_reply"));
                application.setStaffSendId(rs.getInt("staff_send_id"));
                application.setReason(rs.getString("reason"));
                application.setStatus(rs.getString("status"));
                application.setReply(rs.getString("reply"));
                application.setStaffHandleId(rs.getInt("staff_handle_id"));
                application.setStaffName(rs.getString("staffName"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching data: {0}", ex.getMessage());
        }
        return application;
    }

    public List<Application> getApplicationsByStaffID(String name, java.sql.Date date, String status, int staffSendId, int page, String sort, int size) {
        List<Application> applications = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT a.id, type_id, a.date_send, a.date_reply, a.staff_send_id, a.reason, a.status, a.reply,a.staff_handle_id, t.name AS typeName "
                + "FROM Application a "
                + "JOIN Type_Application t ON a.type_id = t.id "
                + "WHERE a.staff_send_id = ?"
        );

        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (date != null) {
            sqlBuilder.append(" AND CONVERT(DATE, a.date_send) = ?");
        }
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND a.status LIKE ?");
        }

        switch (sort) {
            case "dateLTH" ->
                sqlBuilder.append(" ORDER BY a.date_send ASC");
            case "dateHTL" ->
                sqlBuilder.append(" ORDER BY a.date_send DESC");
            default ->
                sqlBuilder.append(" ORDER BY a.id");
        }

        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, staffSendId);

            if (name != null && !name.isEmpty()) {
                stm.setString(paramIndex++, "%" + name + "%");
            }
            if (date != null) {
                stm.setDate(paramIndex++, date);
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

            int offset = (page - 1) * size;
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, size);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setId(rs.getInt("id"));
                    app.setTypeName(rs.getString("typeName"));
                    app.setDateSend(rs.getTimestamp("date_send"));
                    app.setDateReply(rs.getTimestamp("date_reply"));
                    app.setStaffSendId(rs.getInt("staff_send_id"));
                    app.setReason(rs.getString("reason"));
                    app.setStatus(rs.getString("status"));
                    app.setReply(rs.getString("reply"));
                    app.setStaffHandleId(rs.getInt("staff_handle_id"));
                    applications.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }

    public int getApplicationsCountByStaffID(String name, java.sql.Date date, String status, int staffSendId) {
        int count = 0;
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT COUNT(*) AS total FROM Application a "
                + "JOIN Type_Application t ON a.type_id = t.id "
                + "WHERE a.staff_send_id = ?"
        );

        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (date != null) {
            sqlBuilder.append(" AND CONVERT(DATE, a.date_send) = ?");
        }
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND a.status LIKE ?");
        }

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, staffSendId);

            if (name != null && !name.isEmpty()) {
                stm.setString(paramIndex++, "%" + name + "%");
            }
            if (date != null) {
                stm.setDate(paramIndex++, date);
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean createApplicationForStaff(Application application) {
        String sql = "INSERT INTO Application (staff_send_id, type_id, reason, date_send, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, application.getStaffSendId());
            stm.setInt(2, application.getTypeId());
            stm.setString(3, application.getReason());
            stm.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            stm.setString(5, "Pending");

            int rowsInserted = stm.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateApplicationForStaff(Application application) {
        String sql = "UPDATE Application SET date_reply = ?, status = ?, reply = ?, staff_handle_id = ? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stm.setString(2, application.getStatus());
            stm.setString(3, application.getReply());
            stm.setInt(4, application.getStaffHandleId());
            stm.setInt(5, application.getId());

            int rowsUpdated = stm.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public List<TypeApplication> getAllTypes() {
        List<TypeApplication> typeList = new ArrayList<>();
        String sql = "SELECT t.id, t.name, t.staff_manage_id, s.fullname AS staffManagerName "
                + "FROM Type_Application t "
                + "JOIN Staff s ON t.staff_manage_id = s.id";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                TypeApplication type = new TypeApplication();
                type.setId(rs.getInt("id"));
                type.setName(rs.getString("name"));
                type.setStaffManageId(rs.getInt("staff_manage_id"));
                type.setStaffManageName(rs.getString("staffManagerName"));
                typeList.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return typeList;
    }

    public boolean createTypeApplication(TypeApplication typeApp) {
        String sql = "INSERT INTO Type_Application (name, staff_manage_id) VALUES (?, ?)";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, typeApp.getName());
            stm.setInt(2, typeApp.getStaffManageId());

            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;  // trả về true nếu insert thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTypeApplication(TypeApplication typeApp) {
        String sql = "UPDATE Type_Application SET name = ?, staff_manage_id = ? WHERE id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, typeApp.getName());
            stm.setInt(2, typeApp.getStaffManageId());
            stm.setInt(3, typeApp.getId());

            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;  // trả về true nếu update thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getStaffManagerIdByTypeApplicationId(int typeApplicationId) {
        Integer staffManageId = null;
        String sql = "SELECT staff_manage_id FROM Type_Application WHERE id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, typeApplicationId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                staffManageId = rs.getInt("staff_manage_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffManageId;
    }

    public static void main(String[] args) {
        ApplicationDBContext d = new ApplicationDBContext();
        Application a = new Application();
    }

    @Override
    public void insert(Application model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Application model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Application model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Application> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Application get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
