/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.financial;

import controller.systemaccesscontrol.BaseRBACController;
import dao.InvoiceDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.util.List;
import model.InvoiceRevenue;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class InvoiceRevenueChartController extends BaseRBACController {

    private InvoiceDBContext invoiceDAO = new InvoiceDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy tham số lọc (nếu có)
        String startParam = request.getParameter("startDate");
        String endParam = request.getParameter("endDate");
        
        // Nếu không có, sử dụng giá trị mặc định
        Date startDate = (startParam != null && !startParam.trim().isEmpty())
                ? Date.valueOf(startParam.trim())
                : Date.valueOf("2025-01-01"); // mặc định bắt đầu từ đầu năm
        Date endDate = (endParam != null && !endParam.trim().isEmpty())
                ? Date.valueOf(endParam.trim())
                : new Date(System.currentTimeMillis());
        
        // Lấy doanh thu theo tháng từ DAO
        List<InvoiceRevenue> revenueList = invoiceDAO.getInvoiceRevenueByMonth(startDate, endDate);
        
        // Đưa dữ liệu và tham số lọc ra JSP
        request.setAttribute("revenueList", revenueList);
        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate", endDate.toString());
        
        request.getRequestDispatcher("../finance/invoiceRevenueChart.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
