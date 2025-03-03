package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import model.system.User;

public class ResetPasswordController extends BaseRBACController {

    // Mẫu mật khẩu: ít nhất 6 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt.
    static final String PASSWORD_PATTERN = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{6,}$";

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        request.getRequestDispatcher("../admin/ResetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        UserDBContext db = new UserDBContext();

        // Kiểm tra mật khẩu mới và mật khẩu xác nhận có trùng khớp không
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("../admin/ResetPassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu có phù hợp với mẫu không
        Pattern pattern = Pattern.compile(PASSWORD_PATTERN);
        Matcher matcher = pattern.matcher(newPassword);
        if (!matcher.matches()) {
            request.setAttribute("errorMessage", "Password does not meet complexity requirements. It must be at least 6 characters long and include an uppercase letter, a lowercase letter, a digit, and a special character.");
            request.getRequestDispatcher("../admin/ResetPassword.jsp").forward(request, response);
            return;
        }

        // Gọi hàm resetPassword của DBContext để cập nhật mật khẩu (sử dụng username của user đang đăng nhập)
        boolean resetResult = db.resetPassword(logged.getUsername(), newPassword);

        if (resetResult) {
            request.setAttribute("successMessage", "Your password has been reset successfully.");
        } else {
            request.setAttribute("errorMessage", "There was an error resetting your password. Please try again later.");
        }

        request.getRequestDispatcher("../admin/ResetPassword.jsp").forward(request, response);
    }
}
