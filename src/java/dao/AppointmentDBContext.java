package dao;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Appointment;
import model.Customer;
import model.Department;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;

public class AppointmentDBContext extends DBContext<Appointment> {

    private static final Logger LOGGER = Logger.getLogger(AppointmentDBContext.class.getName());

    public void cancelExpiredAppointments() {
        String sql = "UPDATE Appointment SET status = 'Canceled', updateAt = GETDATE() WHERE status = 'Pending' AND DocSchedule_id IN \n" +
"                (SELECT id FROM Doctor_Schedule WHERE schedule_date < CONVERT(DATE, GETDATE()))";

        try ( PreparedStatement stmt = connection.prepareStatement(sql)) {
            int affectedRows = stmt.executeUpdate();
            System.out.println("Expired appointments canceled: " + affectedRows);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List<Appointment> getFilteredAppointments(String name, Date date, String status, int pageIndex, int pageSize) {
        List<Appointment> appointments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT a.id, a.status, ds.schedule_date, s.time_start, s.time_end,
               d.id AS doctor_id, st.fullname AS doctor_name,
               c.id AS customer_id, c.fullname AS customer_name, c.phone_number
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.id
        JOIN Staff st ON d.staff_id = st.id
        JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
        JOIN Shift s ON ds.shift_id = s.id
        JOIN Customer c ON a.customer_id = c.id
        WHERE 1=1
    """);

        List<Object> params = new ArrayList<>();

        // Adding filters
        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND c.fullname LIKE ?");
            params.add("%" + name + "%");
        }

        if (date != null) {
            sql.append(" AND ds.schedule_date = ?");
            params.add(date);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.status = ?");
            params.add(status);
        }

        // Add ORDER BY clause (required for SQL Server pagination)
        sql.append(" ORDER BY a.id");

        // Add pagination (SQL Server syntax)
        int offset = (pageIndex - 1) * pageSize;
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);   // Offset comes first
        params.add(pageSize); // Number of rows to fetch

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            // Set parameters dynamically
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            // Proper logging would be more beneficial than printStackTrace
            ex.printStackTrace();
        }
        return appointments;
    }

    public List<Appointment> getFilteredAppointmentsTotals() {
        List<Appointment> appointments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT a.id, a.status, ds.schedule_date, s.time_start, s.time_end,
                   d.id AS doctor_id, st.fullname AS doctor_name,
                   c.id AS customer_id, c.fullname AS customer_name, c.phone_number
            FROM Appointment a
            JOIN Doctor d ON a.doctor_id = d.id
            JOIN Staff st ON d.staff_id = st.id
            JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
            JOIN Shift s ON ds.shift_id = s.id
            JOIN Customer c ON a.customer_id = c.id
            WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();

       

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            // Set parameters dynamically
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            // Using a proper logger would be more beneficial than just printStackTrace
            ex.printStackTrace();
        }
        return appointments;
    }

// Count filtered appointments
    public int getFilteredAppointmentsCount(String name, Date date, String status) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) 
            FROM Appointment a
            JOIN Doctor d ON a.doctor_id = d.id
            JOIN Staff st ON d.staff_id = st.id
            JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
            JOIN Shift s ON ds.shift_id = s.id
            JOIN Customer c ON a.customer_id = c.id
            WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();

        // Adding filters
        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND c.fullname LIKE ?");
            params.add("%" + name + "%");
        }

        if (date != null) {
            sql.append(" AND ds.schedule_date = ?");
            params.add(date);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.status = ?");
            params.add(status);
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            // Set parameters dynamically
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1); // Return total count of filtered appointments
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0; // Return 0 if no appointments found
    }

    public List<Appointment> getAppointmentsByDateAndDoctor(Date date, int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
        SELECT a.id AS appointment_id, a.status, ds.schedule_date, 
               s.time_start, s.time_end, d.id AS doctor_id, Staff.fullname AS doctor_name,
               c.id AS customer_id, c.fullname AS customer_name, c.phone_number
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.id
        JOIN Staff ON d.staff_id = Staff.id
        JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
        JOIN Shift s ON ds.shift_id = s.id
        JOIN Customer c ON a.customer_id = c.id
        WHERE a.doctor_id = ? AND ds.schedule_date = ?
    """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving appointments by date and doctor", ex);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByStatusAndDoctor(String status, int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
        SELECT a.id AS appointment_id, a.status, ds.schedule_date, 
               s.time_start, s.time_end, d.id AS doctor_id, Staff.fullname AS doctor_name,
               c.id AS customer_id, c.fullname AS customer_name, c.phone_number
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.id
        JOIN Staff ON d.staff_id = Staff.id
        JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
        JOIN Shift s ON ds.shift_id = s.id
        JOIN Customer c ON a.customer_id = c.id
        WHERE a.doctor_id = ? AND a.status = ?
    """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId); // Bác sĩ ID
            stmt.setString(2, status); // Trạng thái cuộc hẹn
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving appointments by status and doctor", ex);
        }
        return appointments;
    }

    public List<Appointment> getUpcomingAppointmentsByDoctor(Date currentDate, int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
        SELECT a.id AS appointment_id, a.status, ds.schedule_date, 
               s.time_start, s.time_end, d.id AS doctor_id, Staff.fullname AS doctor_name,
               c.id AS customer_id, c.fullname AS customer_name, c.phone_number
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.id
        JOIN Staff ON d.staff_id = Staff.id
        JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
        JOIN Shift s ON ds.shift_id = s.id
        JOIN Customer c ON a.customer_id = c.id
        WHERE a.doctor_id = ? AND ds.schedule_date > ? 
        ORDER BY ds.schedule_date ASC
    """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId); // Bác sĩ ID
            stmt.setDate(2, currentDate); // Ngày hiện tại
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving upcoming appointments by doctor", ex);
        }
        return appointments;
    }

    public int countAppointments(String customerName, String doctorName, String status) {
        String sql = """
        SELECT COUNT(*) FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.id
        JOIN Staff ON d.staff_id = Staff.id
        JOIN Customer c ON a.customer_id = c.id
        WHERE 1=1
    """;

        List<Object> paramValues = new ArrayList<>();

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql += " AND c.fullname LIKE ?";
            paramValues.add("%" + customerName.trim().replaceAll("\\s+", "%") + "%");
        }

        if (doctorName != null && !doctorName.trim().isEmpty()) {
            sql += " AND Staff.fullname LIKE ?";
            paramValues.add("%" + doctorName.trim().replaceAll("\\s+", "%") + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND a.status = ?";
            paramValues.add(status);
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < paramValues.size(); i++) {
                stmt.setObject(i + 1, paramValues.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting appointments", ex);
        }
        return 0;
    }

    public List<Appointment> getAppointmentsByFilters(int customerID, String doctorName, String status, boolean sortAsc) {
        List<Appointment> appointments = new ArrayList<>();

        String sql = """
SELECT 
                    a.id AS appointment_id, 
                    a.status, 
                    ds.schedule_date, 
                    s.time_start, s.time_end,
                    d.id AS doctor_id, Staff.fullname AS doctor_name, 
                    c.id AS customer_id, c.fullname AS customer_name, c.phone_number
                FROM Appointment a
                JOIN Doctor d ON a.doctor_id = d.id
                JOIN Staff ON d.staff_id = Staff.id
                JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
                JOIN Shift s ON ds.shift_id = s.id
                JOIN Customer c ON a.customer_id = c.id
        WHERE 1=1
    """;

        ArrayList<Object> paramValues = new ArrayList<>();

        // Dynamically add conditions
        if (customerID > 0) {
            sql += " AND c.id LIKE ?";
            paramValues.add("%" + customerID + "%");
        }

        if (doctorName != null && !doctorName.trim().isEmpty()) {
            sql += " AND Staff.fullname LIKE ?";
            paramValues.add("%" + doctorName.trim().replaceAll("\\s+", "%") + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND a.status = ?";
            paramValues.add(status);
        }

        sql += " ORDER BY ds.schedule_date " + (sortAsc ? "ASC" : "DESC");

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            int index = 1;
            for (Object value : paramValues) {
                stmt.setObject(index++, value);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));

                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving appointments", ex);
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsByFilters(String customerName, String doctorName, String status, boolean sortAsc, int pageIndex, int pageSize) {
        List<Appointment> appointments = new ArrayList<>();

        String sql = """
        SELECT 
            a.id AS appointment_id, 
            a.status, 
            ds.schedule_date, 
            s.time_start, s.time_end,
            d.id AS doctor_id, Staff.fullname AS doctor_name, 
            c.id AS customer_id, c.fullname AS customer_name, c.phone_number
        FROM Appointment a
        JOIN Doctor d ON a.doctor_id = d.id
        JOIN Staff ON d.staff_id = Staff.id
        JOIN Doctor_Schedule ds ON a.DocSchedule_id = ds.id
        JOIN Shift s ON ds.shift_id = s.id
        JOIN Customer c ON a.customer_id = c.id
        WHERE 1=1
    """;

        List<Object> paramValues = new ArrayList<>();

        // Filtering conditions
        if (doctorName != null && !doctorName.trim().isEmpty()) {
            sql += " AND Staff.fullname LIKE ?";
            paramValues.add("%" + doctorName.trim().replaceAll("\\s+", "%") + "%");
        }

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql += " AND c.fullname LIKE ?";
            paramValues.add("%" + customerName.trim().replaceAll("\\s+", "%") + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND a.status = ?";
            paramValues.add(status);
        }

        // Sorting by date
        sql += " ORDER BY ds.schedule_date " + (sortAsc ? "ASC" : "DESC");

        // **SQL Server Pagination using OFFSET & FETCH NEXT**
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        paramValues.add((pageIndex - 1) * pageSize); // Calculate offset
        paramValues.add(pageSize); // Number of records per page

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            int index = 1;
            for (Object value : paramValues) {
                stmt.setObject(index++, value);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("appointment_id"));
                appointment.setStatus(rs.getString("status"));

                // Set Doctor
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("doctor_id"));
                doctor.setName(rs.getString("doctor_name"));
                appointment.setDoctor(doctor);

                // Set Customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setFullname(rs.getString("customer_name"));
                customer.setPhone_number(rs.getString("phone_number"));
                appointment.setCustomer(customer);

                // Set Doctor Schedule
                DoctorSchedule doctorSchedule = new DoctorSchedule();
                doctorSchedule.setScheduleDate(rs.getDate("schedule_date"));

                // Set Shift
                Shift shift = new Shift();
                shift.setTimeStart(rs.getTime("time_start"));
                shift.setTimeEnd(rs.getTime("time_end"));
                doctorSchedule.setShift(shift);

                appointment.setDoctorSchedule(doctorSchedule);
                appointments.add(appointment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving paginated appointments", ex);
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
        String sql = "UPDATE Appointment SET customer_id = ?, doctor_id = ?, DocSchedule_id = ?, status = ?, updateAt = GETDATE() WHERE id = ?";

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
                appointment.setCreateAt(rs.getDate("createAt"));
                appointment.setUpdateAt(rs.getDate("updateAt"));
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
                appointment.setCreateAt(rs.getDate("createAt"));
                appointment.setUpdateAt(rs.getDate("updateAt"));

                // Set Status
                appointment.setStatus(rs.getString("status"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, " Error fetching appointment data", ex);
        }
        return appointment;
    }

}
