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
import java.util.List;
import model.Customer;

public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form đăng ký
        request.getRequestDispatcher("/accesscontrol/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String fullname = request.getParameter("full-name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone-number");

        String passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{6,}$";
        if (!password.matches(passwordPattern)) {
            // Nếu mật khẩu không hợp lệ
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Password must be at least 6 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character.');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");
            return;
        }

        String phonePattern = "^[0-9]{10}$";
        if (!phoneNumber.matches(phonePattern)) {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Phone number must be exactly 10 digits.');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Passwords do not match!');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");
            return;
            
            
        }
        
        String hashedPassword = hashPassword(password);
        Customer customer = new Customer();
        CustomerDBContext customerDAO = new CustomerDBContext();
        
        if(customerDAO.isCustomerExisted(email)) {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Email has been registed!');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");
            return;
        }
        
        customer.setUsername(username);
        customer.setPassword(hashedPassword);
        customer.setFullname(fullname);
        customer.setGmail(email);
        customer.setPhone_number(phoneNumber);
        customerDAO.insert(customer);
        
        response.setContentType("text/html");
        response.getWriter().println("<script type='text/javascript'>");
        response.getWriter().println("alert('Registration successful!');");
        response.getWriter().println("window.location.href = 'Home.jsp';");
        response.getWriter().println("</script>");
        
        request.getSession().setAttribute("currentCustomer", customer);
        
        response.sendRedirect("Home.jsp");
    }
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
