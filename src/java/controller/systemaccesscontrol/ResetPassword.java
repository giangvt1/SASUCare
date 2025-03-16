/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.systemaccesscontrol;

import dao.UserDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author acer giangvt
 */
public class ResetPassword extends HttpServlet {

    private final UserDBContext us = new UserDBContext();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve gmail from session
        String gmail = (String) request.getSession().getAttribute("gmail");
        if (gmail == null) {
            request.setAttribute("error", "Session expired. Please restart the reset process.");
            request.getRequestDispatcher("/admin/OTP.jsp").forward(request, response);
            return;
        }
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("/admin/resetpassword.jsp").forward(request, response);
            return;
        }

        boolean success = us.resetPasswordwithgmail(gmail, newPassword);
        if (success) {
            // Optionally remove the gmail attribute after resetting the password
            request.getSession().removeAttribute("gmail");
            response.sendRedirect("../system/login");
        } else {
            request.setAttribute("error", "Password reset failed. Try again.");
            request.getRequestDispatcher("/admin/resetpassword.jsp").forward(request, response);
        }
    }

}
