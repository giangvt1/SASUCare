/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.appointment;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dao.AppointmentDBContext;
import java.sql.Date;
import java.util.List;
import model.Appointment;

/**
 *
 * @author Golden Lightning
 */
public class DoctorScheduleServlet extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dateParam = request.getParameter("date");
        String doctorIdParam = request.getParameter("doctorId");

        if (dateParam == null || doctorIdParam == null || dateParam.isEmpty() || doctorIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing date or doctorId parameter");
            return;
        }

        Date date = Date.valueOf(dateParam);
        int doctorId = Integer.parseInt(doctorIdParam);

        AppointmentDBContext appointmentDB = new AppointmentDBContext();
        List<Appointment> appointments = appointmentDB.getAppointmentsByDateAndDoctor(date, doctorId);

        response.setContentType("application/json");
        response.getWriter().write(new Gson().toJson(appointments));
    }
}
