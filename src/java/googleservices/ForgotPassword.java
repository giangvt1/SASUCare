package googleservices;

import dao.CustomerDBContext;
import dao.GoogleDBContext;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class ForgotPassword
 */
@WebServlet("/forgotPassword")
public class ForgotPassword extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Features/ForgotPassword/ForgotPassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");
        RequestDispatcher dispatcher = null;

        HttpSession mySession = request.getSession();
        CustomerDBContext customerDAO = new CustomerDBContext();
        GoogleDBContext googleDAO = new GoogleDBContext();

        if (customerDAO.isCustomerExistedByGmail(email)) {
            // sending otp
            int otpValue = googleDAO.sendOtp(email);
            request.setAttribute("message", "OTP is sent to your email id");
            //request.setAttribute("connection", con);
            mySession.setAttribute("otp", otpValue);
            mySession.setAttribute("email", email);
            mySession.setAttribute("action", "NewPassword");

            response.sendRedirect("./ValidateOtp");
            //request.setAttribute("status", "success");
        } else {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Email not found!');");
            response.getWriter().println("window.history.back();");
            response.getWriter().println("</script>");
        }

    }

}
