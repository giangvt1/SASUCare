package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.*;
import dao.RoleDBContext;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import model.system.Staff;
import java.sql.*;
public class UserAccountCreateController extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, Staff logged) throws ServletException, IOException {
        RoleDBContext db = new RoleDBContext();
        request.setAttribute("role", db.list());
        request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, Staff logged) throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullname = request.getParameter("fullname");
            boolean gender = Boolean.parseBoolean(request.getParameter("gender"));
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            int roleId = Integer.parseInt(request.getParameter("role"));
            String address = request.getParameter("address");
            Date dob = Date.valueOf(request.getParameter("dob")); // Assuming dob is passed as yyyy-mm-dd

            // Hash the password before storing
            String hashedPassword = hashPassword(password);

            // Create new User and set properties
            Staff user = new Staff();
            user.setUsername(username);
            user.setPassword(hashedPassword);
            user.setFullname(fullname);
            user.setGender(gender);
            user.setEmail(email);
            user.setPhonenumber(phone);
            user.setAddress(address);
            user.setDob(dob);
            ArrayList<Role> role = new ArrayList<>();
            Role role1 = new Role();
            role1.setId(roleId);
            role.add(role1);
            user.setRole(role);

            StaffDBContext db = new StaffDBContext();
            db.insert(user);

            response.sendRedirect("hr/accountlist");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input. Please check the values.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error occurred while creating user. Please try again.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
        }
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
