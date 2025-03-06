package controller.HRController;

import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import com.google.gson.Gson;
import dao.DepartmentDBContext;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.Department;

public class HRApptManagementController extends HttpServlet {

    private final DepartmentDBContext departmentDB = new DepartmentDBContext();

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

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
        return;
    }
}
