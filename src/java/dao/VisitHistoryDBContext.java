package dao;

import dal.DBContext;
import model.VisitHistory;
import model.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VisitHistoryDBContext extends DBContext<VisitHistory> {

    private static final Logger LOGGER = Logger.getLogger(VisitHistoryDBContext.class.getName());

    // Get visit histories by customer ID, doctor ID, date range, and sort direction
    public List<VisitHistory> getVisitHistoriesByCustomerId(int customerId, String doctorId, String startDate, String endDate, String sortDirection) {
        List<VisitHistory> visitHistories = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM VisitHistory vh");
        sql.append(" JOIN Doctor d ON vh.doctorId = d.id");
        sql.append(" WHERE vh.customerId = ?");

        // Apply filtering based on doctor and date range
        if (doctorId != null && !doctorId.equals("all") && !doctorId.isEmpty()) {
            sql.append(" AND vh.doctorId = ?");
        }

        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND vh.visitDate >= ?");
        }

        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND vh.visitDate <= ?");
        }

        // Sorting by visit date
        sql.append(" ORDER BY vh.visitDate ");
        if ("asc".equalsIgnoreCase(sortDirection)) {
            sql.append("ASC");
        } else {
            sql.append("DESC");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, customerId);

            // Apply filters for doctor and date range
            if (doctorId != null && !doctorId.equals("all") && !doctorId.isEmpty()) {
                ps.setString(paramIndex++, doctorId);
            }

            if (startDate != null && !startDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(startDate)); // Convert string to Date
            }

            if (endDate != null && !endDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(endDate)); // Convert string to Date
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                VisitHistory visitHistory = new VisitHistory();
                visitHistory.setId(rs.getInt("id"));
                visitHistory.setDoctorId(rs.getInt("doctorId"));
                visitHistory.setCustomerId(rs.getInt("customerId"));
                visitHistory.setVisitDate(rs.getTimestamp("visitDate"));
                visitHistory.setReasonForVisit(rs.getString("reasonForVisit"));
                visitHistory.setDiagnoses(rs.getString("diagnoses"));
                visitHistory.setTreatmentPlan(rs.getString("treatmentPlan"));
                visitHistory.setNextAppointment(rs.getTimestamp("nextAppointment"));

                // Assuming Appointment details are included or need to be fetched separately
                Appointment appointment = new Appointment(); // You may need to fetch appointment details
                visitHistory.setAppointment(appointment);

                visitHistories.add(visitHistory);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving visit histories", ex);
        }
        return visitHistories;
    }

    // Get total count of visit histories for pagination
    public int getVisitHistoryCountByCustomerId(int customerId, String doctorId, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM VisitHistory vh WHERE vh.customerId = ?");
        if (doctorId != null && !doctorId.equals("all") && !doctorId.isEmpty()) {
            sql.append(" AND vh.doctorId = ?");
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND vh.visitDate >= ?");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND vh.visitDate <= ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, customerId);

            if (doctorId != null && !doctorId.equals("all") && !doctorId.isEmpty()) {
                ps.setString(paramIndex++, doctorId);
            }

            if (startDate != null && !startDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(startDate));
            }

            if (endDate != null && !endDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(endDate));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1); // Return total count
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving visit history count", ex);
        }
        return 0;
    }

    // Get a specific visit history by its ID
    public VisitHistory getVisitHistoryById(int id) {
        VisitHistory visitHistory = null;
        String sql = "SELECT * FROM VisitHistory WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                visitHistory = new VisitHistory();
                visitHistory.setId(rs.getInt("id"));
                visitHistory.setDoctorId(rs.getInt("doctorId"));
                visitHistory.setCustomerId(rs.getInt("customerId"));
                visitHistory.setVisitDate(rs.getTimestamp("visitDate"));
                visitHistory.setReasonForVisit(rs.getString("reasonForVisit"));
                visitHistory.setDiagnoses(rs.getString("diagnoses"));
                visitHistory.setTreatmentPlan(rs.getString("treatmentPlan"));
                visitHistory.setNextAppointment(rs.getTimestamp("nextAppointment"));
                // Appointment data should also be fetched if necessary
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving visit history by ID", ex);
        }
        return visitHistory;
    }

    @Override
    public void insert(VisitHistory model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(VisitHistory model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(VisitHistory model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<VisitHistory> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public VisitHistory get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
