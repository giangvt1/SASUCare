/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.CustomerMedicalHistory;

import dao.VisitHistoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.Customer;
import model.VisitHistory;

/**
 *
 * @author Golden Lightning
 */
@WebServlet("/customer/medical-history/export")
public class ExportMedicalVisitServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");

        String format = request.getParameter("format"); // Can be 'csv'

        if (format == null || format.isEmpty()) {
            format = "csv"; // Default format
        }

        // Create DAO and get filtered medical visits
        VisitHistoryDBContext medicalVisitDAO = new VisitHistoryDBContext();
        List<VisitHistory> visits = medicalVisitDAO.getVisitHistoriesByCustomerId(customer.getId(), null, null, null, null);

        // Export based on format
        if ("csv".equalsIgnoreCase(format)) {
            exportToCSV(response, visits);
        } else {
            // Handle other formats (e.g., Excel) if needed
        }
    }

    private void exportToCSV(HttpServletResponse response, List<VisitHistory> visits)
            throws IOException {
        // Set response headers for CSV
        response.setContentType("text/csv");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String fileName = "medical_visits_export_" + dateFormat.format(new Date()) + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

        // Write CSV data
        StringBuilder csv = new StringBuilder();

        // Add header
        csv.append("Visit ID,Doctor Name,Visit Date,Reason for Visit,Diagnoses,Treatment Plan,Note\n");

        // Add data rows
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        for (VisitHistory visit : visits) {
            csv.append(visit.getId()).append(",");
            csv.append(visit.getDoctorId()).append(",");
            csv.append(visit.getVisitDate() != null ? sdf.format(visit.getVisitDate()) : "").append(",");
            csv.append(visit.getReasonForVisit()).append(",");
            csv.append(visit.getDiagnoses()).append(",");
            csv.append(visit.getTreatmentPlan()).append(",");
//            csv.append(visit.get() != null ? sdf.format(visit.getNextAppointment()) : "N/A").append(",");
            csv.append(visit.getNote() == null || visit.getNote().trim().isEmpty() ? "Na" : visit.getNote())
                    .append("\n");

        }

        // Write to response output stream
        response.getWriter().write(csv.toString());
    }
}
