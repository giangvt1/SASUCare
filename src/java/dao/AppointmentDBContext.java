package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Appointment;
import model.Customer;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;

public class AppointmentDBContext extends DBContext<Appointment> {

    private static final Logger LOGGER = Logger.getLogger(AppointmentDBContext.class.getName());

    public List<Appointment> getAppointmentsByFilters(int customerId, String doctorName, String status, boolean sortAsc) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.id AS appointment_id, d.id AS doctor_id, Staff.fullname AS doctor_name, \n"
                + "ds.schedule_date, s.time_start, s.time_end, a.status \n"
                + "FROM Appointment a \n"
                + "JOIN Doctor d ON a.doctor_id = d.id \n"
                + "JOIN Staff ON d.staff_id = Staff.id \n"
                + "JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id \n"
                + "JOIN Shift s ON ds.shift_id = s.id \n"
                + "WHERE a.customer_id = ?";

        ArrayList<Object> paramValues = new ArrayList<>();
        paramValues.add(customerId);

        if (doctorName != null && !doctorName.trim().isEmpty()) {
            sql += " AND Staff.fullname LIKE ?";
            paramValues.add("%" + doctorName + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND a.status = ?";
            paramValues.add(status);
        }

        sql += " ORDER BY ds.schedule_date " + (sortAsc ? "ASC" : "DESC");

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < paramValues.size(); i++) {
                stmt.setObject(i + 1, paramValues.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));

                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointment.setStatus(rs.getString("status"));

                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving appointments", ex);
        }
        return appointments;
    }

    @Override
    public void insert(Appointment appointment) {
        String sql = "INSERT INTO Appointment (customer_id, doctor_id, DocSchedule_id, status) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, appointment.getCustomer().getId());
            stm.setInt(2, appointment.getDoctor().getId());
            stm.setInt(3, appointment.getDoctorSchedule().getId());
            stm.setString(4, appointment.getStatus());

            int affectedRows = stm.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    appointment.setId(generatedKeys.getInt(1));
                    System.out.println("Appointment inserted with ID: " + appointment.getId());
                }
            } else {
                System.out.println("Failed to insert appointment.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting appointment: {0}", ex.getMessage());
            ex.printStackTrace();
        }
    }

    @Override
    public void update(Appointment model) {
        String sql = "UPDATE Appointment SET customer_id = ?, doctor_id = ?, DocSchedule_id = ?, status = ? WHERE id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getCustomer().getId());
            stm.setInt(2, model.getDoctor().getId());
            stm.setInt(3, model.getDoctorSchedule().getId()); // Update DocSchedule_id (Time Slot)
            stm.setString(4, model.getStatus());
            stm.setInt(5, model.getId()); // WHERE condition

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println(" Appointment updated successfully.");
            } else {
                System.out.println(" Appointment update failed. No rows affected.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating appointment", ex);
        }
    }

    @Override
    public void delete(Appointment model) {
        String sql = "DELETE FROM Appointment WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getId());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("Appointment deleted successfully.");
            } else {
                System.out.println("No appointment found with the given ID.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting appointment: {0}", ex.getMessage());
        }
    }

    @Override
    public ArrayList<Appointment> list() {
        ArrayList<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM Appointment";
        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));

                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                appointment.setCustomer(customer);

                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                appointment.setDoctor(doctor);

                DoctorSchedule timeSlot = new DoctorSchedule();
                timeSlot.setId(rs.getInt("time_slot_id"));
                appointment.setDoctorSchedule(timeSlot);

                appointment.setStatus(rs.getString("status"));

                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing appointments: {0}", ex.getMessage());
        }
        return appointments;
    }

    @Override
    public Appointment get(String id) {
        Appointment appointment = null;
        String sql = """
            SELECT a.id, a.customer_id, a.doctor_id, s.fullname AS doctor_name, 
                   ds.id AS DocSchedule_id, ds.schedule_date, sh.time_start, sh.time_end, a.status
            FROM Appointment a
            JOIN Doctor d ON a.doctor_id = d.id
            JOIN Staff s ON d.staff_id = s.id
            JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
            JOIN Shift sh ON ds.shift_id = sh.id
            WHERE a.id = ?""";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, Integer.parseInt(id));
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                appointment = new Appointment();
                appointment.setId(rs.getInt("id"));

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                appointment.setCustomer(customer);

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name")); // Fetch Doctor's Name
                appointment.setDoctor(doctor);

                // Set Doctor Schedule (Time Slot)
                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setId(rs.getInt("DocSchedule_id"));
                schedule.setScheduleDate(rs.getDate("schedule_date"));

                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                schedule.setShift(shift);

                appointment.setDoctorSchedule(schedule);

                // Set Status
                appointment.setStatus(rs.getString("status"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, " Error fetching appointment data", ex);
        }
        return appointment;
    }

}
