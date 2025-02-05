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
import java.sql.Date;

public class AppointmentConfirmServlet extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final CustomerDBContext customerDB = new CustomerDBContext();
    private final DoctorDBContext doctorDB = new DoctorDBContext();
    private final DoctorScheduleDBContext scheduleDB = new DoctorScheduleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("doctor"));
        int scheduleId = Integer.parseInt(request.getParameter("shift"));

        // Fetch doctor and schedule details from DB
        Doctor doctor = doctorDB.getDoctorById(doctorId);
        DoctorSchedule schedule = scheduleDB.get(String.valueOf(scheduleId));

        // Check if user is logged in
        HttpSession session = request.getSession();
//        Customer customer = (Customer) session.getAttribute("loggedCustomer");
//        if (customer == null) {
//            response.sendRedirect("../login");
//            return;
//        }
        int customer = 1;

        // Pass data to JSP
        request.setAttribute("doctor", doctor);
        request.setAttribute("schedule", schedule);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("../appointment/appointment_confirm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customer"));
        int doctorId = Integer.parseInt(request.getParameter("doctor"));
        int scheduleId = Integer.parseInt(request.getParameter("shift"));

        Customer customer = customerDB.get(String.valueOf(customerId));
        Doctor doctor = doctorDB.get(String.valueOf(doctorId));
        DoctorSchedule schedule = scheduleDB.get(String.valueOf(scheduleId));

        // Create an appointment and save it
        Appointment appointment = new Appointment();
        appointment.setCustomer(customer);
        appointment.setDoctor(doctor);
        appointment.setDoctorSchedule(schedule);
        appointment.setStatus("Confirmed");

        appointmentDB.insert(appointment);

        // Mark the schedule as booked
        schedule.setAvailable(false);
        scheduleDB.update(schedule);

        response.sendRedirect("/appointment/success?appointmentId=" + appointment.getId());
    }
}
