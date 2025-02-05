package googleservices;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class ValidateOtp
 */
@WebServlet("/ValidateOtp")
public class ValidateOtp extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("./EnterOtp.jsp").forward(request, response);

    } 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy giá trị OTP từ người dùng
        int value = Integer.parseInt(request.getParameter("otp"));
        HttpSession session = request.getSession();

        // Lấy OTP đã lưu trong session
        Integer otp = (Integer) session.getAttribute("otp");
        String action = (String) session.getAttribute("action");
        
        // Kiểm tra giá trị OTP
        if (value == otp) {
            response.sendRedirect(action);
        } else {
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Invalid OTP!');");
            response.getWriter().println("window.history.back();");
            response.getWriter().println("</script>");
        }
    }
}