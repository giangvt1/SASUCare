/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.appointment;

import com.google.gson.Gson;
import dao.AppointmentDBContext;
import dao.CustomerDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import model.Appointment;
import model.Customer;

/**
 *
 * @author Golden Lightning
 */
@WebServlet("/doctor/api/appointment/details")
public class GetAppointmentDetails extends HttpServlet {
    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final CustomerDBContext customDB = new CustomerDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Appointment ID is required.");
            return;
        }


        Appointment appointment = appointmentDB.get(idParam);
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found.");
            return;
        }

             Customer customer = customDB.getCustomerWithGoogleAuthById(appointment.getCustomer().getId());

            Gson gson = new Gson();

            Map<String, Object> data = new HashMap<>();
            data.put("customer", customer);

            data.put("appointment", appointment);

            String json = gson.toJson(data);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
    }
}

