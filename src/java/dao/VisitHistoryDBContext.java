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

    // Phương thức lấy danh sách lịch sử khám bệnh theo CustomerID, có phân trang
    public ArrayList<VisitHistory> getVisitHistoriesByCustomerIdPaginated(int customerId, int page, int size) {
        ArrayList<VisitHistory> visitHistories = new ArrayList<>();
        // Chỉ lấy các cột cần thiết
        String sql = "SELECT id, DoctorID, CustomerID, VisitDate, ReasonForVisit, Diagnoses, TreatmentPlan, Note "
                + "FROM VisitHistory "
                + "WHERE CustomerID = ? "
                + "ORDER BY VisitDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        int offset = (page - 1) * size;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, offset);
            ps.setInt(3, size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Gán từng giá trị từ resultset vào biến tương ứng
                    int id = rs.getInt("id");
                    int doctorId = rs.getInt("DoctorID");
                    int custId = rs.getInt("CustomerID");
                    java.sql.Timestamp visitDate = rs.getTimestamp("VisitDate");
                    String reasonForVisit = rs.getString("ReasonForVisit");
                    String diagnoses = rs.getString("Diagnoses");
                    String treatmentPlan = rs.getString("TreatmentPlan");
                    String note = rs.getString("Note");

                    // Tạo đối tượng VisitHistory và gán giá trị vào từng thuộc tính
                    VisitHistory vh = new VisitHistory();
                    vh.setId(id);
                    vh.setDoctorId(doctorId);
                    vh.setCustomerId(custId);
                    vh.setVisitDate(visitDate);
                    vh.setReasonForVisit(reasonForVisit);
                    vh.setDiagnoses(diagnoses);
                    vh.setTreatmentPlan(treatmentPlan);
                    vh.setNote(note);

                    visitHistories.add(vh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return visitHistories;
    }

    public int getVisitHistoryCountByCustomerId(int customerId) {
        String sql = "SELECT COUNT(*) FROM VisitHistory WHERE CustomerID = ?";
        int count = 0;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId); // Gán CustomerID

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1); // Lấy số lượng bản ghi
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public boolean createVisitHistory(VisitHistory visitHistory) {
        String sql = "INSERT INTO VisitHistory (DoctorID, CustomerID, VisitDate, ReasonForVisit, Diagnoses, TreatmentPlan, Note, AppointmentID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, visitHistory.getDoctorId());
            ps.setInt(2, visitHistory.getCustomerId());
            ps.setTimestamp(3, visitHistory.getVisitDate() != null
                    ? visitHistory.getVisitDate()
                    : new java.sql.Timestamp(System.currentTimeMillis()));
            ps.setString(4, visitHistory.getReasonForVisit());
            ps.setString(5, visitHistory.getDiagnoses());
            ps.setString(6, visitHistory.getTreatmentPlan());
            ps.setString(7, visitHistory.getNote());
            ps.setInt(8, visitHistory.getAppointmentId());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

        public boolean updateVisitHistory(VisitHistory visitHistory) {
        String sql = "UPDATE VisitHistory "
                + "SET DoctorID = ?, CustomerID = ?, VisitDate = ?, ReasonForVisit = ?, Diagnoses = ?, TreatmentPlan = ?, Note = ?, AppointmentID "
                + "WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, visitHistory.getDoctorId());
            ps.setInt(2, visitHistory.getCustomerId());
            ps.setDate(3, new java.sql.Date(visitHistory.getVisitDate().getTime()));
            ps.setString(4, visitHistory.getReasonForVisit());
            ps.setString(5, visitHistory.getDiagnoses());
            ps.setString(6, visitHistory.getTreatmentPlan());
            ps.setString(7, visitHistory.getNote());
            ps.setInt(8, visitHistory.getAppointmentId());
            ps.setInt(9, visitHistory.getId());

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
        public boolean deleteVisitHistory(int visitHistoryId) {
        String sql = "DELETE FROM VisitHistory WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, visitHistoryId);

            int rowsDeleted = ps.executeUpdate();
            return rowsDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get visit histories by customer ID, doctor ID, date range, and sort direction
    public List<VisitHistory> getVisitHistoriesByCustomerId(int customerId, String doctorId, String startDate, String endDate, String sortDirection) {
        List<VisitHistory> visitHistories = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT vh.id,\n"
                + "       vh.DoctorID,\n"
                + "       vh.CustomerID,\n"
                + "       vh.VisitDate,\n"
                + "       vh.ReasonForVisit,\n"
                + "       vh.Diagnoses,\n"
                + "       vh.TreatmentPlan,\n"
                + "       ds.schedule_date AS NextAppointment,\n"
                + "       a.id AS appointment_id,\n"
                + "	   a.[status],\n"
                + "	   s.[time_start]\n"
                + "FROM VisitHistory vh\n"
                + "LEFT JOIN Appointment a ON a.id = vh.NextAppointmentID\n"
                + "LEFT JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id\n"
                + "join Shift s on s.id = ds.shift_id");

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
                visitHistory.setNote(rs.getString("note"));

                // Assuming Appointment details are included or need to be fetched separately
                Appointment appointment = new Appointment(); // You may need to fetch appointment details
                appointment.setId(rs.getInt("appointment_id"));
                appointment.setStatus(rs.getString("status"));
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
        String sql = "SELECT  vh.[id]\r\n"
                + //
                "      ,[DoctorID]\r\n"
                + //
                "      ,[CustomerID]\r\n"
                + //
                "      ,[VisitDate]\r\n"
                + //
                "      ,[ReasonForVisit]\r\n"
                + //
                "      ,[Diagnoses]\r\n"
                + //
                "      ,[TreatmentPlan]\r\n"
                + //
                "      ,ds.schedule_date as NextAppointment\r\n"
                + //
                "  FROM [VisitHistory] vh left join Appointment a on a.id = vh.NextAppointmentID\r\n"
                + //
                "   join Doctor_Schedule ds on a.DocSchedule_id = ds.id\r\n"
                + //
                " WHERE vh.id = ?";
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
                visitHistory.setNote(rs.getString("note"));
                // Appointment data should also be fetched if necessary
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));
                visitHistory.setAppointment(appointment);
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
