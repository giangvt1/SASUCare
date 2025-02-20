package controller.appointment;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import java.io.IOException;
import java.io.PrintWriter;

import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;

/**
 *
 * @author Golden  Lightning
 */
public class AppointmentCancelController extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get appointment ID from the request
        String appointmentId = request.getParameter("appointmentId");
        Appointment appointment = appointmentDB.get(appointmentId);
        appointment.setStatus("Canceled");
        // Cancel appointment in the database
        appointmentDB.update(appointment);

        // Redirect back to the appointment list page
        response.sendRedirect(request.getContextPath() + "/appointment/list");
    }

}
