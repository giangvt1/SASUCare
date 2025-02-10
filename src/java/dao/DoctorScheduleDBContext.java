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

public class DoctorScheduleDBContext extends DBContext<DoctorSchedule> {

    private static final Logger LOGGER = Logger.getLogger(DoctorScheduleDBContext.class.getName());

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
}
