/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customermanagement;

import dao.MedicalRecordDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Customer;
import model.MedicalRecord;

/**
 *
 * @author ngoch
 */
@WebServlet(name="ChooseRecordController", urlPatterns={"/listrecord"})
public class ChooseRecordController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        MedicalRecordDBContext dao = new MedicalRecordDBContext();
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
//        
        ArrayList<MedicalRecord> records = dao.listByCustomerId(customer.getId());
//        
        session.setAttribute("records", records);
        System.out.println("record: " + records);
        
        request.getRequestDispatcher("./customer/listrecords.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    }

}
