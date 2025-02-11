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
import java.util.Date;
import model.Customer;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class SearchCustomer extends BaseRBACController {

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
            out.println("<title>Servlet SearchCustomer</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchCustomer at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String customerName = request.getParameter("customerName").trim();
        if (customerName != null) {
            customerName = customerName.replaceAll("\\s+", " ");
            customerName = customerName.replace(" ", "%");
        }
        String customerDateStr = request.getParameter("customerDate");
        String customerGenderStr = request.getParameter("customerGender");
        String pageStr = request.getParameter("page"); // Lấy tham số page từ request

        // Chuyển đổi dữ liệu (nếu cần)
        Date customerDate = null;
        if (customerDateStr != null && !customerDateStr.isEmpty()) {
            try {
                customerDate = java.sql.Date.valueOf(customerDateStr);
            } catch (IllegalArgumentException e) {
                customerDate = null; // Xử lý lỗi nếu ngày không hợp lệ
            }
        }

        Boolean customerGender = null;
        if (customerGenderStr != null && !customerGenderStr.isEmpty()) {
            customerGender = customerGenderStr.equalsIgnoreCase("male") ? true : false;
        }

        // Xử lý tham số page, mặc định là 1 nếu không có hoặc không hợp lệ
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1; // Giữ mặc định là 1 nếu không hợp lệ
            }
        }

        // Gọi DAO để lấy danh sách khách hàng phù hợp
        CustomerDBContext customerDB = new CustomerDBContext();
        ArrayList<Customer> resultLists = customerDB.searchCustomerInMedical(customerName, (java.sql.Date) customerDate, customerGender, page);

        // Kiểm tra có dữ liệu cho trang tiếp theo không
        int nextPageSize = customerDB.searchCustomerInMedical(customerName, (java.sql.Date) customerDate, customerGender, page + 1).size();
        boolean hasNextPage = nextPageSize > 0;
        // Gửi danh sách khách hàng đến JSP
        request.setAttribute("customers", resultLists);
        request.setAttribute("currentPage", page); // Gửi thông tin trang hiện tại đến JSP để hiển thị
        request.setAttribute("hasNextPage", hasNextPage);
        request.getRequestDispatcher("ManageMedical.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
