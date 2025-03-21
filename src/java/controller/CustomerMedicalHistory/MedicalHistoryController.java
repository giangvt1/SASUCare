package controller.CustomerMedicalHistory;

import dao.CustomerDBContext;
import dao.DoctorDBContext;
import dao.VisitHistoryDBContext;
import model.VisitHistory;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.Doctor;

@WebServlet("/customer/medical-history")
public class MedicalHistoryController extends HttpServlet {

    private final CustomerDBContext customerDB = new CustomerDBContext();
    private final VisitHistoryDBContext visitHistoryDB = new VisitHistoryDBContext();
    private final DoctorDBContext docdb = new DoctorDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/Home.jsp");
            return;
        }

        int customerId = customer.getId();
        String doctorId = request.getParameter("doctorId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String sortDirection = request.getParameter("sortDirection") != null ? request.getParameter("sortDirection") : "desc"; // Default sorting order

        List<Doctor> doctors = docdb.getAllDoctors();

        // Handle pagination
        int currentPage = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        // Get visit histories based on filters
        List<VisitHistory> visitHistoryList = visitHistoryDB.getVisitHistoriesByCustomerId(customerId, doctorId, startDate, endDate, sortDirection);

        // Get customer details to display on the page
//        Customer customer = customerDB.getCustomerById(customerId);

        // Get total count for pagination (optional - if you want to show total pages)
        int totalCount = visitHistoryDB.getVisitHistoryCountByCustomerId(customerId, doctorId, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // Set data to request attributes
        request.setAttribute("doctors", doctors);
        request.setAttribute("visitHistoryList", visitHistoryList);
        request.setAttribute("customer", customer);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward the request to the JSP page for rendering
        request.getRequestDispatcher("/customer/medical-history.jsp").forward(request, response);
    }
}
