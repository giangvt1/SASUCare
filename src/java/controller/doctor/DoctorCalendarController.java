package controller.doctor;

import com.google.gson.Gson;
import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import dao.DoctorScheduleDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Calendar;
import model.Doctor;
import model.DoctorSchedule;
import model.system.User;

public class DoctorCalendarController extends BaseRBACController {

    private final DoctorDBContext doctorDAO = new DoctorDBContext();
    private final DoctorScheduleDBContext scheduleDAO = new DoctorScheduleDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy username từ đối tượng logged
        String username = logged.getUsername();
        // Lấy doctorId dựa trên staff_username (dùng hàm getDoctorIdByStaffUsername)
        int doctorId = doctorDAO.getDoctorIdByStaffUsername(username);
        if (doctorId == -1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found for username: " + username);
            return;
        }
        // Lấy đối tượng Doctor đầy đủ qua getDoctorById
        Doctor doctor = doctorDAO.getDoctorById(doctorId);

        // Tính toán tuần hiện tại: từ Monday đến Sunday
        Calendar cal = Calendar.getInstance();
        // Lấy ngày hiện tại
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        // Tính số ngày cần trừ để về Monday
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // Sunday=1, Monday=2, ...
        // Nếu hiện tại là Sunday, ta sẽ xem nó là cuối tuần => chuyển về Monday của tuần trước hoặc sau
        int diff;
        if(dayOfWeek == Calendar.SUNDAY){
            diff = 1; // Chọn Monday của tuần sau
        } else {
            diff = Calendar.MONDAY - dayOfWeek;
        }
        cal.add(Calendar.DAY_OF_MONTH, diff);
        Date weekStart = new Date(cal.getTimeInMillis());
        // Tạo một Calendar copy để tính weekEnd (Sunday = weekStart + 6 ngày)
        Calendar endCal = (Calendar) cal.clone();
        endCal.add(Calendar.DAY_OF_MONTH, 6);
        Date weekEnd = new Date(endCal.getTimeInMillis());

        // Lấy danh sách lịch của bác sĩ trong khoảng tuần đó
        List<DoctorSchedule> weeklySchedules = scheduleDAO.getSchedulesByDoctorBetweenDates(doctorId, weekStart, weekEnd);

        // Đưa các dữ liệu cần thiết vào request attributes để render trong JSP
        request.setAttribute("doctor", doctor);
        request.setAttribute("weekStart", weekStart);
        request.setAttribute("weekEnd", weekEnd);
        request.setAttribute("weeklySchedules", weeklySchedules);

        request.getRequestDispatcher("../doctor/DoctorCalendar.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Không dùng POST cho chức năng xem lịch của bác sĩ
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
}
