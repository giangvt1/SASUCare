package controller.appointment;

import dao.AppointmentDBContext;
import dao.CustomerDBContext;
import dao.DoctorDBContext;
import dao.DoctorScheduleDBContext;
import model.Appointment;
import model.Customer;
import model.Doctor;
import model.DoctorSchedule;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

public class AppointmentConfirmServlet extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final CustomerDBContext customerDB = new CustomerDBContext();
    private final DoctorDBContext doctorDB = new DoctorDBContext();
    private final DoctorScheduleDBContext doctorScheduleDB = new DoctorScheduleDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("currentCustomer") == null) {
            response.setContentType("text/html");
            response.getWriter().println("<script>"
                    + "alert('The user does not logged yet. Please login.');"
                    + "window.history.back();"
                    + "</script>");
            return;
        }

        PrintWriter out = response.getWriter();
        try {
            Customer customer = (Customer) session.getAttribute("currentCustomer");

            String doctorId = request.getParameter("doctor");
            String scheduleId = request.getParameter("schedule");

            Doctor doctor = doctorDB.get(doctorId);
            DoctorSchedule doctorSchedule = doctorScheduleDB.get(scheduleId);

            if (doctor == null || doctorSchedule == null || customer == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"status\":\"error\", \"message\":\"Invalid appointment details.\"}");
                return;
            }

            if (!doctorSchedule.isAvailable()) {
                response.sendRedirect(request.getContextPath() + "/appointment/doctor?date=" + doctorSchedule.getScheduleDate());
                return;
            }

            //  Create appointment object
            Appointment appointment = new Appointment();
            appointment.setCustomer(customer);
            appointment.setDoctor(doctor);
            appointment.setDoctorSchedule(doctorSchedule);
            appointment.setStatus("Pending");

            //  Mark doctor schedule as booked
            doctorSchedule.setAvailable(false);
            doctorScheduleDB.update(doctorSchedule);
            appointmentDB.insert(appointment);

            response.sendRedirect(request.getContextPath() + "/appointment/list");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"status\":\"error\", \"message\":\"Invalid input format.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\":\"error\", \"message\":\"An error occurred while booking.\"}");
        }
    }
}
