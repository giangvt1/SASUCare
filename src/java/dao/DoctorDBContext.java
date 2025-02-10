package dao;

import dal.DBContext;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;
import model.Application;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DoctorDBContext extends DBContext<Doctor> {

    private static final Logger LOGGER = Logger.getLogger(DoctorDBContext.class.getName());

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
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            List<String> specialties = new ArrayList<>();
            while (rs.next()) {
                if (doctor == null) {
                    doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    doctor.setName(rs.getString("fullname"));
                }
                if (rs.getString("specialty") != null) {
                    specialties.add(rs.getString("specialty"));
                }
            }

            if (doctor != null) {
                doctor.setSpecialties(specialties);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting doctor by ID", ex);
        }
        return doctor;
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

    public ArrayList<String> getDoctorSpecialties(int doctorId) {
        ArrayList<String> specialties = new ArrayList<>();
        String sql = """
                SELECT dep.name
                FROM Department dep
                JOIN Doctor_Department dd ON dep.id = dd.department_id
                WHERE dd.doctor_id = ?
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    specialties.add(rs.getString("name"));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching specialties for doctor", ex);
        }
        return specialties;
    }

    public boolean createApplicationForDid(Application application) {
        String sql = "INSERT INTO Application (doctor_id, name, reason, date) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, application.getDid());
            stm.setString(2, application.getName());
            stm.setString(3, application.getReason());
            stm.setDate(4, application.getDate());

            int rowsInserted = stm.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public void insert(Doctor model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void update(Doctor model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(Doctor model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
