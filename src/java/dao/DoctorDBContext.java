package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;

/**
 *
 * @author acer
 */
public class DoctorDBContext extends DBContext<Doctor> {

    private static final Logger LOGGER = Logger.getLogger(DoctorDBContext.class.getName());

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
        String sql = "SELECT d.id FROM Doctor d JOIN Staff s ON d.staff_id = s.id WHERE s.staff_username = ?";
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
                WHERE ds.available = 1 and ds.doctor_id = ? AND ds.schedule_date = ?
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
            SELECT d.id, s.fullname, dep.name AS specialty, d.price
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
                    doctor.setPrice(rs.getString("price"));
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
        List<Doctor> doctors = new ArrayList<>();

        String sql = "SELECT d.id, s.fullname AS doctor_name, s.img, d.price, "
                + "COALESCE(AVG(r.rating), 0) AS average_rating, "
                + "STUFF(( "
                + "    SELECT DISTINCT ', ' + dep.name "
                + "    FROM Doctor_Department dd2 "
                + "    JOIN Department dep ON dd2.department_id = dep.id "
                + "    WHERE dd2.doctor_id = d.id "
                + "    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS specialties, "
                + "STUFF(( "
                + "    SELECT DISTINCT ', ' + c.CertificateName "
                + "    FROM Certificate c "
                + "    WHERE c.DoctorID = d.id AND c.Status != 'Pending' "
                + "    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS certificates "
                + "FROM Doctor d "
                + "JOIN Staff s ON d.staff_id = s.id "
                + "JOIN Doctor_Schedule ds ON d.id = ds.doctor_id "
                + "LEFT JOIN Rating r ON d.id = r.doctor_id "
                + "WHERE ds.schedule_date = ? ";

        List<Object> params = new ArrayList<>();
        params.add(selectedDate); // Schedule date filter

        // Add doctor name filter (if provided)
        if (name != null && !name.trim().isEmpty()) {
            sql += "AND s.fullname LIKE ? ";
            params.add("%" + name + "%");
        }

        // Add department filter (if selected)
        if (selectedSpecialties != null && !selectedSpecialties.isEmpty()) {
            sql += "AND d.id IN ( "
                    + "    SELECT DISTINCT dd.doctor_id "
                    + "    FROM Doctor_Department dd "
                    + "    WHERE dd.department_id IN (";
            sql += String.join(", ", Collections.nCopies(selectedSpecialties.size(), "?")) + ")) ";
            params.addAll(selectedSpecialties);
        }

        sql += "GROUP BY d.id, s.fullname, s.img, d.price";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setName(rs.getString("doctor_name"));
                doctor.setImg(rs.getString("img"));
                doctor.setPrice(rs.getString("price"));
                doctor.setAverage_rating(rs.getDouble("average_rating"));

                // Convert specialties from comma-separated string to List
                String specialtiesStr = rs.getString("specialties");
                doctor.setSpecialties(specialtiesStr != null ? Arrays.asList(specialtiesStr.split(", ")) : new ArrayList<>());

                // Convert certificates from comma-separated string to List
                String certificatesStr = rs.getString("certificates");
                List<String> certificates = certificatesStr != null ? Arrays.asList(certificatesStr.split(", ")) : new ArrayList<>();
                 doctor.setCertificates(certificates);
                doctors.add(doctor);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return doctors;
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
