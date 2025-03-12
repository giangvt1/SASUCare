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
import java.util.List;

public class AppointmentManagementController extends BaseRBACController {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorDBContext doctordb = new DoctorDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        // Lấy bác sĩ đang đăng nhập
        Doctor loggedDoctor = doctordb.getDoctorByUsername(logged.getUsername()); // Giả sử người dùng có phương thức getDoctor() trả về đối tượng Doctor
        if (loggedDoctor == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User does not have an associated doctor.");
            return;
        }

        // Lấy ngày hiện tại để xác định hôm nay
        java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());

        // Lấy các danh sách cuộc hẹn cho bác sĩ này
        List<Appointment> todayAppointments = appointmentDB.getAppointmentsByDateAndDoctor(currentDate, loggedDoctor.getId());
        List<Appointment> pendingAppointments = appointmentDB.getAppointmentsByStatusAndDoctor("Pending", loggedDoctor.getId());
        List<Appointment> upcomingAppointments = appointmentDB.getUpcomingAppointmentsByDoctor(currentDate, loggedDoctor.getId());

        // Đặt các đối tượng vào request để sử dụng trong JSP
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("upcomingAppointments", upcomingAppointments);
        request.setAttribute("currentDate", currentDate);

        // Forward dữ liệu sang JSP
        request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
