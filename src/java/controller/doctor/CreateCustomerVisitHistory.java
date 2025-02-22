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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.Customer;
import model.MedicalHistory;
import model.VisitHistory;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class CreateCustomerVisitHistory extends BaseRBACController {

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
            out.println("<title>Servlet CreateCustomerVisitHistory</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateCustomerVisitHistory at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cid = request.getParameter("cid");
        request.setAttribute("cid", cid);
        request.getRequestDispatcher("CreateCustomerVisitHistory.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String did = request.getParameter("did");
        String cid = request.getParameter("cid");
        // Sử dụng ngày hiện tại làm visitDate
        String reasonForVisit = request.getParameter("reasonForVisit");
        String diagnoses = request.getParameter("diagnoses");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String nextAppointmentStr = request.getParameter("nextAppointment");

        // Tạo ngày hiện tại dạng java.util.Date
        java.util.Date utilDate = new java.util.Date();

        java.sql.Date visitDate = new java.sql.Date(utilDate.getTime());

        java.sql.Date nextAppointment = null;
        if (nextAppointmentStr != null && !nextAppointmentStr.isEmpty()) {
            try {
                nextAppointment = java.sql.Date.valueOf(nextAppointmentStr);
            } catch (IllegalArgumentException e) {
                nextAppointment = null;
            }
        }

        VisitHistory visitHistory = new VisitHistory();
        visitHistory.setDid(Integer.parseInt(did));
        visitHistory.setCid(Integer.parseInt(cid));
        visitHistory.setVisitDate(visitDate);
        visitHistory.setReasonForVisit(reasonForVisit);
        visitHistory.setDiagnoses(diagnoses);
        visitHistory.setTreatmentPlan(treatmentPlan);
        visitHistory.setNextAppointment(nextAppointment);
        // Gọi DAO để thêm bản ghi
        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = customerDB.createVisitHistory(visitHistory);

        // Thông báo kết quả
        if (isCreated) {
            request.setAttribute("message", "Medical history created successfully!");
        } else {
            request.setAttribute("message", "Failed to create medical history.");
        }
        response.sendRedirect("ShowCustomerMedicalDetail?cid=" + cid);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
