/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.accesscontrol;

import controller.accesscontrol.GoogleLogin;
import dao.CustomerDBContext;
import dao.GoogleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import model.Customer;
import model.GoogleAccount;

/**
 *
 * @author acer
 */
public class LoginController extends HttpServlet {
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        GoogleDBContext googleDAO = new GoogleDBContext();
        CustomerDBContext customerDAO = new CustomerDBContext();
        String code = request.getParameter("code");
        GoogleLogin gg = new GoogleLogin();
        String accessToken = gg.getToken(code);
        GoogleAccount account = gg.getUserInfo(accessToken);
        
        if (!customerDAO.isCustomerExisted(account.getEmail())) {
            System.out.println("11111111111");
        // Nếu tài khoản chưa tồn tại, tạo user mới
            Customer customer = new Customer();
            
            customer.setGmail(account.getEmail());
            customer.setGoogle_id(account);
            customer.setFullname(account.getName());
            
            googleDAO.insert(account);
            customerDAO.insert(customer);
            
            request.getSession().setAttribute("currentCustomer", customer);
            request.getSession().setAttribute("currentGoogle", account);
            
            response.sendRedirect("Home.jsp");
            
        } else {
            System.out.println("222222222222");
            Customer customer = customerDAO.get(account.getId());
            
            HttpSession session = request.getSession(false);
            
            if (session == null) {
                session = request.getSession(); // Tạo mới session nếu chưa tồn tại
            }
            
            session.setAttribute("currentCustomer", customer);
            session.setAttribute("currentGoogle", account);
            
            response.sendRedirect("Home.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        CustomerDBContext db = new CustomerDBContext();
        Customer account = db.login(username, password);

        if (account != null) {
            HttpSession session = request.getSession(false);
            
            if (session == null) {
                session = request.getSession(); // Tạo mới session nếu chưa tồn tại
            }
            
            session.setAttribute("currentCustomer", account);
            response.sendRedirect("Home.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid username or password.");
           request.getRequestDispatcher("/Home.jsp").forward(request, response);
        }
    }

}
