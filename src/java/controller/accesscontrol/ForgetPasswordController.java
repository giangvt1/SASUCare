/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.accesscontrol;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
main
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.*;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
Login,Register
import java.io.*;

public class ForgetPasswordController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String verificationCode = generateVerificationCode();

        // Gửi mã xác nhận qua email
        boolean isSent = sendVerificationEmail(email, verificationCode);

        if (isSent) {
            // Lưu mã xác nhận vào session để xác minh sau này
            request.getSession().setAttribute("verificationCode", verificationCode);
            response.sendRedirect("verifyCode.jsp");  // Chuyển hướng người dùng đến trang nhập mã
        } else {
            response.getWriter().println("Có lỗi xảy ra khi gửi email. Vui lòng thử lại!");
        }
    }

    private String generateVerificationCode() {
        // Tạo mã xác nhận ngẫu nhiên
        Random random = new Random();
        int code = random.nextInt(999999);
        return String.format("%06d", code);  // Đảm bảo mã có 6 chữ số
    }

    private boolean sendVerificationEmail(String toEmail, String verificationCode) {
        String fromEmail = "your-email@gmail.com";
        String password = "your-email-password";

        // Cấu hình server Gmail
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // Tạo session với thông tin đăng nhập của bạn
        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // Tạo một đối tượng message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác nhận quên mật khẩu");
            message.setText("Mã xác nhận của bạn là: " + verificationCode);

            // Gửi email
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}

