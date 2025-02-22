package controller.appointment;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.sql.Date;

import dao.AppointmentDBContext;
import dao.DoctorScheduleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import model.DoctorSchedule;

/**
 * Handles rescheduling of appointments.
 */
public class AppointmentRescheduleController extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorScheduleDBContext doctorScheduleDB = new DoctorScheduleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Date newDate = Date.valueOf(request.getParameter("date"));
        int newShiftId = Integer.parseInt(request.getParameter("shift"));

        // Fetch appointment
        Appointment appointment = appointmentDB.get(String.valueOf(appointmentId));
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
            return;
        }

        // Validate new date (must be in the future)
        if (newDate.before(new java.util.Date())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cannot reschedule to a past date");
            return;
        }

        // Fetch new schedule
        DoctorSchedule newSchedule = doctorScheduleDB.getScheduleByDateAndShift(appointment.getDoctor().getId(), newDate, newShiftId);
        if (newSchedule == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid schedule");
            return;
        }

        // Update appointment
        appointment.setDoctorSchedule(newSchedule);
        appointmentDB.update(appointment);

        // Redirect to appointment list with success message
        response.sendRedirect(request.getContextPath() + "/appointment/list?success=rescheduled");
    }
}
