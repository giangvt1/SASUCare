package controller.systemaccesscontrol;

import dao.GoogleDBContext;
import dao.UserDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.security.SecureRandom;

public class ForgetPassword extends HttpServlet {

    private final GoogleDBContext gg = new GoogleDBContext();
    private final UserDBContext us = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/OTP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gmail = request.getParameter("gmail");
        String userOTP = request.getParameter("OTP");
        
        // If user is submitting their email address to request an OTP
        if (gmail != null && us.isEmailExists(gmail)) {
            String generatedOTP = generateOTP(6);
            // Set OTP validity for 30 seconds (30,000 ms)
            long otpValidUntil = System.currentTimeMillis() + 30000;
            boolean check = gg.sendOTPByEmail(gmail, generatedOTP);
            if (check) {
                // Store OTP, expiration time, and email in the session
                request.getSession().setAttribute("generatedOTP", generatedOTP);
                request.getSession().setAttribute("otpExpiry", otpValidUntil);
                request.getSession().setAttribute("gmail", gmail);
                request.getRequestDispatcher("/admin/OTP.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Failed to send OTP. Please try again.");
                request.getRequestDispatcher("/admin/OTP.jsp").forward(request, response);
                return;
            }
        }
        
        // When user submits OTP, check for expiration first
        Long otpExpiry = (Long) request.getSession().getAttribute("otpExpiry");
        if (otpExpiry == null || System.currentTimeMillis() > otpExpiry) {
            // OTP expired: clear session values and notify the user
            request.getSession().removeAttribute("generatedOTP");
            request.getSession().removeAttribute("otpExpiry");
            request.setAttribute("error", "OTP expired. Please request a new OTP.");
            request.getRequestDispatcher("/admin/OTP.jsp").forward(request, response);
            return;
        }
        
        // Now, verify the submitted OTP
        String sessionOTP = (String) request.getSession().getAttribute("generatedOTP");
        if (sessionOTP != null && sessionOTP.equals(userOTP)) {
            // OTP is valid; you may choose to remove the OTP-related attributes now
            request.getSession().removeAttribute("generatedOTP");
            request.getSession().removeAttribute("otpExpiry");
            // Proceed to the reset password page
            request.getRequestDispatcher("/admin/forgetpassword.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "OTP is incorrect. Please try again.");
            request.getRequestDispatcher("/admin/OTP.jsp").forward(request, response);
        }
    }

    public String generateOTP(int length) {
        SecureRandom random = new SecureRandom();
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(chars.length());
            sb.append(chars.charAt(randomIndex));
        }
        return sb.toString();
    }
}
