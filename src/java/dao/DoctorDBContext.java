package dao;

import dal.DBContext;
import model.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Shift;

public class DoctorDBContext extends DBContext<Doctor> {

    private static final Logger LOGGER = Logger.getLogger(DoctorDBContext.class.getName());
    
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT d.id, s.fullname, dep.name AS specialty " +
                     "FROM Doctor d " +
                     "JOIN Staff s ON d.id = s.id " +
                     "JOIN Doctor_Department dd ON d.id = dd.doctor_id " +
                     "JOIN Department dep ON dd.department_id = dep.id " +
                     "WHERE d.id = ?";
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
    
     public HashMap<Doctor, ArrayList<Shift>> getAvailableDoctors(String date) {
        HashMap<Doctor, ArrayList<Shift>> doctorMap = new HashMap<>();
        String sql = "SELECT d.id, s.fullname, dep.name AS specialty, sh.id AS shift_id, sh.time_start, sh.time_end " +
                     "FROM Doctor d " +
                     "JOIN Staff s ON d.id = s.id " +
                     "JOIN Doctor_Department dd ON d.id = dd.doctor_id " +
                     "JOIN Department dep ON dd.department_id = dep.id " +
                     "JOIN Doctor_Schedule ds ON d.id = ds.doctor_id " +
                     "JOIN Shift sh ON ds.shift_id = sh.id " +
                     "WHERE ds.schedule_date = ? AND ds.available = 1 " +
                     "ORDER BY d.id, sh.time_start";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int doctorId = rs.getInt("id");
                    Doctor doctor = doctorMap.keySet().stream()
                            .filter(d -> d.getId() == doctorId)
                            .findFirst()
                            .orElse(null);
                    
                    if (doctor == null) {
                        doctor = new Doctor(
                                doctorId,
                                rs.getString("fullname"),
                                rs.getString("specialty")
                        );
                        doctorMap.put(doctor, new ArrayList<>());
                    }
                    
                    Shift shift = new Shift(
                            rs.getInt("shift_id"),
                            rs.getTime("time_start"),
                            rs.getTime("time_end")
                    );
                    doctorMap.get(doctor).add(shift);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching doctors and schedules", e);
        }
        return doctorMap;
    }

    // Get list of doctors with detailed information from Staff table
    public ArrayList<Doctor> getAllDoctors() {
        ArrayList<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT d.id, s.fullname, s.email, s.phone_number, s.gender, s.address, dep.name AS specialty "
                + "FROM Doctor d "
                + "JOIN Staff s ON d.id = s.id "
                + "JOIN Doctor_Department dd ON d.id = dd.doctor_id "
                + "JOIN Department dep ON dd.department_id = dep.id";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Doctor doctor = new Doctor(
                        rs.getInt("id"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getBoolean("gender"),
                        rs.getString("address"),
                        rs.getString("specialty")
                );
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching doctors", e);
        }
        return doctors;
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

    @Override
    public ArrayList<Doctor> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Doctor get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
