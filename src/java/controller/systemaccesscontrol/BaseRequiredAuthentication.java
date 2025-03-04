package controller.systemaccesscontrol;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.system.User;

public abstract class BaseRequiredAuthentication extends HttpServlet {

    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes

    private void ensureSecureSession(HttpServletRequest req) {
        HttpSession session = req.getSession();
        session.setMaxInactiveInterval(SESSION_TIMEOUT);

        // Check if session is expired
        Long lastAccess = (Long) session.getAttribute("lastAccessTime");
        long currentTime = System.currentTimeMillis();

        if (lastAccess != null && (currentTime - lastAccess) > (SESSION_TIMEOUT * 1000)) {
            session.invalidate();
            return;
        }

        session.setAttribute("lastAccessTime", currentTime);
    }

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
    protected abstract void doAuthenGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException;

    protected abstract void doAuthenPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException;
}
