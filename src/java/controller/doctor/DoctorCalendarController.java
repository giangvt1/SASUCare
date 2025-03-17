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

        String action = request.getParameter("action");
        if ("getEvents".equals(action)) {
            // Gọi hàm handleGetEvents() để trả về JSON cho FullCalendar
            handleGetEvents(request, response, logged);
        } else {
            // Mặc định: hiển thị trang JSP kèm table "tuần hiện tại"
            handleShowWeeklyTable(request, response, logged);
        }
    }

    private void handleShowWeeklyTable(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy username
        String username = logged.getUsername();
        // Lấy doctorId dựa trên staff_username
        int doctorId = doctorDAO.getDoctorIdByStaffUsername(username);
        if (doctorId == -1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found for username: " + username);
            return;
        }
        // Lấy đối tượng Doctor đầy đủ
        Doctor doctor = doctorDAO.getDoctorById(doctorId);

        // Tính toán tuần hiện tại (Monday -> Sunday)
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // Sunday=1, Monday=2, ...
        int diff;
        if (dayOfWeek == Calendar.SUNDAY) {
            diff = 1; 
        } else {
            diff = Calendar.MONDAY - dayOfWeek;
        }
        cal.add(Calendar.DAY_OF_MONTH, diff);
        Date weekStart = new Date(cal.getTimeInMillis());
        Calendar endCal = (Calendar) cal.clone();
        endCal.add(Calendar.DAY_OF_MONTH, 6);
        Date weekEnd = new Date(endCal.getTimeInMillis());

        // Lấy danh sách lịch của bác sĩ trong khoảng tuần đó
        List<DoctorSchedule> weeklySchedules =
                scheduleDAO.getSchedulesByDoctorBetweenDates(doctorId, weekStart, weekEnd);

        // Xây dựng JSON events (chỉ để table? Thực ra table có sẵn weeklySchedules)
        // ...
        // Thực hiện forward sang JSP
        request.setAttribute("doctor", doctor);
        request.setAttribute("weekStart", weekStart);
        request.setAttribute("weekEnd", weekEnd);
        request.setAttribute("weeklySchedules", weeklySchedules);

        // Ở table view, ta chỉ hiển thị 1 tuần. Ở Calendar view, ta sẽ load AJAX => do not rely on events JSON
        // -> Có thể set 1 JSON rỗng hoặc tùy ý
        request.setAttribute("doctorEventsJson", "[]");

        request.getRequestDispatcher("../doctor/DoctorCalendar.jsp").forward(request, response);
    }

    /**
     * Trả về JSON event list cho khoảng thời gian [start, end] do FullCalendar yêu cầu.
     */
    private void handleGetEvents(HttpServletRequest request, HttpServletResponse response, User logged)
            throws IOException {
        // Lấy username => doctorId
        String username = logged.getUsername();
        int doctorId = doctorDAO.getDoctorIdByStaffUsername(username);
        if (doctorId == -1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found for username: " + username);
            return;
        }
        // Parse start, end
        String startParam = request.getParameter("start");
        String endParam = request.getParameter("end");
        if (startParam == null || endParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing start or end param");
            return;
        }
        Date startDate = Date.valueOf(startParam);
        Date endDate = Date.valueOf(endParam);

        // Lấy lịch trong khoảng [startDate, endDate]
        List<DoctorSchedule> schedules =
                scheduleDAO.getSchedulesByDoctorBetweenDates(doctorId, startDate, endDate);

        // Build JSON
        List<Map<String, Object>> events = new ArrayList<>();
        for (DoctorSchedule ds : schedules) {
            Map<String, Object> event = new HashMap<>();
            event.put("id", ds.getId());
            String timeStart = ds.getShift().getTimeStart().toString();
            String timeEnd = ds.getShift().getTimeEnd().toString();
            String startStr = ds.getScheduleDate().toString() + "T" + timeStart;
            String endStr = ds.getScheduleDate().toString() + "T" + timeEnd;
            event.put("start", startStr);
            event.put("end", endStr);
            event.put("allDay", false);
            event.put("title", "K" + ds.getShift().getId());

            Map<String, Object> extendedProps = new HashMap<>();
            extendedProps.put("shiftTime", timeStart + " - " + timeEnd);
            extendedProps.put("shiftId", ds.getShift().getId());
            if (ds.getAppointment() != null) {
                extendedProps.put("appointmentId", ds.getAppointment().getId());
                extendedProps.put("appointmentStatus", ds.getAppointment().getStatus());
                extendedProps.put("customerName", ds.getAppointment().getCustomer().getFullname());
            }
            event.put("extendedProps", extendedProps);
            events.add(event);
        }

        String json = gson.toJson(events);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
}
