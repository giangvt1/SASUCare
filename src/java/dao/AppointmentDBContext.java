package dao;

import dal.DBContext;
import model.Appointment;
import model.Customer;
import model.Doctor;
import model.DoctorSchedule;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDBContext extends DBContext<Appointment> {
    private static final Logger LOGGER = Logger.getLogger(AppointmentDBContext.class.getName());

    @Override
    public void insert(Appointment model) {
        String sql = "INSERT INTO Appointment (customer_id, doctor_id, date, time_slot_id, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, model.getCustomer().getId());
            stm.setInt(2, model.getDoctor().getId());
            stm.setDate(3, model.getDoctorSchedule().getScheduleDate());
            stm.setInt(4, model.getDoctorSchedule().getId()); // Store the TimeSlot ID
            stm.setString(5, model.getStatus());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    model.setId(generatedKeys.getInt(1));
                    System.out.println("Appointment booked successfully with ID: " + model.getId());
                }
            } else {
                System.out.println("Appointment booking failed.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting appointment: {0}", ex.getMessage());
        }
    }

    @Override
    public void update(Appointment model) {
        String sql = "UPDATE Appointment SET customer_id = ?, doctor_id = ?, date = ?, time_slot_id = ?, status = ? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getCustomer().getId());
            stm.setInt(2, model.getDoctor().getId());
            stm.setDate(3, model.getDoctorSchedule().getScheduleDate());
            stm.setInt(4, model.getDoctorSchedule().getId());
            stm.setString(5, model.getStatus());
            stm.setInt(6, model.getId());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("Appointment updated successfully.");
            } else {
                System.out.println("Appointment update failed.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating appointment: {0}", ex.getMessage());
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
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

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
        String sql = "SELECT * FROM Appointment WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, Integer.parseInt(id));
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                appointment = new Appointment();
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
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching appointment data: {0}", ex.getMessage());
        }
        return appointment;
    }
}
