/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Application;
import model.TypeApplication;

/**
 *
 * @author acer
 */
public class ApplicationDBContext extends DBContext<Application> {

    public List<Application> getApplicationsByStaffID(String name, java.sql.Date date, String status, int staffSendId, int page, String sort, int size) {
        List<Application> applications = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT a.id, type_id, a.date_send, a.date_reply, a.staff_send_id, a.reason, a.status, a.reply,a.staff_progress_id, t.name AS typeName "
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
                    app.setStaffProgressId(rs.getInt("staff_progress_id"));
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
            stm.setString(5, "pending");

            int rowsInserted = stm.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public List<TypeApplication> getAllTypes() {
        List<TypeApplication> typeList = new ArrayList<>();
        String sql = "SELECT id, name FROM Type_Application";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                TypeApplication type = new TypeApplication(rs.getInt("id"), rs.getString("name"));
                typeList.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return typeList;
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

        System.out.println(d.getApplicationsCountByStaffID(null, null, null, 24));
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
