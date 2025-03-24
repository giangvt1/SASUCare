package dao;

import dal.DBContext;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;
import model.system.Staff;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Appointment;
import model.Customer;
import model.DoctorSalaryStat;

public class DoctorScheduleDBContext extends DBContext<DoctorSchedule> {

    private static final Logger LOGGER = Logger.getLogger(DoctorScheduleDBContext.class.getName());
    public String checkExsistSchedule(int customerId, String scheduleDate, String doctorId, String shiftId) {
        String sql = "SELECT COUNT(*) FROM Appointment a "
                + "JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id "
                + "WHERE a.customer_id = ? AND ds.schedule_date = ? "
                + "AND (a.doctor_id = ? OR ds.shift_id = ?) ";
    
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
    
            // Validate numeric fields
            int docId = Integer.parseInt(doctorId);
            int shId = Integer.parseInt(shiftId);
    
            // Convert scheduleDate (must be in YYYY-MM-DD format)
            Date sqlDate = Date.valueOf(scheduleDate);
    
            ps.setInt(1, customerId);
            ps.setDate(2, sqlDate);
            ps.setInt(3, docId);
            ps.setInt(4, shId);
    
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return "exists";
                } else {
                    return "available";
                }
            }
    
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return "error: invalid input (must be numbers)";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    public List<DoctorSchedule> getSchedulesByDoctorBetweenDates(int doctorId, Date start, Date end) {
        List<DoctorSchedule> list = new ArrayList<>();
        String sql = """
        SELECT ds.id AS dsid,
               ds.schedule_date,
               ds.doctor_id,
               ds.shift_id,
               ds.available,
               s.time_start,
               s.time_end,
               a.id AS appointmentId,
               a.status AS appointmentStatus,
               c.fullname AS customerName
        FROM Doctor_Schedule ds
        JOIN Shift s ON ds.shift_id = s.id
        LEFT JOIN Appointment a ON ds.id = a.DocSchedule_id
        LEFT JOIN Customer c ON a.customer_id = c.id
        WHERE ds.doctor_id = ? AND ds.schedule_date BETWEEN ? AND ?
        ORDER BY ds.schedule_date, s.time_start
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setDate(2, start);
            ps.setDate(3, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DoctorSchedule dsObj = new DoctorSchedule();
                    dsObj.setId(rs.getInt("dsid"));
                    dsObj.setScheduleDate(rs.getDate("schedule_date"));
                    dsObj.setAvailable(rs.getInt("available") == 1);
                    // Set Shift
                    Shift shift = new Shift();
                    shift.setId(rs.getInt("shift_id"));
                    shift.setTimeStart(rs.getTime("time_start"));
                    shift.setTimeEnd(rs.getTime("time_end"));
                    dsObj.setShift(shift);
                    // Set Appointment nếu có
                    int appointmentId = rs.getInt("appointmentId");
                    if (!rs.wasNull()) {
                        Appointment app = new Appointment();
                        app.setId(appointmentId);
                        app.setStatus(rs.getString("appointmentStatus"));
                        Customer customer = new Customer();
                        customer.setFullname(rs.getString("customerName"));
                        app.setCustomer(customer);
                        dsObj.setAppointment(app);
                    }
                    list.add(dsObj);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DoctorSchedule> getAvailableShiftsForDate(int doctorId, Date selectedDate) {
        List<DoctorSchedule> shifts = new ArrayList<>();
        String sql = "SELECT * FROM Doctor_Schedule WHERE doctor_id = ? AND schedule_date = ? AND available = 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setDate(2, selectedDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setId(rs.getInt("id"));
                schedule.setScheduleDate(rs.getDate("schedule_date"));
                // Add other fields as needed
                shifts.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shifts;
    }

    // Get available future dates for a doctor
    public List<Date> getAvailableDates(int doctorId) {
        List<Date> availableDates = new ArrayList<>();
        String sql = """
            SELECT DISTINCT schedule_date 
            FROM Doctor_Schedule 
            WHERE doctor_id = ? AND available = 1 AND schedule_date >= GETDATE()
            ORDER BY schedule_date ASC
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, doctorId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                availableDates.add(rs.getDate("schedule_date"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching available dates: {0}", ex.getMessage());
        }
        return availableDates;
    }

    // Get available time slots for a doctor on a specific date
    public DoctorSchedule getScheduleByDateAndShift(int doctorId, Date date, int shiftId) {
        DoctorSchedule schedule = null;
        String sql = """
        SELECT ds.id, ds.schedule_date, ds.shift_id, s.time_start, s.time_end, ds.available
        FROM Doctor_Schedule ds
        JOIN Shift s ON ds.shift_id = s.id
        WHERE ds.doctor_id = ? AND ds.schedule_date = ? AND ds.shift_id = ? AND ds.available = 1
    """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, doctorId);
            stm.setDate(2, date);
            stm.setInt(3, shiftId);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) { // Fetch only one record
                Shift shift = new Shift(rs.getInt("shift_id"), rs.getTime("time_start"), rs.getTime("time_end"));
                schedule = new DoctorSchedule(
                        rs.getInt("id"),
                        null, // Doctor object can be set later if needed
                        rs.getDate("schedule_date"),
                        shift,
                        rs.getInt("available") == 1
                );
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor schedule by date & shift: {0}", ex.getMessage());
        }
        return schedule;
    }

    @Override
    public void insert(DoctorSchedule schedule) {
        String sql = "INSERT INTO Doctor_Schedule (doctor_id, schedule_date, shift_id, available) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, schedule.getDoctor().getId());
            stm.setDate(2, schedule.getScheduleDate());
            stm.setInt(3, schedule.getShift().getId());
            stm.setInt(4, schedule.isAvailable() ? 1 : 0); // Chuyển boolean thành int

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    schedule.setId(generatedKeys.getInt(1));
                    LOGGER.info("Doctor schedule added successfully with ID: " + schedule.getId());
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting doctor schedule: {0}", ex.getMessage());
        }
    }

    @Override
    public DoctorSchedule get(String id) {
        DoctorSchedule schedule = null;
        DoctorDBContext docDb = new DoctorDBContext();
        String sql = """
            SELECT ds.id, ds.doctor_id, ds.schedule_date, ds.shift_id, s.time_start, s.time_end, ds.available
            FROM Doctor_Schedule ds
            JOIN Shift s ON ds.shift_id = s.id
            WHERE ds.id = ?
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, Integer.parseInt(id));
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Doctor doctor = docDb.getDoctorById(rs.getInt("doctor_id"));
                Shift shift = new Shift(rs.getInt("shift_id"), rs.getTime("time_start"), rs.getTime("time_end"));

                schedule = new DoctorSchedule(
                        rs.getInt("id"),
                        doctor,
                        rs.getDate("schedule_date"),
                        shift,
                        rs.getInt("available") == 1
                );
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor schedule: {0}", ex.getMessage());
        }
        return schedule;
    }

    @Override
    public void update(DoctorSchedule schedule) {
        String sql = "UPDATE Doctor_Schedule SET available = ? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, schedule.isAvailable() ? 1 : 0);
            stm.setInt(2, schedule.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating doctor schedule: {0}", ex.getMessage());
        }
    }

    @Override
    public void delete(DoctorSchedule schedule) {
        String sql = "DELETE FROM Doctor_Schedule WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, schedule.getId());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                LOGGER.info("Doctor schedule deleted successfully.");
            } else {
                LOGGER.warning("No doctor schedule found with the given ID.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting doctor schedule: {0}", ex.getMessage());
        }
    }

    public List<DoctorSchedule> getSchedulesByDoctor(int doctorId, Date date) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        DoctorDBContext docDB = new DoctorDBContext();
        String sql = """
            SELECT ds.id, ds.schedule_date, ds.shift_id, s.time_start, s.time_end, ds.available
            FROM Doctor_Schedule ds
            JOIN Shift s ON ds.shift_id = s.id
            WHERE ds.doctor_id = ? AND ds.schedule_date = ?
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, doctorId);
            stm.setDate(2, date);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Shift shift = new Shift(rs.getInt("shift_id"), rs.getTime("time_start"), rs.getTime("time_end"));
                DoctorSchedule schedule = new DoctorSchedule(
                        rs.getInt("id"),
                        docDB.getDoctorById(doctorId),
                        rs.getDate("schedule_date"),
                        shift,
                        rs.getInt("available") == 1
                );
                schedules.add(schedule);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor schedules: {0}", ex.getMessage());
        }
        return schedules;
    }

    @Override
    public ArrayList<DoctorSchedule> list() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<DoctorSchedule> getSchedulesBetweenDatesByDoctor(Date start, Date end, int doctorId) {
        List<DoctorSchedule> list = new ArrayList<>();
        String sql = """
        SELECT ds.id AS dsid,
               ds.schedule_date,
               ds.doctor_id,
               ds.shift_id,
               ds.available,
               s.time_start,
               s.time_end,
               d.id AS docId,
               st.fullname AS doctor_name
        FROM Doctor_Schedule ds
        JOIN Shift s ON ds.shift_id = s.id
        JOIN Doctor d ON ds.doctor_id = d.id
        JOIN Staff st ON d.staff_id = st.id
        WHERE ds.schedule_date BETWEEN ? AND ? AND ds.doctor_id = ?
        ORDER BY ds.schedule_date, s.time_start
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, start);
            ps.setDate(2, end);
            ps.setInt(3, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DoctorSchedule dsObj = new DoctorSchedule();
                    dsObj.setId(rs.getInt("dsid"));
                    dsObj.setScheduleDate(rs.getDate("schedule_date"));
                    dsObj.setAvailable(rs.getInt("available") == 1);

                    // Set Shift
                    Shift shift = new Shift();
                    shift.setId(rs.getInt("shift_id"));
                    shift.setTimeStart(rs.getTime("time_start"));
                    shift.setTimeEnd(rs.getTime("time_end"));
                    dsObj.setShift(shift);

                    // Set Doctor
                    Doctor doc = new Doctor();
                    doc.setId(rs.getInt("docId"));
                    doc.setName(rs.getString("doctor_name"));
                    dsObj.setDoctor(doc);

                    list.add(dsObj);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DoctorSchedule> getSchedulesBetweenDates(Date start, Date end) {
        List<DoctorSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ds.id AS dsid,
                   ds.schedule_date,
                   ds.doctor_id,
                   ds.shift_id,
                   ds.available,
                   s.time_start,
                   s.time_end,
                   d.id AS docId,
                   st.fullname AS doctor_name
            FROM Doctor_Schedule ds
            JOIN Shift s ON ds.shift_id = s.id
            JOIN Doctor d ON ds.doctor_id = d.id
            JOIN Staff st ON d.staff_id = st.id
            WHERE ds.schedule_date BETWEEN ? AND ?
            ORDER BY ds.schedule_date, s.time_start
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, start);
            ps.setDate(2, end);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DoctorSchedule dsObj = new DoctorSchedule();
                    dsObj.setId(rs.getInt("dsid"));
                    dsObj.setScheduleDate(rs.getDate("schedule_date"));
                    dsObj.setAvailable(rs.getInt("available") == 1);

                    // Tạo Shift
                    Shift shift = new Shift();
                    shift.setId(rs.getInt("shift_id"));
                    shift.setTimeStart(rs.getTime("time_start"));
                    shift.setTimeEnd(rs.getTime("time_end"));
                    dsObj.setShift(shift);

                    // Tạo Doctor
                    Doctor doc = new Doctor();
                    doc.setId(rs.getInt("docId"));
                    doc.setName(rs.getString("doctor_name"));  // QUAN TRỌNG: setName
                    dsObj.setDoctor(doc);

                    list.add(dsObj);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean assignShift(int doctorId, Date shiftDate, int shiftId) {
        // Kiểm tra xem đã có lịch của bác sĩ vào ngày và ca đó chưa
        String checkSql = "SELECT COUNT(*) FROM Doctor_Schedule WHERE doctor_id = ? AND schedule_date = ? AND shift_id = ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
            checkStmt.setInt(1, doctorId);
            checkStmt.setDate(2, shiftDate);
            checkStmt.setInt(3, shiftId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Đã tồn tại lịch, không thực hiện insert lại
                return false;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking duplicate shift: {0}", ex.getMessage());
            return false;
        }

        // Nếu chưa tồn tại, thực hiện INSERT
        String insertSql = "INSERT INTO Doctor_Schedule (doctor_id, schedule_date, shift_id, available) VALUES (?, ?, ?, 1)";
        try (PreparedStatement stm = connection.prepareStatement(insertSql)) {
            stm.setInt(1, doctorId);
            stm.setDate(2, shiftDate);
            stm.setInt(3, shiftId);
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error assigning shift: {0}", ex.getMessage());
            return false;
        }
    }

    public boolean updateShift(int doctorId, int scheduleId, Date shiftDate, int shiftId) {
        // 1. Kiểm tra xem bác sĩ này, ngày này, ca này đã tồn tại chưa (trừ schedule hiện tại)
        String checkSql = "SELECT COUNT(*) FROM Doctor_Schedule "
                + "WHERE doctor_id = ? AND schedule_date = ? AND shift_id = ? AND id <> ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
            checkStmt.setInt(1, doctorId);
            checkStmt.setDate(2, shiftDate);
            checkStmt.setInt(3, shiftId);
            checkStmt.setInt(4, scheduleId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Đã có 1 lịch khác trùng => return false
                    return false;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking duplicate shift: {0}", ex.getMessage());
            return false;
        }

        String sql = "UPDATE Doctor_Schedule SET doctor_id=?, schedule_date=?, shift_id=? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, doctorId);
            stm.setDate(2, shiftDate);
            stm.setInt(3, shiftId);
            stm.setInt(4, scheduleId);
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating shift: {0}", ex.getMessage());
            return false;
        }
    }

    public boolean deleteShift(int scheduleId) {
        String sql = "DELETE FROM Doctor_Schedule WHERE id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, scheduleId);
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting shift: {0}", ex.getMessage());
            return false;
        }
    }

    public List<DoctorSalaryStat> getDoctorSalaryStats(Date start, Date end, String rawSearch,
            String sortField, String sortDir, int offset, int pageSize) {
        List<DoctorSalaryStat> stats = new ArrayList<>();

        // Xử lý rawSearch: trim và thay thế nhiều khoảng trắng bằng "%"
        String searchPattern = null;
        if (rawSearch != null) {
            rawSearch = rawSearch.trim().replaceAll("\\s+", "%");
            if (!rawSearch.isEmpty()) {
                searchPattern = "%" + rawSearch + "%";
            }
        }

        // Câu truy vấn cơ bản (chỉ tính những ca làm việc khả dụng)
        String sql = """
        SELECT d.id as DoctorId, st.fullname as DoctorName, COUNT(*) as ShiftCount, 
               d.price as SalaryRate, d.salaryCoefficient as SalaryCoefficient
        FROM Doctor_Schedule ds
        JOIN Doctor d ON ds.doctor_id = d.id
        JOIN Staff st ON d.staff_id = st.id
        WHERE ds.schedule_date BETWEEN ? AND ? AND ds.available = 1
        """;

        // Nếu có từ khóa tìm kiếm, thêm điều kiện cho c.fullname
        if (searchPattern != null && !searchPattern.isEmpty()) {
            sql += " AND st.fullname LIKE ? ";
        }

        sql += " GROUP BY d.id, st.fullname, d.price, d.salaryCoefficient ";

        // Xử lý sắp xếp: chỉ cho phép sắp xếp theo các trường cụ thể
        if (sortField != null && !sortField.trim().isEmpty()) {
            switch (sortField) {
                case "DoctorName":
                    sql += " ORDER BY st.fullname " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "ShiftCount":
                    sql += " ORDER BY COUNT(*) " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "TotalSalary":
                    // Tổng lương = COUNT(*) * d.price * d.salaryCoefficient
                    sql += " ORDER BY (COUNT(*) * d.price * d.salaryCoefficient) "
                            + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                default:
                    sql += " ORDER BY st.fullname ASC";
                    break;
            }
        } else {
            sql += " ORDER BY st.fullname ASC";
        }

        // Áp dụng phân trang: OFFSET FETCH
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            stm.setDate(index++, start);
            stm.setDate(index++, end);
            if (searchPattern != null && !searchPattern.isEmpty()) {
                stm.setString(index++, searchPattern);
            }
            stm.setInt(index++, offset);
            stm.setInt(index++, pageSize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                DoctorSalaryStat stat = new DoctorSalaryStat();
                stat.setDoctorId(rs.getInt("DoctorId"));
                stat.setDoctorName(rs.getString("DoctorName"));
                stat.setShiftCount(rs.getInt("ShiftCount"));
                double salaryRate = rs.getDouble("SalaryRate");
                double coefficient = rs.getDouble("SalaryCoefficient");
                stat.setSalaryRate(salaryRate);
                stat.setTotalSalary(stat.getShiftCount() * salaryRate * coefficient);
                stats.add(stat);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor salary stats: {0}", ex.getMessage());
        }
        return stats;
    }

    public int countDoctorSalaryStats(Date start, Date end, String rawSearch) {
        int total = 0;

        // Xử lý rawSearch: trim và thay thế nhiều khoảng trắng bằng "%"
        String searchPattern = null;
        if (rawSearch != null) {
            rawSearch = rawSearch.trim().replaceAll("\\s+", "%");
            if (!rawSearch.isEmpty()) {
                searchPattern = "%" + rawSearch + "%";
            }
        }

        String sql = """
        SELECT COUNT(*) as Total
        FROM (
            SELECT d.id
            FROM Doctor_Schedule ds
            JOIN Doctor d ON ds.doctor_id = d.id
            JOIN Staff st ON d.staff_id = st.id
            WHERE ds.schedule_date BETWEEN ? AND ? AND ds.available = 1
        """;
        if (searchPattern != null && !searchPattern.isEmpty()) {
            sql += " AND st.fullname LIKE ? ";
        }
        sql += " GROUP BY d.id ) AS T";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            stm.setDate(index++, start);
            stm.setDate(index++, end);
            if (searchPattern != null && !searchPattern.isEmpty()) {
                stm.setString(index++, searchPattern);
            }
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                total = rs.getInt("Total");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting doctor salary stats: {0}", ex.getMessage());
        }
        return total;
    }

}
