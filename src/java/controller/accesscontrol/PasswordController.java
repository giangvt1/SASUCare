/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.accesscontrol;

import dao.CustomerDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import model.Customer;

/**
 *
 * @author ngoch
 */
public class PasswordController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

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
        // Lấy dữ liệu từ form
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        HttpSession session = request.getSession();
        
        if (!newPassword.equals(confirmPassword)) {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Passwords confirm do not match!');");
            response.getWriter().println("window.history.back();");  // Quay lại trang trước khi bấm OK
            response.getWriter().println("</script>");
            return;  
        }
        
        String passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{6,}$";
        if (!newPassword.matches(passwordPattern)) {
            // Nếu mật khẩu không hợp lệ
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Password must be at least 6 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character.');");
            response.getWriter().println("window.history.back();");  // Quay lại trang trước khi bấm OK
            response.getWriter().println("</script>");
            return;
        }
        
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        String hashPassword = hashPassword(oldPassword);
        
        System.out.println("terssst: " + hashPassword.equals(customer.getPassword()));
        
        if (hashPassword.equals(customer.getPassword())) {
            CustomerDBContext db = new CustomerDBContext();
            db.changePass(customer, hashPassword(newPassword));
            
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Password update successfully!');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            System.out.println(sb.toString());
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
