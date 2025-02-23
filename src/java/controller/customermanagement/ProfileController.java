/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customermanagement;

import dao.CustomerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.GoogleAccount;

/**
 *
 * @author ngoch
 */
public class ProfileController extends HttpServlet {
   
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
            out.println("<title>Servlet ProfileController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProfileController at " + request.getContextPath () + "</h1>");
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
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            // Không có session, chuyển hướng hoặc hiển thị thông báo
            response.getWriter().println("No active session. Please log in.");
            return; // Dừng xử lý tiếp
        }
        
        // Lấy đối tượng customer từ session
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        GoogleAccount googleAccount = (GoogleAccount) session.getAttribute("currentGoogle");
        if (customer == null) {
            // Không tìm thấy thông tin khách hàng trong session
            response.getWriter().println("No customer information found in session.");
            return; // Dừng xử lý tiếp
        }
        
            // Đặt đối tượng customer làm attribute để gửi sang JSP
        request.setAttribute("customer", customer);
        request.setAttribute("google", googleAccount);

            // Forward request sang file JSP
        request.getRequestDispatcher("./customer/profile.jsp").forward(request, response);
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
        HttpSession mySession = request.getSession();
        Customer customer = (Customer) mySession.getAttribute("currentCustomer");

        if (customer == null) {
            response.sendRedirect("login.jsp"); // Chuyển hướng đến trang đăng nhập nếu chưa đăng nhập
            return;
        }

        CustomerDBContext customerDAO = new CustomerDBContext();

        String fullName = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Kiểm tra input không được null hoặc rỗng
        if (fullName != null && !fullName.trim().isEmpty()) {
            customer.setFullname(fullName);
        }
        if (address != null && !address.trim().isEmpty()) {
            customer.setAddress(address);
        }
        
        if (phone != null && !phone.trim().isEmpty()) {
            customer.setPhone_number(phone);
        }

        // Cập nhật thông tin khách hàng
        customerDAO.update(customer);

        // Sau khi cập nhật có thể chuyển hướng đến trang profile hoặc thông báo thành công
        response.sendRedirect("./profile");

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
