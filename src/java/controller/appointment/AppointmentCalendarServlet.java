package controller.appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
//import controller.authentication.BaseRBACController;
import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
//import model.auth.User;

public class AppointmentCalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Get current date
        LocalDate currentDate = LocalDate.now();
        int selectedMonth = req.getParameter("month") != null ? Integer.parseInt(req.getParameter("month")) : currentDate.getMonthValue();
        int selectedYear = req.getParameter("year") != null ? Integer.parseInt(req.getParameter("year")) : currentDate.getYear();

        req.setAttribute("selectedMonth", selectedMonth);
        req.setAttribute("selectedYear", selectedYear);

        req.getRequestDispatcher("/appointment/appointment-calendar.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
