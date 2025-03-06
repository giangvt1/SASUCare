package controller.appointment;

import controller.systemaccesscontrol.BaseRBACController;
import dao.AppointmentDBContext;
import dao.DepartmentDBContext;
import dao.DoctorScheduleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Appointment;
import model.DoctorSchedule;
import model.system.User;

/**
 * Handles appointment approval and cancellation by doctors.
 */
public class AppointmentActionController extends HttpServlet {
    
    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorScheduleDBContext dsDB = new DoctorScheduleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int appointmentId;

        try {
            appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
            return;
        }

        // Fetch the appointment from the database
        Appointment appointment = appointmentDB.get(String.valueOf(appointmentId));
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
            return;
        }

        // Process action (approve or cancel)
        switch (action.toLowerCase()) {
            case "confirmed":
                appointment.setStatus("Confirmed");
                break;
            case "canceled":
                appointment.setStatus("Canceled");
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                return;
        }
        DoctorSchedule doctorSchedule = dsDB.get(String.valueOf(appointment.getDoctorSchedule().getId()));

        doctorSchedule.setAvailable(true);
        dsDB.update(doctorSchedule);
        // Update the appointment in the database
        appointmentDB.update(appointment);

        // Redirect back to the doctor's appointment list
        response.sendRedirect(request.getContextPath() + "/hr/appointments");
    }

}
