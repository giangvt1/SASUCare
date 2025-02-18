/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Date;
import model.Application;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class SendApplication extends BaseRBACController {

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
            out.println("<title>Servlet SendApplication</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendApplication at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        int did = Integer.parseInt(request.getParameter("did"));
        String name = request.getParameter("name");
        String reason = request.getParameter("reason");

// Lấy ngày từ form hoặc dùng ngày hiện tại
// Tạo ngày hiện tại dạng java.util.Date
        java.util.Date utilDate = new java.util.Date();

// Chuyển đổi sang java.sql.Date
        java.sql.Date date = new java.sql.Date(utilDate.getTime()); // Chuyển đổi đúng cách sang java.sql.Date

// Tạo đối tượng Application và gán các giá trị
        Application a = new Application();
        a.setDid(did);
        a.setName(name);
        a.setReason(reason);
        a.setDate(date);  // Trực tiếp sử dụng date là java.sql.Date

// Gọi phương thức để tạo ứng dụng
        DoctorDBContext d = new DoctorDBContext();
        boolean isCreated = d.createApplicationForDid(a);

        if (isCreated) {
            request.setAttribute("message", "Application sent successfully!");
        } else {
            request.setAttribute("message", "Failed to send application.");
        }

        request.getRequestDispatcher("SendApplication.jsp").forward(request, response);
    }

}
