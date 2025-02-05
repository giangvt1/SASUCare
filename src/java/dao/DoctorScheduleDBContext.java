package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;

public class DoctorScheduleDBContext extends DBContext<DoctorSchedule> {
    private static final Logger LOGGER = Logger.getLogger(DoctorScheduleDBContext.class.getName());

    @Override
    public void insert(DoctorSchedule schedule) {
        String sql = "INSERT INTO Doctor_Schedule (doctor_id, schedule_date, shift_id, available) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, schedule.getDoctor().getId());
            stm.setDate(2, schedule.getScheduleDate());
            stm.setInt(3, schedule.getShift().getId()); // Use shift_id instead of time_start/time_end
            stm.setBoolean(4, schedule.isAvailable());

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
    public DoctorSchedule get(String id) {
        DoctorSchedule schedule = null;
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
                schedule = new DoctorSchedule();
                schedule.setId(rs.getInt("id"));

                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                schedule.setDoctor(doctor);

                schedule.setScheduleDate(rs.getDate("schedule_date"));

                Shift shift = new Shift();
                shift.setId(rs.getInt("shift_id"));
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));

                schedule.setShift(shift);
                schedule.setAvailable(rs.getBoolean("available"));
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
            stm.setBoolean(1, schedule.isAvailable());
            stm.setInt(2, schedule.getId()); // Updating Doctor_Schedule instead of Shift
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
                Shift shift = new Shift();
                shift.setId(rs.getInt("shift_id"));
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));

                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setId(rs.getInt("id"));
                schedule.setScheduleDate(rs.getDate("schedule_date"));
                schedule.setShift(shift);
                schedule.setAvailable(rs.getBoolean("available"));

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
}
