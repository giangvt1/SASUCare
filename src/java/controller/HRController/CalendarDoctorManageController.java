package controller.HRController;

import com.google.gson.Gson;
import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import dao.DoctorScheduleDBContext;
import dao.ShiftDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;
import model.system.User;

/**
 * Controller quản lý lịch của bác sĩ
 */
public class CalendarDoctorManageController extends BaseRBACController {

    private final DoctorDBContext doctorDAO = new DoctorDBContext();
    private final DoctorScheduleDBContext scheduleDAO = new DoctorScheduleDBContext();
    private final ShiftDBContext shiftDAO = new ShiftDBContext();
    private final Gson gson = new Gson();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            // Load giao diện ban đầu với danh sách bác sĩ và ca làm việc
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            List<Shift> shifts = shiftDAO.getAllShifts();
            request.setAttribute("doctors", doctors);
            request.setAttribute("shifts", shifts);
            request.getRequestDispatcher("../hr/CalendarManage.jsp").forward(request, response);
        } else {
            switch (action) {
                case "getEvents":
                    handleGetEvents(request, response);
                    break;
                case "getDoctors":
                    handleGetDoctors(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "assignShift":
                handleAssignShift(request, response);
                break;
            case "updateShift":
                handleUpdateShift(request, response);
                break;
            case "deleteShift":
                handleDeleteShift(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleGetEvents(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String startDate = request.getParameter("start");
        String endDate = request.getParameter("end");

        List<DoctorSchedule> schedules = scheduleDAO.getSchedulesBetweenDates(
                Date.valueOf(startDate), Date.valueOf(endDate));

        // Chuyển đổi mỗi DoctorSchedule thành một event cho FullCalendar
        List<Map<String, Object>> events = new ArrayList<>();
        for (DoctorSchedule ds : schedules) {
            Map<String, Object> event = new HashMap<>();
            event.put("id", ds.getId());
            // Giả sử ds.getShift() trả về đối tượng Shift có getTimeStart() và getTimeEnd()
            String shiftTime = ds.getShift().getTimeStart().toString() + " - " + ds.getShift().getTimeEnd().toString();
            event.put("title", shiftTime);
            event.put("start", ds.getScheduleDate().toString());
            // Bao gồm thông tin bác sĩ trong extendedProps
            Map<String, Object> ext = new HashMap<>();
            ext.put("doctor", ds.getDoctor());
            ext.put("shiftTime", shiftTime);
            ext.put("shiftId", ds.getShift().getId());
            event.put("extendedProps", ext);
            events.add(event);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(events));
        }
    }

    private void handleGetDoctors(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(doctors));
        }
    }

    private void handleAssignShift(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int shiftId = Integer.parseInt(request.getParameter("shiftType"));
            Date shiftDate = Date.valueOf(request.getParameter("shiftDate"));
            int cycle = 0;
            if (request.getParameter("cycle") != null) {
                cycle = Integer.parseInt(request.getParameter("cycle"));
            }

            // Kiểm tra nếu cycle > 0, bắt buộc shiftDate là Thứ Tư
            if (cycle > 0) {
                java.util.Calendar c = java.util.Calendar.getInstance();
                c.setTime(shiftDate);
                // Trong Java, Sunday=1, Monday=2, Tuesday=3, WEDNESDAY=4, ...
                // => Dùng c.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY
                if (c.get(java.util.Calendar.DAY_OF_WEEK) != java.util.Calendar.WEDNESDAY) {
                    // Trả về failed
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "Bạn phải chọn ngày gốc là Thứ Tư khi lặp lại!");

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    try (PrintWriter out = response.getWriter()) {
                        out.print(gson.toJson(result));
                    }
                    return; // Kết thúc
                }
            }

            // Nếu qua kiểm tra, thực hiện logic assign
            boolean overallSuccess = false;
            if (cycle > 0) {
                overallSuccess = handleRecurrenceAssign(doctorId, shiftDate, shiftId, cycle);
            } else {
                overallSuccess = scheduleDAO.assignShift(doctorId, shiftDate, shiftId);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", overallSuccess);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(result));
            }
        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }

    private boolean handleRecurrenceAssign(int doctorId, Date shiftDate, int shiftId, int cycle) {
        boolean overallSuccess = false;
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(shiftDate);
        java.util.Calendar endCal = java.util.Calendar.getInstance();
        endCal.setTime(shiftDate);
        endCal.add(java.util.Calendar.MONTH, cycle);

        Date currentDate = shiftDate;
        while (!currentDate.after(new Date(endCal.getTimeInMillis()))) {
            boolean success = scheduleDAO.assignShift(doctorId, currentDate, shiftId);
            overallSuccess = overallSuccess || success;
            cal.add(java.util.Calendar.DAY_OF_MONTH, 7);
            currentDate = new Date(cal.getTimeInMillis());
        }
        return overallSuccess;
    }

    private void handleUpdateShift(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            int shiftId = Integer.parseInt(request.getParameter("shiftType")); // shift id từ request
            Date shiftDate = Date.valueOf(request.getParameter("shiftDate"));

            boolean success = scheduleDAO.updateShift(scheduleId, shiftDate, shiftId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(result));
            }
        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }

    private void handleDeleteShift(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

            boolean success = scheduleDAO.deleteShift(scheduleId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(result));
            }
        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }
}
