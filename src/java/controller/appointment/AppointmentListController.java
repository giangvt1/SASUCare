package controller.appointment;

import dao.AppointmentDBContext;
import model.Appointment;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AppointmentListController extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/Home.jsp");
            return;
        }

        // Get filters from request
        String doctorName = request.getParameter("doctorName");

        if (doctorName != null) {
            doctorName = doctorName.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }
        String status = request.getParameter("status");
        boolean sortAsc = "asc".equals(request.getParameter("sortOrder"));

        // Fetch filtered appointments
        List<Appointment> appointments = appointmentDB.getAppointmentsByFilters(
                customer.getFullname(), doctorName, status, sortAsc);

        // Send data to JSP
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/appointment/appointment_list.jsp").forward(request, response);
    }
}
