/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customerService;

import dao.RatingDBContext;
import dao.RatingDBContext_Extended;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Rating;

/**
 *
 * @author admin
 */
@WebServlet(name="ManageDoctorReviewsServlet", urlPatterns={"/managereviews"})
public class ManageDoctorReviewsServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ManageDoctorReviewsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageDoctorReviewsServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        RatingDBContext_Extended ratingDB = new RatingDBContext_Extended();
        List<Rating> ratings = ratingDB.getAllRatings();
        request.setAttribute("ratings", ratings);
        request.getRequestDispatcher("manage_reviews.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        RatingDBContext_Extended ratingDB = new RatingDBContext_Extended();

        // Xóa đánh giá
        if ("delete".equals(action)) {
            int doctorId = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            ratingDB.deleteRating(doctorId, username);
        }
        // Thay đổi trạng thái hiển thị
        else if ("toggleVisibility".equals(action)) {
            int doctorId = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            boolean visible = Boolean.parseBoolean(request.getParameter("visible"));
            ratingDB.toggleVisibility(doctorId, username, visible);
        }

        // Sau khi thao tác xong, chuyển hướng lại trang quản lý đánh giá
        response.sendRedirect(request.getContextPath() + "/managereviews");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
