package controller.accesscontrol;

import dao.CustomerDBContext;
import dao.GoogleDBContext;
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

public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action.equals("create-user")) {
            Customer customer = new Customer();
            CustomerDBContext customerDAO = new CustomerDBContext();
            HttpSession mySession = request.getSession();
            
            String username = (String) mySession.getAttribute("username");
            String password = (String) mySession.getAttribute("password");
            String fullname = (String) mySession.getAttribute("fullname");
            String email = (String) mySession.getAttribute("email");
            String phoneNumber = (String) mySession.getAttribute("phoneNumber");
            
            String hashedPassword = hashPassword(password);
            
            customer.setUsername(username);
            customer.setPassword(hashedPassword);
            customer.setFullname(fullname);
            customer.setGmail(email);
            customer.setPhone_number(phoneNumber);
            customerDAO.insert(customer);
            
            request.getSession().setAttribute("currentCustomer", customer);

            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Registration successful!');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");

            
        } else {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Registration unsuccessful!');");
            response.getWriter().println("window.location.href = 'Home.jsp';");
            response.getWriter().println("</script>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullname = request.getParameter("full-name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone-number");
        
        CustomerDBContext customerDAO = new CustomerDBContext();
        
        if(customerDAO.findByUsername(username)) {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Username has been registed!');");
            response.getWriter().println("window.history.back()");
            response.getWriter().println("</script>");
            return;
        }
        
        if(customerDAO.isCustomerExisted(email)) {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Email has been registed!');");
            response.getWriter().println("window.history.back()");
            response.getWriter().println("</script>");
            return;
        }
        
        HttpSession mySession = request.getSession();
        GoogleDBContext googleDAO = new GoogleDBContext();
        int otpValue = googleDAO.sendOtp(email);
        request.setAttribute("message","OTP is sent to your email id");
        //request.setAttribute("connection", con);
        mySession.setAttribute("otp",otpValue); 
        mySession.setAttribute("email",email); 
        mySession.setAttribute("action","./register?action=create-user"); 
        
        mySession.setAttribute("username", username);
        mySession.setAttribute("password", password);
        mySession.setAttribute("fullname", fullname);
        mySession.setAttribute("email", email);
        mySession.setAttribute("phoneNumber", phoneNumber);


        response.sendRedirect("./ValidateOtp");
        

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
