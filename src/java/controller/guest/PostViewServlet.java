/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.guest;

import dao.PostDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Post;

/**
 *
 * @author admin
 */
@WebServlet(name="PostViewServlet", urlPatterns={"/viewPost"})
public class PostViewServlet extends HttpServlet {
   private final PostDAO postDAO = new PostDAO();
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
            out.println("<title>Servlet PostViewServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PostViewServlet at " + request.getContextPath () + "</h1>");
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
        String action = request.getParameter("action");
        List<Post> posts = null;

        // Xử lý tìm kiếm
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.isEmpty()) {
            posts = postDAO.search(keyword);
        }

        // Lọc theo trạng thái
        String statusParam = request.getParameter("status");
        if (statusParam != null) {
            boolean status = "1".equals(statusParam);
            posts = postDAO.filterByStatus(status);
        }

        // Sắp xếp theo ngày
        String sortDate = request.getParameter("sortDate");
        if ("asc".equals(sortDate)) {
            posts = postDAO.sortByDate(true); // Cũ nhất
        } else if ("desc".equals(sortDate)) {
            posts = postDAO.sortByDate(false); // Mới nhất
        }

        // Sắp xếp theo tiêu đề
        String sortTitle = request.getParameter("sortTitle");
        if ("asc".equals(sortTitle)) {
            posts = postDAO.sortByTitle(true); // A-Z
        } else if ("desc".equals(sortTitle)) {
            posts = postDAO.sortByTitle(false); // Z-A
        }

        if (posts == null) {
            posts = postDAO.list(); // Nếu không có filter nào, lấy tất cả
        }

        request.setAttribute("posts", posts);
        request.getRequestDispatcher("viewPosts.jsp").forward(request, response);
    
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
        processRequest(request, response);
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
