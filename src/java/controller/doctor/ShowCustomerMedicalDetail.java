package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Customer;
import model.MedicalHistory;
import model.VisitHistory;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class ShowCustomerMedicalDetail extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String cId = request.getParameter("cId");
        String pageVisitStr = request.getParameter("pageVisit");
        String pageMedicalStr = request.getParameter("pageMedical");

        int sizeOfMedicalEachTable = 10;
        int sizeOfVisitEachTable = 10;

        String sizeVisitStr = request.getParameter("sizeVisit");
        String sizeMedicalStr = request.getParameter("sizeMedical");

        if (sizeVisitStr != null && !sizeVisitStr.isEmpty()) {
            sizeOfVisitEachTable = Integer.parseInt(sizeVisitStr);
        }
        if (sizeMedicalStr != null && !sizeMedicalStr.isEmpty()) {
            sizeOfMedicalEachTable = Integer.parseInt(sizeMedicalStr);
        }

        int pageVisit = 1;
        if (pageVisitStr != null && !pageVisitStr.isEmpty()) {
            try {
                pageVisit = Integer.parseInt(pageVisitStr);
            } catch (NumberFormatException e) {
                pageVisit = 1;
            }
        }

        int pageMedical = 1;
        if (pageMedicalStr != null && !pageMedicalStr.isEmpty()) {
            try {
                pageMedical = Integer.parseInt(pageMedicalStr);
            } catch (NumberFormatException e) {
                pageMedical = 1;
            }
        }

        CustomerDBContext customerDB = new CustomerDBContext();
        if (cId != null) {
            try {
                // Lấy thông tin khách hàng theo ID
                Customer customer = customerDB.getCustomerById(Integer.parseInt(cId));

                // Lấy lịch sử bệnh án của khách hàng
                int currentMedicalPage = (pageMedicalStr != null) ? Integer.parseInt(pageMedicalStr) : 1;
                ArrayList<MedicalHistory> medicalHistory = customerDB.getMedicalHistoryByCustomerIdPaginated(Integer.parseInt(cId), currentMedicalPage, sizeOfMedicalEachTable);
                int totalMedicals = customerDB.getTotalMedicalHistoryCountByCustomerId(Integer.parseInt(cId));
                int totalMedicalPages = (int) Math.ceil((double) totalMedicals / sizeOfMedicalEachTable);

                // Lấy danh sách Visit History có phân trang
                int currentVisitPage = (pageVisitStr != null) ? Integer.parseInt(pageVisitStr) : 1;
                ArrayList<VisitHistory> visitHistoryList = customerDB.getVisitHistoriesByCustomerIdPaginated(Integer.parseInt(cId), currentVisitPage, sizeOfVisitEachTable);
                int totalVisits = customerDB.getVisitHistoryCountByCustomerId(Integer.parseInt(cId));
                int totalVisitPages = (int) Math.ceil((double) totalVisits / sizeOfVisitEachTable);

                // Truyền dữ liệu sang JSP
                request.setAttribute("customer", customer);
                request.setAttribute("totalMedicalPages", totalMedicalPages);
                request.setAttribute("totalVisitPages", totalVisitPages);
                request.setAttribute("medicalHistory", medicalHistory);
                request.setAttribute("visitHistoryList", visitHistoryList);
                request.setAttribute("currentMedicalPage", currentMedicalPage);
                request.setAttribute("currentVisitPage", currentVisitPage);

                // Điều hướng tới JSP
                request.getRequestDispatcher("CustomerMedicalDetail.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing data.");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Customer ID is required.");
        }
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}