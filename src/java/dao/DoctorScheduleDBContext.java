package dao;

import dal.DBContext;
import model.Doctor;
import model.DoctorSchedule;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DoctorScheduleDBContext extends DBContext<DoctorSchedule> {
    private static final Logger LOGGER = Logger.getLogger(DoctorScheduleDBContext.class.getName());

    @Override
    public void insert(DoctorSchedule schedule) {
        String sql = "INSERT INTO Doctor_Schedule (doctor_id, schedule_date, time_start, time_end, available) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, schedule.getDoctor().getId());
            stm.setDate(2, schedule.getScheduleDate());
            stm.setTime(3, schedule.getTimeStart());
            stm.setTime(4, schedule.getTimeEnd());
            stm.setBoolean(5, schedule.isAvailable());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    schedule.setId(generatedKeys.getInt(1));
                    System.out.println("Doctor schedule added successfully with ID: " + schedule.getId());
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting doctor schedule: {0}", ex.getMessage());
        }
    }

    @Override
    public void update(DoctorSchedule schedule) {
        String sql = "UPDATE Doctor_Schedule SET schedule_date = ?, time_start = ?, time_end = ?, available = ? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setDate(1, schedule.getScheduleDate());
            stm.setTime(2, schedule.getTimeStart());
            stm.setTime(3, schedule.getTimeEnd());
            stm.setBoolean(4, schedule.isAvailable());
            stm.setInt(5, schedule.getId());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("Doctor schedule updated successfully.");
            } else {
                System.out.println("Doctor schedule update failed.");
            }
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
                System.out.println("Doctor schedule deleted successfully.");
            } else {
                System.out.println("No doctor schedule found with the given ID.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting doctor schedule: {0}", ex.getMessage());
        }
    }

   
    public List<DoctorSchedule> getSchedulesByDoctor(int doctorId, Date date) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM Doctor_Schedule WHERE doctor_id = ? AND schedule_date = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, doctorId);
            stm.setDate(2, date);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setId(rs.getInt("id"));

                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                schedule.setDoctor(doctor);

                schedule.setScheduleDate(rs.getDate("schedule_date"));
                schedule.setTimeStart(rs.getTime("time_start"));
                schedule.setTimeEnd(rs.getTime("time_end"));
                schedule.setAvailable(rs.getBoolean("available"));

                schedules.add(schedule);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor schedules: {0}", ex.getMessage());
        }
        return schedules;
    }

    @Override
    public DoctorSchedule get(String id) {
        DoctorSchedule schedule = null;
        String sql = "SELECT * FROM Doctor_Schedule WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, Integer.parseInt(id));
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                schedule = new DoctorSchedule();
                schedule.setId(rs.getInt("id"));

                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                schedule.setDoctor(doctor);

                schedule.setScheduleDate(rs.getDate("schedule_date"));
                schedule.setTimeStart(rs.getTime("time_start"));
                schedule.setTimeEnd(rs.getTime("time_end"));
                schedule.setAvailable(rs.getBoolean("available"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor schedule: {0}", ex.getMessage());
        }
        return schedule;
    }

    @Override
    public ArrayList<DoctorSchedule> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
