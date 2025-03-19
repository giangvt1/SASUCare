import com.google.gson.Gson;
import dao.DoctorScheduleDBContext;
import jakarta.mail.Session;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;

@WebServlet("/CheckAppointmentServlet")
public class CheckAppointmentServlet extends HttpServlet {
    DoctorScheduleDBContext dsDB = new DoctorScheduleDBContext();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        if (customer == null) {
            response.setContentType("text/html");
            response.getWriter().println("<script>"
                    + "alert('The user is not logged in. Please login.');"
                    + "window.history.back();"
                    + "</script>");
            return;
        }

        String doctorId = request.getParameter("doctorId");
        String shiftId = request.getParameter("shiftId");
        String scheduleDate = request.getParameter("scheduleDate");


        String resp = dsDB.checkExsistSchedule(customer.getId(), scheduleDate, doctorId, shiftId);
        response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(resp));
    }
    
}
