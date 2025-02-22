/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import model.Customer;
import model.system.User;

public class SearchCustomer extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String customerNameStr = request.getParameter("customerName");
        String customerName = null;
        if (customerNameStr != null) {
            customerNameStr = customerNameStr.trim().replaceAll("\\s+", " ");
            customerNameStr = customerNameStr.replace(" ", "%");
            customerName = customerNameStr;
        }
        String customerDateStr = request.getParameter("customerDate");
        String customerGenderStr = request.getParameter("customerGender");
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");
        String sort = "default";
        int sizeOfEachTable = 10;
        Date customerDate = null;
        if (customerDateStr != null && !customerDateStr.isEmpty()) {
            try {
                customerDate = java.sql.Date.valueOf(customerDateStr);
            } catch (IllegalArgumentException e) {
                customerDate = null;
            }
        }

        Boolean customerGender = null;
        if (customerGenderStr != null && !customerGenderStr.isEmpty()) {
            customerGender = customerGenderStr.equalsIgnoreCase("male") ? true : false;
        }

        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (sortStr != null) {
            sort = sortStr;
        }
        if (sizeStr != null) {
            sizeOfEachTable = Integer.parseInt(sizeStr);
        }
        CustomerDBContext customerDB = new CustomerDBContext();
        ArrayList<Customer> resultLists = customerDB.searchCustomerInMedical(customerName, (java.sql.Date) customerDate, customerGender, page, sort, sizeOfEachTable);
        int totalCustomers = customerDB.countCustomerInMedical(customerName, (java.sql.Date) customerDate, customerGender);
        int totalPages = (int) Math.ceil((double) totalCustomers / sizeOfEachTable);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("customers", resultLists);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("SearchCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
