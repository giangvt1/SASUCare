package controller.appointment;

import java.io.IOException;
import dao.AppointmentDBContext;
import dao.DoctorScheduleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import java.sql.*;
import java.time.LocalDate;
import model.DoctorSchedule;

public class AppointmentCancelController extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorScheduleDBContext dsDB = new DoctorScheduleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get appointment ID from the request
        String appointmentId = request.getParameter("appointmentId");
        Appointment appointment = appointmentDB.get(appointmentId);
        
        if (appointment != null) {
            appointment.setStatus("Canceled");
            appointment.setUpdateAt(Date.valueOf(LocalDate.now())); 
            
            DoctorSchedule doctorSchedule = dsDB.get( String.valueOf(appointment.getDoctorSchedule().getId()));
            
            // Update the appointment status in the database
            doctorSchedule.setAvailable(true);
            dsDB.update(doctorSchedule);
            appointmentDB.update(appointment);
        }

        // Redirect back to the appointment list page
        response.sendRedirect(request.getContextPath() + "/appointment/list");
    }
}
