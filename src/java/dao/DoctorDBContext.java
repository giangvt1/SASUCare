package dao;

import dal.DBContext;
import model.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DoctorSchedule;
import model.Rating;
import model.Shift;
import model.system.Staff;

/**
 *
 * @author acer
 */
public class DoctorDBContext extends DBContext<Doctor> {

    private static final Logger LOGGER = Logger.getLogger(DoctorDBContext.class.getName());
    
    public Doctor getDoctorByUsername(String username) {
        Doctor doctor = null;
        String sql = """
        SELECT d.id AS doctor_id, Staff.fullname AS doctor_name, Staff.fullname AS staff_name, 
                        staff.address, staff.gender
                FROM Doctor d
                JOIN Staff ON d.staff_id = Staff.id
        WHERE Staff.staff_username = ?
    """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username); // Set the username in the query
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));

                // Set the Staff object related to the Doctor
                Staff staff = new Staff();
                staff.setFullname(rs.getString("staff_name"));
//                staff.getStaff_username().setUsername(username);
                doctor.setStaff(staff);

                doctor.setAddress(rs.getString("address"));
                doctor.setGender(rs.getBoolean("gender"));
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
                Where ds.available = 1
                and ds.doctor_id = ? AND ds.schedule_date = ?
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

    public static void main(String[] args) {
        DoctorDBContext db = new DoctorDBContext();
        System.out.println(db.getDoctorById(1).getRatings());
    }

    public Doctor getDoctorById(int doctorId) {
        String sql = """
                SELECT d.id, s.fullname, dep.name AS specialty, s.img, d.price, d.info
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
                    doctor.setPrice(rs.getString("price"));
                    doctor.setInfo(rs.getString("info"));
                }
                // Thêm img vào danh sách
                if (rs.getString("img") != null) {
                    doctor.setImg(rs.getString("img"));
                }
                if (rs.getString("specialty") != null) {
                    specialties.add(rs.getString("specialty"));
                }

            }

            if (doctor != null) {
                doctor.setSpecialties(specialties);
                doctor.setRatings(new RatingDBContext().getRatingsByDoctorId(doctorId));

// Tính toán và lưu trữ average_rating
                if (!doctor.getRatings().isEmpty()) {
                    double totalRating = doctor.getRatings().stream()
                            .mapToDouble(Rating::getRating)
                            .sum();
                    double averageRating = totalRating / doctor.getRatings().size();
                    doctor.setAverage_rating(averageRating);
                } else {
                    doctor.setAverage_rating(0.0);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting doctor by ID", ex);
        }
        return doctor;
    }

//    public static void main(String[] args) {
//        DoctorDBContext db = new DoctorDBContext();
//        System.out.println(db.list());
//    }
    @Override
    public ArrayList<Doctor> list() {
        HashMap<Integer, Doctor> doctorMap = new HashMap<>();
        String sql = """
                SELECT d.id, s.fullname, dep.name AS specialty, s.img, d.price, d.info
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

                // Thêm img vào danh sách
                if (rs.getString("img") != null) {
                    doctorMap.get(doctorId).setImg(rs.getString("img"));
                }

                // Thêm chuyên khoa vào danh sách
                if (rs.getString("specialty") != null) {
                    doctorMap.get(doctorId).getSpecialties().add(rs.getString("specialty"));
                }
                
              
                 doctorMap.get(doctorId).setRatings(new RatingDBContext().getRatingsByDoctorId(doctorId));

// Tính toán và lưu trữ average_rating
                if (!doctorMap.get(doctorId).getRatings().isEmpty()) {
                    double totalRating = doctorMap.get(doctorId).getRatings().stream()
                            .mapToDouble(Rating::getRating)
                            .sum();
                    double averageRating = totalRating / doctorMap.get(doctorId).getRatings().size();
                    doctorMap.get(doctorId).setAverage_rating(averageRating);
                } else {
                    doctorMap.get(doctorId).setAverage_rating(0.0);
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
                + "WHERE ds.available = 1"
                + "and ds.schedule_date = ? "; // Ensures only doctors with a schedule that day are fetched

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

}
