package controller.systemaccesscontrol;

import dao.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import model.system.*;

public abstract class BaseRBACController extends BaseRequiredAuthentication {

    private static final Logger logger = Logger.getLogger(BaseRBACController.class.getName());
    private static final int MAX_SESSION_INTERVAL = 30 * 60; // 30 minutes

    private boolean isAuthorized(HttpServletRequest req, User logged) {
        try {
            HttpSession session = req.getSession();
            String currentUrl = normalizeUrl(req.getServletPath());

            // Debug logging
            System.out.println("Checking Authorization for URL: " + currentUrl);
            System.out.println("Username: " + logged.getUsername());

            if (logged.getRoles() == null || logged.getRoles().isEmpty()) {
                UserDBContext db = new UserDBContext();
                logged.setRoles(db.getRoles(logged.getUsername()));
            }

            // Print roles and features for debugging
            for (Role role : logged.getRoles()) {
                System.out.println("Role: " + role.getName());
                if (role.getFeatures() != null) {
                    for (Feature feature : role.getFeatures()) {
                        System.out.println("  Feature: " + feature.getName()
                                + ", URL: " + normalizeUrl(feature.getUrl()));
                    }
                }
            }

            // Check authorization
            for (Role role : logged.getRoles()) {
                if (role.getFeatures() != null) {
                    for (Feature feature : role.getFeatures()) {
                        if (normalizeUrl(feature.getUrl()).equals(currentUrl)) {
                            System.out.println("Access Granted for URL: " + currentUrl);
                            return true;
                        }
                    }
                }
            }

            System.out.println("Access Denied for URL: " + currentUrl);
            return false;

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Authorization check failed", e);
            return false;
        }
    }

    private boolean isSessionValid(HttpSession session) {
        Long lastAccess = (Long) session.getAttribute("lastAccessTime");
        if (lastAccess == null) {
            return false;
        }
        long currentTime = System.currentTimeMillis();
        return (currentTime - lastAccess) <= (MAX_SESSION_INTERVAL * 1000);
    }

    // Các phương thức mà controller con phải triển khai nếu được ủy quyền
    protected abstract void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException;

    protected abstract void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException;

    @Override
    protected void doAuthenGet(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException {
        if (isAuthorized(req, logged)) {
            doAuthorizedGet(req, resp, logged);
        } else {
            // Sử dụng getContextPath() để đảm bảo redirect đúng đường dẫn
            resp.sendRedirect(req.getContextPath() + "/error403.jsp");
        }
    }

    @Override
    protected void doAuthenPost(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException {
        if (isAuthorized(req, logged)) {
            doAuthorizedPost(req, resp, logged);
        } else {
            resp.sendRedirect(req.getContextPath() + "/error403.jsp");
        }
    }

    private String normalizeUrl(String url) {
        if (url == null) {
            return "";
        }
        url = url.trim().toLowerCase();

        // Ensure it starts with /
        url = url.startsWith("/") ? url : "/" + url;

        // Remove trailing slashes
        url = url.endsWith("/") ? url.substring(0, url.length() - 1) : url;

        return url;
    }
}
