package controller.appointment;

import com.google.gson.Gson;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
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
        // Fetch doctorId and selected date from the request
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        Date selectedDate = Date.valueOf(request.getParameter("date"));

        // Fetch available shifts for the given doctor and date
        List<DoctorSchedule> availableShifts = doctorScheduleDB.getAvailableShiftsForDate(doctorId, selectedDate);

       
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        Date newDate = Date.valueOf(request.getParameter("date"));
        int newShiftId = Integer.parseInt(request.getParameter("shift"));

        // Fetch appointment by ID
        Appointment appointment = appointmentDB.get(String.valueOf(appointmentId));
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
            return;
        }

        // Validate that the new date is in the future
        if (newDate.before(new java.util.Date())) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cannot reschedule to a past date");
            return;
        }

        // Fetch the new doctor schedule for the given date and shift
        DoctorSchedule newSchedule = doctorScheduleDB.getScheduleByDateAndShift(appointment.getDoctor().getId(), newDate, newShiftId);
        if (newSchedule == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid schedule");
            return;
        }

        // Update appointment with the new schedule
        appointment.setDoctorSchedule(newSchedule);
        appointmentDB.update(appointment);

        // Redirect back to the appointment list with a success message
        response.sendRedirect(request.getContextPath() + "/appointment/list");
    }
}
