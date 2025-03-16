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

@WebServlet("/visit-details/*")  // Handle request with visitId in the URL
public class VisitDetailsServlet extends HttpServlet {
    private VisitHistoryDBContext visitHistoryDB = new VisitHistoryDBContext();

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

            // Convert the VisitHistory object to JSON
            Gson gson = new Gson();
            String visitJson = gson.toJson(visit);

            // Set the response type to application/json
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Send the JSON response
            response.getWriter().write(visitJson);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving visit details");
        }
    }
}
