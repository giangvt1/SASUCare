package controller.doctor;

import com.google.gson.Gson;
import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import dao.DoctorScheduleDBContext;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Doctor;
import model.DoctorSchedule;
import model.system.User;

public class DoctorCalendarController extends BaseRBACController {

    private final DoctorDBContext doctorDAO = new DoctorDBContext();
    private final DoctorScheduleDBContext scheduleDAO = new DoctorScheduleDBContext();
    private final Gson gson = new Gson();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy username từ đối tượng logged
        String username = logged.getUsername();
        // Lấy doctorId dựa trên staff_username
        int doctorId = doctorDAO.getDoctorIdByStaffUsername(username);
        if (doctorId == -1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found for username: " + username);
            return;
        }
        // Lấy đối tượng Doctor đầy đủ qua getDoctorById
        Doctor doctor = doctorDAO.getDoctorById(doctorId);

        // Tính toán tuần hiện tại: từ Monday đến Sunday
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // Sunday=1, Monday=2, ...
        int diff;
        if (dayOfWeek == Calendar.SUNDAY) {
            diff = 1; // Chọn Monday của tuần sau
        } else {
            diff = Calendar.MONDAY - dayOfWeek;
        }
        cal.add(Calendar.DAY_OF_MONTH, diff);
        Date weekStart = new Date(cal.getTimeInMillis());
        Calendar endCal = (Calendar) cal.clone();
        endCal.add(Calendar.DAY_OF_MONTH, 6);
        Date weekEnd = new Date(endCal.getTimeInMillis());

        // Lấy danh sách lịch của bác sĩ trong khoảng tuần đó
        List<DoctorSchedule> weeklySchedules = scheduleDAO.getSchedulesByDoctorBetweenDates(doctorId, weekStart, weekEnd);

        // Xây dựng danh sách event cho FullCalendar (xử lý mapping màu theo shiftId)
        List<Map<String, Object>> events = new ArrayList<>();
        Map<String, String> shiftColors = new HashMap<>();
        shiftColors.put("1", "#0d6efd");  // Blue
        shiftColors.put("2", "#198754");  // Green
        shiftColors.put("3", "#dc3545");  // Red
        shiftColors.put("4", "#ffc107");  // Yellow

        for (DoctorSchedule ds : weeklySchedules) {
            Map<String, Object> event = new HashMap<>();
            event.put("id", ds.getId());
            String timeStart = ds.getShift().getTimeStart().toString();
            String timeEnd = ds.getShift().getTimeEnd().toString();
            String startStr = ds.getScheduleDate().toString() + "T" + timeStart;
            String endStr = ds.getScheduleDate().toString() + "T" + timeEnd;
            event.put("start", startStr);
            event.put("end", endStr);
            event.put("allDay", false);
            // Tiêu đề chỉ hiển thị "K" kết hợp với shiftId
            String shiftIdStr = String.valueOf(ds.getShift().getId());
            event.put("title", "K" + shiftIdStr);
            // Thiết lập màu nền và viền dựa trên shiftColors
            String color = shiftColors.get(shiftIdStr);
            if (color == null) {
                color = "#0d6efd";
            }
            event.put("backgroundColor", color);
            event.put("borderColor", color);
            // Extended properties: chứa thông tin chi tiết ca (giờ)
            Map<String, Object> extendedProps = new HashMap<>();
            extendedProps.put("shiftTime", timeStart + " - " + timeEnd);
            extendedProps.put("shiftId", ds.getShift().getId());
            event.put("extendedProps", extendedProps);

            events.add(event);
        }
        String eventsJson = gson.toJson(events);

        // Đưa các dữ liệu cần thiết vào request attributes để render JSP
        request.setAttribute("doctor", doctor);
        request.setAttribute("weekStart", weekStart);
        request.setAttribute("weekEnd", weekEnd);
        request.setAttribute("weeklySchedules", weeklySchedules);
        request.setAttribute("doctorEventsJson", eventsJson);

        request.getRequestDispatcher("../doctor/DoctorCalendar.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
}
