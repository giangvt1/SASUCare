/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import model.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Application;
import model.DoctorSchedule;
import model.Shift;

/**
 *
 * @author acer
 */
public class DoctorDBContext extends DBContext<Doctor> {

    private static final Logger LOGGER = Logger.getLogger(DoctorDBContext.class.getName());

    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT d.id, s.fullname, dep.name AS specialty "
                + "FROM Doctor d "
                + "JOIN Staff s ON d.id = s.id "
                + "JOIN Doctor_Department dd ON d.id = dd.doctor_id "
                + "JOIN Department dep ON dd.department_id = dep.id "
                + "WHERE d.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    doctor.setName(rs.getString("fullname"));
                    doctor.setSpecialty(rs.getString("specialty"));
                    return doctor;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public ArrayList<Doctor> list() {
        ArrayList<Doctor> doctors = new ArrayList<>();
        String sql = """
                SELECT d.id AS doctor_id, s.fullname, s.email, s.phone_number, s.gender, s.address, dep.name AS specialty
                FROM Doctor d
                JOIN Staff s ON d.id = s.id
                JOIN Doctor_Department dd ON d.id = dd.doctor_id
                JOIN Department dep ON dd.department_id = dep.id
                """;
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("fullname"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhoneNumber(rs.getString("phone_number"));
                doctor.setGender(rs.getBoolean("gender"));
                doctor.setAddress(rs.getString("address"));
                doctor.setSpecialty(rs.getString("specialty"));

                doctors.add(doctor);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor list: {0}", ex.getMessage());
        }
        return doctors;
    }

    @Override
    public Doctor get(String id) {
        Doctor doctor = null;
        String sql = """
                SELECT d.id AS doctor_id, s.fullname, s.email, s.phone_number, s.gender, s.address, dep.name AS specialty
                FROM Doctor d
                JOIN Staff s ON d.id = s.id
                JOIN Doctor_Department dd ON d.id = dd.doctor_id
                JOIN Department dep ON dd.department_id = dep.id
                WHERE d.id = ?
                """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("fullname"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhoneNumber(rs.getString("phone_number"));
                doctor.setGender(rs.getBoolean("gender"));
                doctor.setAddress(rs.getString("address"));
                doctor.setSpecialty(rs.getString("specialty"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor: {0}", ex.getMessage());
        }
        return doctor;
    }

    public ArrayList<DoctorSchedule> getDoctorSchedules(int doctorId, Date date) {
        ArrayList<DoctorSchedule> schedules = new ArrayList<>();
        String sql = """
                SELECT ds.id AS schedule_id, ds.schedule_date, s.id AS shift_id, s.time_start, s.time_end, available
                                FROM Doctor_Schedule ds
                                JOIN Shift s ON ds.shift_id = s.id
                WHERE ds.doctor_id = ? AND ds.schedule_date = ?
                """;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Shift shift = new Shift(rs.getInt("shift_id"), rs.getTime("time_start"), rs.getTime("time_end"));
                DoctorSchedule schedule = new DoctorSchedule(
                        rs.getInt("schedule_id"),
                        getDoctorById(doctorId),
                        rs.getDate("schedule_date"),
                        shift,
                        rs.getBoolean("available")
                );
                schedules.add(schedule);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving doctor schedules: {0}", ex.getMessage());
        }
        return schedules;
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
    
    public List<Application> getApplicationsByDoctorID(int did, int page) {
        List<Application> applications = new ArrayList<>();
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        String sql = "SELECT id, name, date, doctor_id, reason, status, reply " +
                     "FROM Application WHERE doctor_id = ? " +
                     "ORDER BY date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, did);
            stm.setInt(2, offset);
            stm.setInt(3, pageSize);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Application app = new Application(
                    rs.getInt("id"),
                    rs.getInt("doctor_id"),
                    rs.getString("name"),
                    rs.getString("reason"),
                    rs.getDate("date")
                );
                app.setStatus(rs.getString("status"));
                app.setReply(rs.getString("reply"));
                applications.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
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
