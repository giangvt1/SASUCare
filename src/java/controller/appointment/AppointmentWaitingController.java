package controller.appointment;

import controller.systemaccesscontrol.BaseRBACController;
import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.system.User;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentWaitingController extends BaseRBACController {

    private static final Logger LOGGER = Logger.getLogger(AppointmentWaitingController.class.getName());
    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String customerName = request.getParameter("customerName");
        String doctorName = request.getParameter("doctorName");
        String status = request.getParameter("status");
        boolean sortAsc = "asc".equalsIgnoreCase(request.getParameter("sortOrder"));

        int pageIndex = 1;
        int pageSize = 10;

        try {
            if (request.getParameter("page") != null) {
                pageIndex = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
            }
        } catch (NumberFormatException e) {
            pageIndex = 1;
        }

        // Get paginated appointments
        List<Appointment> appointments = appointmentDB.getAppointmentsByFilters(customerName, doctorName, status, sortAsc, pageIndex, pageSize);

        // Get total count for pagination
        int totalRecords = appointmentDB.countAppointments(customerName, doctorName, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Send attributes to JSP
        request.setAttribute("appointments", appointments);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/appointment/waiting-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String appointmentIdStr = request.getParameter("appointmentId");

        // Validate input to prevent errors
        if (appointmentIdStr == null || action == null || appointmentIdStr.trim().isEmpty()) {
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
            switch (action.toLowerCase()) {
                case "approve":
                    appointment.setStatus("Confirmed");
                    LOGGER.info("Appointment Approved: ID = " + appointmentId);
                    break;
                case "reject":
                    appointment.setStatus("Rejected");
                    LOGGER.info("Appointment Rejected: ID = " + appointmentId);
                    break;
                default:
                    LOGGER.warning("Invalid action: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }

            appointment.setUpdateAt(Date.valueOf(LocalDate.now()));

            // Update the database
            appointmentDB.update(appointment);

            // Redirect to appointment list with success message
            response.sendRedirect(request.getContextPath() + "/doctor/waiting-appointment");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid appointment ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID format.");
        }
    }
}
