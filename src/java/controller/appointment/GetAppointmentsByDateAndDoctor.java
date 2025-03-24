/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.appointment;

import com.google.gson.Gson;
import dao.AppointmentDBContext;
import dao.CustomerDBContext;
import dao.DoctorDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.sql.Date;
import java.util.List;
import model.Appointment;
import model.Customer;
import model.Doctor;

/**
 *
 * @author Golden Lightning
 */
@WebServlet("/doctor/api/appointments")
public class GetAppointmentsByDateAndDoctor extends HttpServlet{
     private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorDBContext doctordb = new DoctorDBContext();
    private final CustomerDBContext cusDB = new CustomerDBContext();

    // New endpoint for fetching appointments by date (AJAX)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date = request.getParameter("date");
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        
        if (date != null) {
            LocalDate selectedDate = LocalDate.parse(date); // Convert the date string to LocalDate
            Doctor loggedDoctor = doctordb.getDoctorById(doctorId); // Fetch doctor info by ID
            if (loggedDoctor == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User does not have an associated doctor.");
                return;
            }

            List<Appointment> appointments = appointmentDB.getAppointmentsByDateAndDoctor(Date.valueOf(selectedDate), loggedDoctor.getId(),"");
            for (Appointment appointment : appointments) {
                Customer customer = cusDB.getCustomerWithGoogleAuthById(appointment.getCustomer().getId());
                appointment.setCustomer(customer);
            }
            // Return the appointments as JSON response
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(appointments));
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Date parameter is missing.");
        }
    }

    
}
