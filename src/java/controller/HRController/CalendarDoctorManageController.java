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
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.*;
import model.Doctor;
import model.DoctorSchedule;
import model.Shift;
import model.system.User;

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
            // Hiển thị trang CalendarManage.jsp kèm danh sách bác sĩ và ca
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

    /**
     * Trả về JSON danh sách lịch (schedules) trong khoảng thời gian [start,
     * end].
     */
    private void handleGetEvents(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String startDate = request.getParameter("start");
        String endDate = request.getParameter("end");

        // Lấy danh sách lịch
        List<DoctorSchedule> schedules = scheduleDAO.getSchedulesBetweenDates(
                Date.valueOf(startDate), Date.valueOf(endDate));

        // Convert mỗi DoctorSchedule thành event cho FullCalendar
        List<Map<String, Object>> events = new ArrayList<>();
        for (DoctorSchedule ds : schedules) {
            Map<String, Object> event = new HashMap<>();
            event.put("id", ds.getId());

            String shiftTime = ds.getShift().getTimeStart().toString()
                    + " - " + ds.getShift().getTimeEnd().toString();
            event.put("title", shiftTime);
            event.put("start", ds.getScheduleDate().toString());

            Map<String, Object> ext = new HashMap<>();
            ext.put("doctor", ds.getDoctor());
            ext.put("shiftTime", shiftTime);
            ext.put("shiftId", ds.getShift().getId());
            event.put("extendedProps", ext);

            events.add(event);
        }

        // Trả về JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(gson.toJson(events));
    }

    /**
     * Trả về JSON danh sách bác sĩ.
     */
    private void handleGetDoctors(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(gson.toJson(doctors));
    }

    /**
     * Xử lý form submit "Assign Shift" (không trả về JSON). Nếu success ->
     * redirect về /hr/calendarmanage Nếu fail -> redirect về
     * /hr/calendarmanage?error=1 (ví dụ)
     */
    private void handleAssignShift(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            int shiftId = Integer.parseInt(request.getParameter("shiftType"));
            Date shiftDate = Date.valueOf(request.getParameter("shiftDate"));
            int cycle = 0;
            if (request.getParameter("cycle") != null) {
                cycle = Integer.parseInt(request.getParameter("cycle"));
            }

            System.out.println("handleAssignShift: doctorId=" + doctorId
                    + ", shiftId=" + shiftId
                    + ", shiftDate=" + shiftDate
                    + ", cycle=" + cycle);

            boolean overallSuccess;
            if (cycle > 0) {
                overallSuccess = handleRecurrenceAssign(doctorId, shiftDate, shiftId, cycle);
            } else {
                overallSuccess = scheduleDAO.assignShift(doctorId, shiftDate, shiftId);
                System.out.println("Single assignShift result: " + overallSuccess);
            }

            if (overallSuccess) {
                response.sendRedirect(request.getContextPath() + "/hr/calendarmanage?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/hr/calendarmanage?error=1");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/hr/calendarmanage?error=Exception");
        }
    }

    /**
     * Lặp qua từng tuần (cộng 7 ngày) trong cycle tháng để gán ca cho bác sĩ,
     * sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu.
     */
    private boolean handleRecurrenceAssign(int doctorId, Date shiftDate, int shiftId, int cycle) throws SQLException {
        boolean overallSuccess = false;
        Connection conn = scheduleDAO.connection;

        System.out.println("handleRecurrenceAssign: Connection=" + conn);

        conn.setAutoCommit(false);
        try {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(shiftDate);

            java.util.Calendar endCal = java.util.Calendar.getInstance();
            endCal.setTime(shiftDate);
            endCal.add(java.util.Calendar.MONTH, cycle);

            Date currentDate = shiftDate;
            System.out.println("handleRecurrenceAssign: Start date=" + shiftDate
                    + ", End date=" + new Date(endCal.getTimeInMillis()));

            while (!currentDate.after(new Date(endCal.getTimeInMillis()))) {
                boolean success = scheduleDAO.assignShift(doctorId, currentDate, shiftId);
                System.out.println("Assigning date " + currentDate + " => " + success);
                overallSuccess = overallSuccess || success;

                cal.add(java.util.Calendar.DAY_OF_MONTH, 7);
                currentDate = new Date(cal.getTimeInMillis());
            }
            conn.commit();
        } catch (SQLException ex) {
            conn.rollback();
            overallSuccess = false;
            ex.printStackTrace();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
        }
        System.out.println("handleRecurrenceAssign: Overall success = " + overallSuccess);
        return overallSuccess;
    }

    /**
     * Cập nhật Shift -> Trả về JSON
     */
    private void handleUpdateShift(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            int shiftId = Integer.parseInt(request.getParameter("shiftType"));
            Date shiftDate = Date.valueOf(request.getParameter("shiftDate"));

            boolean success = scheduleDAO.updateShift(scheduleId, shiftDate, shiftId);
            System.out.println("handleUpdateShift: scheduleId=" + scheduleId
                    + ", new date=" + shiftDate
                    + ", new shiftId=" + shiftId + " => " + success);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print(gson.toJson(result));

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }

    /**
     * Xóa Shift -> Trả về JSON
     */
    private void handleDeleteShift(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

            boolean success = scheduleDAO.deleteShift(scheduleId);
            System.out.println("handleDeleteShift: scheduleId=" + scheduleId + " => " + success);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print(gson.toJson(result));

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
        }
    }
}
