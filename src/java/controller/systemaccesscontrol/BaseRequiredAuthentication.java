package controller.systemaccesscontrol;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.system.User;

public abstract class BaseRequiredAuthentication extends HttpServlet {

    // Kiểm tra xem user đã đăng nhập chưa (session attribute "account")
    private boolean isAuthenticated(HttpServletRequest req) {
        return req.getSession().getAttribute("account") != null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedUser = (User) req.getSession().getAttribute("account");
        if (loggedUser != null) {
            doAuthenGet(req, resp, loggedUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/error403.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedUser = (User) req.getSession().getAttribute("account");
        if (loggedUser != null) {
            doAuthenPost(req, resp, loggedUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/error403.jsp");
        }
    }

    // Các phương thức mà các controller con cần triển khai để xử lý logic sau khi đã xác thực
    protected abstract void doAuthenGet(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException;
    protected abstract void doAuthenPost(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException;
}
