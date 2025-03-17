package dao;

import dal.DBContext;
import model.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DoctorSchedule;
import model.Shift;
import model.VisitHistory;

/**
 *
 * @author acer
 */
public class DoctorDBContext extends DBContext<Doctor> {

    private static final Logger LOGGER = Logger.getLogger(DoctorDBContext.class.getName());

    public static void main(String[] args) {
        DoctorDBContext d = new DoctorDBContext();
        System.out.println(d.getVisitHistoriesByDoctorIdPaginated(16, 1, 10).size());
    }

    public ArrayList<VisitHistory> getVisitHistoriesByDoctorIdPaginated(int doctorId, int page, int size) {
        ArrayList<VisitHistory> visitHistories = new ArrayList<>();
        String sql = "SELECT v.VisitDate, v.ReasonForVisit, v.Diagnoses, v.TreatmentPlan, c.fullname FROM VisitHistory v JOIN [doctor] d ON v.doctorID = d.id JOIN [Customer] c ON v.CustomerID = c.id WHERE DoctorID = ? ORDER BY VisitDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        int offset = (page - 1) * size;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setInt(2, offset);
            ps.setInt(3, size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VisitHistory vh = new VisitHistory();
                    vh.setVisitDate(rs.getTimestamp("VisitDate"));
                    vh.setReasonForVisit(rs.getString("ReasonForVisit"));
                    vh.setDiagnoses(rs.getString("Diagnoses"));
                    vh.setTreatmentPlan(rs.getString("TreatmentPlan"));
                    vh.setCustomerName(rs.getString("fullname"));
                    visitHistories.add(vh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return visitHistories;
    }

    public int getVisitHistoryCountByDoctorId(int doctorId) {
        String sql = "SELECT COUNT(*) FROM VisitHistory WHERE DoctorID = ?";
        int count = 0;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public ArrayList<Doctor> searchDoctor(String name, Date dob, Boolean gender, int page, String sort, int size) {
        ArrayList<Doctor> doctors = new ArrayList<>();
        String sql = """
                  SELECT d.id, s.fullname, s.gender, s.dob, s.address, d.info, d.salaryCoefficient, u.gmail, u.phone
                                   FROM [Staff] s 
                                   JOIN [Doctor] d ON s.id = d.staff_id 
                                   JOIN [User] u ON u.username = s.staff_username
                 """;

        StringBuilder sqlBuilder = new StringBuilder(sql);

        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND s.fullname COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (dob != null) {
            sqlBuilder.append(" AND s.dob = ?");
        }
        if (gender != null) {
            sqlBuilder.append(" AND s.gender = ?");
        }

        switch (sort) {
            case "default":
                sqlBuilder.append(" ORDER BY s.id");
                break;
            case "fullNameAZ":
                sqlBuilder.append(" ORDER BY s.fullname ASC");
                break;
            case "fullNameZA":
                sqlBuilder.append(" ORDER BY s.fullname DESC");
                break;
            case "DOBLTH":
                sqlBuilder.append(" ORDER BY s.dob ASC");
                break;
            case "DOBHTL":
                sqlBuilder.append(" ORDER BY s.dob DESC");
                break;
            default:
                throw new AssertionError("Invalid sort type: " + sort);
        }
        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;

            if (name != null && !name.isEmpty()) {
                stm.setString(paramIndex++, "%" + name + "%");
            }
            if (dob != null) {
                stm.setDate(paramIndex++, new java.sql.Date(dob.getTime()));
            }
            if (gender != null) {
                stm.setBoolean(paramIndex++, gender);
            }

            int offset = (page - 1) * size;
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, size);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    doctor.setName(rs.getString("fullname"));
                    doctor.setGender(rs.getBoolean("gender"));
                    doctor.setDob(rs.getDate("dob"));
                    doctor.setEmail(rs.getString("gmail"));
                    doctor.setAddress(rs.getString("address"));
                    doctor.setInfo(rs.getString("info"));
                    doctor.setSalaryCoefficient(rs.getDouble("salaryCoefficient"));
                    doctors.add(doctor);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing doctors: {0}", ex.getMessage());
        }

        return doctors;
    }

    public int countSearchDoctor(String name, Date dob, Boolean gender) {
        int count = 0;
        String sql = " SELECT COUNT(*)FROM [Staff] s JOIN [Doctor] d ON s.id = d.staff_id  JOIN [User] u ON u.username = s.staff_username";

        StringBuilder sqlBuilder = new StringBuilder(sql);

        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND fullname COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (dob != null) {
            sqlBuilder.append(" AND dob = ?");
        }
        if (gender != null) {
            sqlBuilder.append(" AND gender = ?");
        }

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;

            if (name != null && !name.isEmpty()) {
                stm.setString(paramIndex++, "%" + name + "%");
            }
            if (dob != null) {
                stm.setDate(paramIndex++, new java.sql.Date(dob.getTime()));
            }
            if (gender != null) {
                stm.setBoolean(paramIndex++, gender);
            }

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting doctors: {0}", ex.getMessage());
        }

        return count;
    }

    public int getDoctorIdByStaffUsername(String username) {
        int doctorId = -1;
        String sql = "SELECT d.id FROM Doctor d JOIN Staff s ON d.staff_id = s.id WHERE s.staff_username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                doctorId = rs.getInt("id");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting doctor ID by staff username", ex);
        }
        return doctorId;
    }

    public Doctor getDoctorByUsername(String username) {
        Doctor doctor = null;
        String sql = "SELECT * FROM Doctor WHERE username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                doctor = new Doctor();
                // Set properties of doctor from result set
                doctor.setId(rs.getInt("id"));
                doctor.setName(rs.getString("name"));
                // Add other properties as needed
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor by username", ex);
        }
        return doctor;
    }

    @Override
    public Doctor get(String id) {
        return getDoctorById(Integer.parseInt(id));
    }

    public ArrayList<DoctorSchedule> getDoctorSchedules(int doctorId, Date date) {
        ArrayList<DoctorSchedule> schedules = new ArrayList<>();
        String sql = """
                SELECT ds.id, ds.schedule_date, s.id AS shift_id, s.time_start, s.time_end, ds.available
                FROM Doctor_Schedule ds
                JOIN Shift s ON ds.shift_id = s.id
                WHERE ds.doctor_id = ? AND ds.schedule_date = ?
                """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                schedules.add(new DoctorSchedule(
                        rs.getInt("id"),
                        getDoctorById(doctorId),
                        rs.getDate("schedule_date"),
                        new Shift(
                                rs.getInt("shift_id"),
                                rs.getTime("time_start"),
                                rs.getTime("time_end")
                        ),
                        rs.getInt("available") == 1 // Chuyển đổi `int` → `boolean`
                ));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor schedules", ex);
        }
        return schedules;
    }

    public Doctor getDoctorById(int doctorId) {
        String sql = """
            SELECT d.id, s.fullname, dep.name AS specialty
            FROM Doctor d
            JOIN Staff s ON d.staff_id = s.id
            LEFT JOIN Doctor_Department dd ON d.id = dd.doctor_id
            LEFT JOIN Department dep ON dd.department_id = dep.id
            WHERE d.id = ?
            """;

        Doctor doctor = null;
        // Dùng LinkedHashSet để đảm bảo không trùng và giữ thứ tự
        Set<String> specialties = new LinkedHashSet<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (doctor == null) {
                    doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    // Nếu fullname bị null, bạn có thể set giá trị mặc định
                    doctor.setName(rs.getString("fullname") != null ? rs.getString("fullname") : "N/A");
                }
                String specialty = rs.getString("specialty");
                if (specialty != null) {
                    specialties.add(specialty);
                }
            }
            if (doctor != null) {
                doctor.setSpecialties(new ArrayList<>(specialties));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting doctor by ID", ex);
        }
        return doctor;
    }

    public Doctor getDoctorInforById(int id) {
        Doctor doctor = null;
        String sql = "SELECT d.id, s.fullname,s.gender, s.dob, s.address, u.gmail FROM [doctor] d JOIN [Staff] s ON d.staff_id = s.id JOIN [User] u ON s.staff_username = u.username WHERE d.id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setName(rs.getString("fullname"));
                doctor.setGender(rs.getBoolean("gender"));
                doctor.setDob(rs.getDate("dob"));
                doctor.setAddress(rs.getString("address"));
                doctor.setEmail(rs.getString("gmail"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor data: {0}", ex.getMessage());
        }
        return doctor;
    }

    @Override
    public ArrayList<Doctor> list() {
        HashMap<Integer, Doctor> doctorMap = new HashMap<>();
        String sql = """
                SELECT d.id, s.fullname, dep.name AS specialty
                FROM Doctor d
                JOIN Staff s ON d.staff_id = s.id
                LEFT JOIN Doctor_Department dd ON d.id = dd.doctor_id
                LEFT JOIN Department dep ON dd.department_id = dep.id
                ORDER BY d.id
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int doctorId = rs.getInt("id");

                // Nếu bác sĩ chưa có trong danh sách, tạo mới
                doctorMap.putIfAbsent(doctorId, new Doctor(doctorId, rs.getString("fullname"), new ArrayList<>()));

                // Thêm chuyên khoa vào danh sách
                if (rs.getString("specialty") != null) {
                    doctorMap.get(doctorId).getSpecialties().add(rs.getString("specialty"));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor list", ex);
        }
        return new ArrayList<>(doctorMap.values());
    }

// Get specialties for a doctor
    public ArrayList<String> getDoctorSpecialties(int doctorId) {
        ArrayList<String> specialties = new ArrayList<>();
        String sql = "SELECT s.name FROM Department s "
                + "JOIN Doctor_Department dd ON s.id = dd.department_id "
                + "WHERE dd.doctor_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    specialties.add(rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching specialties for doctor", e);
        }
        return specialties;
    }

    public List<Doctor> getDoctorsByFilters(String name, List<String> selectedSpecialties, Date selectedDate) {
        HashMap<Integer, Doctor> doctorMap = new HashMap<>();

        // Start the base SQL query
        String sql = "SELECT d.id, s.fullname, dep.name AS specialty "
                + "FROM Doctor d "
                + "JOIN Staff s ON d.staff_id = s.id "
                + "JOIN Doctor_Department dd ON d.id = dd.doctor_id "
                + "JOIN Department dep ON dd.department_id = dep.id "
                + "JOIN Doctor_Schedule ds ON d.id = ds.doctor_id "
                + "WHERE ds.schedule_date = ? "; // Ensures only doctors with a schedule that day are fetched

        ArrayList<Object> paramValues = new ArrayList<>();
        paramValues.add(selectedDate);  // Filter by selected date

        // Add filtering by doctor's name (if provided)
        if (name != null && !name.trim().isEmpty()) {
            sql += " AND s.fullname LIKE ?";
            paramValues.add("%" + name + "%");
        }

        // Add filtering by specialties (if selected)
        if (selectedSpecialties != null && !selectedSpecialties.isEmpty()) {
            sql += " AND dep.id IN (";
            sql += String.join(", ", Collections.nCopies(selectedSpecialties.size(), "?"));
            sql += ")";
            paramValues.addAll(selectedSpecialties);
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            // Set parameters dynamically
            for (int i = 0; i < paramValues.size(); i++) {
                stmt.setObject(i + 1, paramValues.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int doctorId = rs.getInt("id");
                String doctorFullName = rs.getString("fullname");
                String specialty = rs.getString("specialty");

                // If doctor is not in the list, add them
                doctorMap.putIfAbsent(doctorId, new Doctor(doctorId, doctorFullName, new ArrayList<>()));

                // Add specialty if not already in the list
                if (!doctorMap.get(doctorId).getSpecialties().contains(specialty)) {
                    doctorMap.get(doctorId).getSpecialties().add(specialty);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor list", ex);
        }

        return new ArrayList<>(doctorMap.values());
    }

    public Integer getDoctorIdByStaffId(int staffId) {
        String sql = "SELECT id FROM Doctor WHERE staff_id = ?";
        Integer doctorId = null;

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, staffId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                doctorId = rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return doctorId;
    }

    public Integer getStaffIdByDoctorId(int doctorId) {
        String sql = "SELECT staff_id FROM Doctor WHERE id = ?";
        Integer staffId = null;

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                staffId = rs.getInt("staff_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return staffId;
    }

    @Override
    public void insert(Doctor model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Doctor model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Doctor model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<Doctor> getAllDoctors() {
        HashMap<Integer, Doctor> doctorMap = new HashMap<>();
        String sql = """
                SELECT d.id, s.fullname, dep.name AS specialty
                FROM Doctor d
                JOIN Staff s ON d.staff_id = s.id
                LEFT JOIN Doctor_Department dd ON d.id = dd.doctor_id
                LEFT JOIN Department dep ON dd.department_id = dep.id
                ORDER BY d.id
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int doctorId = rs.getInt("id");

                // Nếu bác sĩ chưa có trong danh sách, tạo mới
                doctorMap.putIfAbsent(doctorId, new Doctor(doctorId, rs.getString("fullname"), new ArrayList<>()));

                // Thêm chuyên khoa vào danh sách
                if (rs.getString("specialty") != null) {
                    doctorMap.get(doctorId).getSpecialties().add(rs.getString("specialty"));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor list", ex);
        }
        return new ArrayList<>(doctorMap.values());
    }

}
