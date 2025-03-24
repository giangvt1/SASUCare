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
import model.Appointment;
import model.Customer;
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
        // Lấy đối tượng Doctor đầy đủ
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
            diff = 1; // Nếu là Chủ Nhật, chuyển sang Monday của tuần sau
        } else {
            diff = Calendar.MONDAY - dayOfWeek;
        }
        cal.add(Calendar.DAY_OF_MONTH, diff);
        Date weekStart = new Date(cal.getTimeInMillis());
        Calendar endCal = (Calendar) cal.clone();
        endCal.add(Calendar.DAY_OF_MONTH, 6);
        Date weekEnd = new Date(endCal.getTimeInMillis());

        // Lấy danh sách lịch của bác sĩ trong khoảng tuần đó (bao gồm thông tin appointment nếu có)
        List<DoctorSchedule> weeklySchedules = scheduleDAO.getSchedulesByDoctorBetweenDates(doctorId, weekStart, weekEnd);

        // Xây dựng danh sách event cho FullCalendar
        List<Map<String, Object>> events = new ArrayList<>();
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
            // Ví dụ title: "K" + shiftId
            event.put("title", "K" + ds.getShift().getId());
            
            // Xây dựng extendedProps chứa các thông tin chi tiết của ca, bao gồm thông tin appointment nếu có
            Map<String, Object> extendedProps = new HashMap<>();
            extendedProps.put("shiftTime", timeStart + " - " + timeEnd);
            extendedProps.put("shiftId", ds.getShift().getId());
            if(ds.getAppointment() != null) {
                extendedProps.put("appointmentId", ds.getAppointment().getId());
                extendedProps.put("appointmentStatus", ds.getAppointment().getStatus());
                // Giả sử Customer trong Appointment có getter getFullname()
                extendedProps.put("customerName", ds.getAppointment().getCustomer().getFullname());
            }
            event.put("extendedProps", extendedProps);
            events.add(event);
        }
        String eventsJson = gson.toJson(events);

        // Đưa các dữ liệu cần thiết vào request attributes để JSP render
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
