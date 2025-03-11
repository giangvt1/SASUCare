package controller.HRController;

import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import com.google.gson.Gson;
import controller.systemaccesscontrol.BaseRBACController;
import dao.DepartmentDBContext;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.Department;
import model.system.User;
public class HRApptManagementController extends BaseRBACController {
    AppointmentDBContext appointmentDB = new AppointmentDBContext();
    DepartmentDBContext departmentDB = new DepartmentDBContext();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameters
        String name = request.getParameter("name");
        Date date = null;
        String dateStr = request.getParameter("date");
        if (dateStr != null && !dateStr.isEmpty()) {
            date = Date.valueOf(dateStr); // Convert string to Date
        }
        String status = request.getParameter("status");

        // Pagination parameters
        int pageIndex = request.getParameter("pageIndex") != null ? Integer.parseInt(request.getParameter("pageIndex")) : 1;
        int pageSize = 10;  // Define the page size here

        // Fetch filtered appointments with pagination
        List<Appointment> appointments = appointmentDB.getFilteredAppointments(name, date, status, pageIndex, pageSize);
        List<Appointment> appointmentsTotal = appointmentDB.getFilteredAppointmentsTotals();

        // Calculate the total number of pages
        int totalAppointments = appointmentDB.getFilteredAppointmentsCount(name, date, status);
        int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);

        // Set data in request scope
        request.setAttribute("appointments", appointments);
        request.setAttribute("appointmentsTotal", appointmentsTotal);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        // Fetch departments for filter
        List<Department> departments = departmentDB.list();
        request.setAttribute("departments", departments);

        // Forward to JSP
        request.getRequestDispatcher("/hr/hr_appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//
//        // Get appointment ID and new status from the request
//        String appointmentId = request.getParameter("appointmentId");
//        String newStatus = request.getParameter("status");
//
//        PrintWriter out = response.getWriter();
//        Gson gson = new Gson();
//
//        Appointment appointment = appointmentDB.get(appointmentId);
//
//        if (appointment != null) {
//            appointment.setStatus("Canceled");
//            appointment.setUpdateAt(Date.valueOf(LocalDate.now()));
//
//            // Update the appointment status in the database
//            appointmentDB.update(appointment);
//            boolean isUpdated = true;
//            // Send JSON response
//            out.print(gson.toJson(new ApiResponse(isUpdated, isUpdated ? "Status updated successfully" : "Failed to update status")));
//        } else {
//            out.print(gson.toJson(new ApiResponse(false, "Invalid parameters")));
//        }
//
//        out.flush();
    }

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private static class ApiResponse {

        boolean success;
        String message;

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}
