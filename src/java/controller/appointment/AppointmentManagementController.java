package controller.appointment;

import controller.systemaccesscontrol.BaseRBACController;
import dao.AppointmentDBContext;
import dao.DoctorDBContext;
import dao.UserDBContext;
import model.Appointment;
import model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.User;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class AppointmentManagementController extends BaseRBACController {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorDBContext doctordb = new DoctorDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {

        // Get current date
        LocalDate currentDate = LocalDate.now();
        int selectedMonth = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : currentDate.getMonthValue();
        int selectedYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : currentDate.getYear();

        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("selectedYear", selectedYear);

        // Lấy bác sĩ đang đăng nhập
        Doctor loggedDoctor = doctordb.getDoctorByUsername(logged.getUsername());
        if (loggedDoctor == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User does not have an associated doctor.");
            return;
        }

        Date today = Date.valueOf(currentDate);

//     ?  Date today = Date.valueOf(LocalDate.of(2025, 3, 4)); // Correct format

        List<Appointment> todayAppointments = appointmentDB.getAppointmentsByDateAndDoctor(today, loggedDoctor.getId(), "and status = 'Confirmed'");
        List<Appointment> wattingAppointment = appointmentDB.getAppointmentsByDateRangeAndDoctor(loggedDoctor.getId(), 3, "and status = 'Confirmed'");
        
        // Đặt các đối tượng vào request để sử dụng trong JSP
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("waittingAppointment", wattingAppointment);
        request.setAttribute("docID", loggedDoctor.getId());
        request.setAttribute("currentDate", currentDate);

        // Forward dữ liệu sang JSP
        request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
