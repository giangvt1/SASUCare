/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
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

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ShowCustomerMedicalDetail</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowCustomerMedicalDetail at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
// Lấy Customer ID từ request
        String cid = request.getParameter("cid");
        CustomerDBContext customerDB = new CustomerDBContext();

        if (cid != null) {
            try {
                // Lấy thông tin khách hàng theo ID
                Customer customer = customerDB.getCustomerById(Integer.parseInt(cid));

                // Lấy lịch sử bệnh án của khách hàng
                ArrayList<MedicalHistory> medicalHistory = customerDB.showMedicalHistory(Integer.parseInt(cid));

                // Lấy tham số phân trang từ request
                String pageParam = request.getParameter("page");
                int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1; // Mặc định trang 1 nếu không có tham số

                // Lấy danh sách Visit History có phân trang
                ArrayList<VisitHistory> visitHistoryList = customerDB.getVisitHistoriesByCustomerIdPaginated(Integer.parseInt(cid), currentPage);

                // Kiểm tra có dữ liệu cho trang tiếp theo không
                int nextPageSize = customerDB.getVisitHistoriesByCustomerIdPaginated(Integer.parseInt(cid), currentPage + 1).size();
                boolean hasNextPage = nextPageSize > 0;

                // Truyền dữ liệu sang JSP
                request.setAttribute("customer", customer);
                request.setAttribute("medicalHistory", medicalHistory);
                request.setAttribute("visitHistoryList", visitHistoryList);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("hasNextPage", hasNextPage);

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
