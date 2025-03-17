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
@WebServlet(name = "PostsController", urlPatterns = {"/posts"})
public class PostsController extends HttpServlet {

    private static final int PAGE_SIZE = 6; // Số bản ghi trên 1 trang

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
        try {
            String search = request.getParameter("search");
            if (search != null) {
                search = search.trim().replaceAll("\\s+", " ").replace(" ", "%");
            }

            int pageIndex = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    pageIndex = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException ex) {
                response.sendRedirect(request.getContextPath() + "/posts"); // Redirect to first page
                return;
            }

            PostDAO dao = new PostDAO();
            List<Post> posts = dao.listPosts(search, pageIndex, PAGE_SIZE, true);
            int totalRecords = dao.getTotalPosts(search, true);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

            request.setAttribute("posts", posts);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", search == null ? "" : search.replace("%", " "));

            request.getRequestDispatcher("Posts.jsp").forward(request, response);

        } catch (ServletException | IOException e) {
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            request.getRequestDispatcher("Posts.jsp").forward(request, response);

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
        processRequest(request, response);
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
        processRequest(request, response);
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
