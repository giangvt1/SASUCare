package controller.CustomerMedicalHistory;

import dao.VisitHistoryDBContext;
import model.VisitHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;  // Import Gson for JSON serialization
import dao.AppointmentDBContext;
import dao.DoctorDBContext;
import java.util.HashMap;
import java.util.Map;
import model.Appointment;
import model.Doctor;

@WebServlet("/visit-details/*")  // Handle request with visitId in the URL
public class VisitDetailsServlet extends HttpServlet {

    private VisitHistoryDBContext visitHistoryDB = new VisitHistoryDBContext();
    private DoctorDBContext doctorDBContext = new DoctorDBContext();
    private AppointmentDBContext appointdb = new AppointmentDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Extract visitId from the URL pattern
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Visit ID is required");
                return;
            }

            int visitId = Integer.parseInt(pathInfo.substring(1));  // Extract visitId

            // Get the visit details from the database
            VisitHistory visit = visitHistoryDB.getVisitHistoryById(visitId);

            if (visit == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Visit not found");
                return;
            }
            Doctor doctor = doctorDBContext.getDoctorById(visit.getDoctorId());

            Gson gson = new Gson();
            Map<String, Object> data = new HashMap<>();
            data.put("visit", visit);
            data.put("doctor", doctor); // doctor bạn lấy từ DB theo visit.getDoctorId()
//            data.put("appointment", appointment);

            String json = gson.toJson(data);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving visit details");
        }
    }
}
