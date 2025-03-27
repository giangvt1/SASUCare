package Service;

import com.google.gson.JsonObject;
import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/CheckNewAppointmentServlet")
public class CheckNewAppointmentServlet extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get the userRoles from the session as a String
        String userRolesStr = (String) session.getAttribute("userRoles");

        // Convert the String into a List of roles
        List<String> userRoles = new ArrayList<>();
        if (userRolesStr != null && !userRolesStr.isEmpty()) {
            userRoles = Arrays.asList(userRolesStr.split(",\\s*")); // Split by comma and optional space
        }

        String condition = "";

        boolean isDoctor = false;
        boolean isHR = false;

        if (userRoles != null) {
            if (userRoles.contains("Doctor")) {
                isDoctor = true;
            }
            if (userRoles.contains("HR")) {
                isHR = true;
            }
        }

        // Set the condition based on roles
        if (isDoctor) {
            condition = "AND [status] = 'confirmed'";
        } else if (isHR) {
            condition = "AND [status] = 'pending'";
        }

        try {
            int newCount = appointmentDB.getNewAppointmentsCount(condition);

            // Log the result for debugging
            System.out.println("New count of appointments: " + newCount);

            // Create the JSON response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("newCount", newCount);

            // Send the response
            response.setContentType("application/json");
            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to retrieve appointments\"}");
        }
    }

}
