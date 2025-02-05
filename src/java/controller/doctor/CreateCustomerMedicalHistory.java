/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

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

/**
 *
 * @author TRUNG
 */
public class CreateCustomerMedicalHistory extends HttpServlet {

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
            out.println("<title>Servlet CreateMedicalHistory</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateMedicalHistory at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("CreateCustomerMedicalHistory.jsp").forward(request, response);
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
        // Lấy các tham số từ form
        String cid = request.getParameter("cid");
        String name = request.getParameter("name");
        String detail = request.getParameter("detail");

        // Tạo đối tượng MedicalHistory từ dữ liệu form
        MedicalHistory medicalH = new MedicalHistory();
        medicalH.setCid(Integer.parseInt(cid));
        medicalH.setName(name);
        medicalH.setDetail(detail);

        // Tạo đối tượng DBContext để lưu MedicalHistory vào cơ sở dữ liệu
        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = customerDB.createMedicalHistory(medicalH);

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

}
