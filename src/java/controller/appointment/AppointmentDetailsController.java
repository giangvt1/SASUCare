package controller.appointment;

import com.google.gson.Gson;
import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet to fetch appointment details
 */
public class AppointmentDetailsController extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get appointment ID from request
        String appointmentIdStr = request.getParameter("id");

        if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID.");
            return;
        }

        try {
//            String appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = appointmentDB.get(appointmentIdStr);

            if (appointment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found.");
                return;
            }

            // Convert the appointment object to JSON
            Gson gson = new Gson();
            String json = gson.toJson(appointment);

            // Set response headers
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Send response
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID format.");
        }
    }
}
