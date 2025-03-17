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
import java.util.List;
import model.Invoice;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class InvoiceManagementController extends BaseRBACController {

    private InvoiceDBContext invoiceDAO = new InvoiceDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        List<Invoice> invoiceList = invoiceDAO.getAllInvoices();
        request.setAttribute("invoiceList", invoiceList);
        request.getRequestDispatcher("../finance/invoiceManagement.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
