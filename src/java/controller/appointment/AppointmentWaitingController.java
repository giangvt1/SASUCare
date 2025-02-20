package controller.appointment;

import controller.systemaccesscontrol.BaseRBACController;
import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.system.Staff;
import model.system.User;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;

public class AppointmentWaitingController extends BaseRBACController {

    private static final Logger LOGGER = Logger.getLogger(AppointmentWaitingController.class.getName());
    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        
    
        
        // Get filters from request
        String doctorName = request.getParameter("doctorName");
        
        if (doctorName != null) {
            doctorName = doctorName.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }
        String status = request.getParameter("status");
        boolean sortAsc = "asc".equals(request.getParameter("sortOrder"));
        
        if (doctorName != null) {
            doctorName = doctorName.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }

        // Fetch filtered appointments
        List<Appointment> appointments = appointmentDB.getAppointmentsByFilters(
                1, doctorName, status, sortAsc);
        
        // Send data to JSP
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/appointment/waiting-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String appointmentIdStr = request.getParameter("appointmentId");

        // Validate input to prevent errors
        if (appointmentIdStr == null || action == null) {
            LOGGER.warning("Invalid request: Missing parameters");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters.");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);

            // Fetch the appointment
            Appointment appointment = appointmentDB.get(String.valueOf(appointmentId));
            if (appointment == null) {
                LOGGER.warning("Appointment not found: ID = " + appointmentId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
                return;
            }

            // Handle appointment approval or rejection
            if ("approve".equalsIgnoreCase(action)) {
                appointment.setStatus("Confirmed");
                LOGGER.info("Appointment Approved: ID = " + appointmentId);
            } else if ("reject".equalsIgnoreCase(action)) {
                appointment.setStatus("Rejected");
                LOGGER.info("Appointment Rejected: ID = " + appointmentId);
            } else {
                LOGGER.warning("Invalid action: " + action);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                return;
            }

            // Update the database
            appointmentDB.update(appointment);

            // Redirect to appointment list with success message
            response.sendRedirect(request.getContextPath() + "/doctor/waiting-appointment?success=true");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid appointment ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID format.");
        }
    }
}
