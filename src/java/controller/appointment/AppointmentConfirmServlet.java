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

//@WebServlet("/appointment/confirm")
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
        PrintWriter out = response.getWriter();
        
//        // **Get logged-in user ID**
//        Integer customerId = (Integer) session.getAttribute("customerId");
//        if (customerId == null) {
//            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//            out.write("{\"status\":\"error\", \"message\":\"User not logged in.\"}");
//            return;
//        }
        String customerId = "1";

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctor"));
            int scheduleId = Integer.parseInt(request.getParameter("schedule")); // Corrected parameter name

            // **Retrieve objects**
            Customer customer = customerDB.get(String.valueOf(customerId));
            Doctor doctor = doctorDB.get(String.valueOf(doctorId));
            DoctorSchedule doctorSchedule = doctorScheduleDB.get(String.valueOf(scheduleId));

            // **Check if all necessary data exists**
            if (customer == null || doctor == null || doctorSchedule == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"status\":\"error\", \"message\":\"Invalid appointment details.\"}");
                return;
            }

            // **Create and insert appointment**
            Appointment appointment = new Appointment();
            appointment.setCustomer(customer);
            appointment.setDoctor(doctor);
            appointment.setDoctorSchedule(doctorSchedule);
            appointment.setStatus("Confirmed");

            appointmentDB.insert(appointment);

            // **Mark doctor schedule as booked**
            doctorSchedule.setAvailable(false);
            doctorScheduleDB.update(doctorSchedule);

            // **Redirect to appointment history page**
//            response.sendRedirect(request.getContextPath() + "/user/appointments");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\":\"error\", \"message\":\"An error occurred while booking.\"}");
        }
    }
}
