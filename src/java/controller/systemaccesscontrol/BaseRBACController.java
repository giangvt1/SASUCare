package controller.systemaccesscontrol;

import dao.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.system.*;

public abstract class BaseRBACController extends BaseRequiredAuthentication {

    private boolean isAuthorized(HttpServletRequest req, User logged) {
        // Nếu danh sách roles của user chưa được load, load nó từ database
        if (logged.getRoles() == null || logged.getRoles().isEmpty()) {
            UserDBContext db = new UserDBContext();
            logged.setRoles(db.getRoles(logged.getUsername()));
        }

        String currentUrl = req.getServletPath();
        System.out.println("Checking authorization for URL: " + currentUrl);

        // Duyệt qua từng role của user
        for (Role role : logged.getRoles()) {
            System.out.println("Role: " + role.getName());
            if (role.getFeatures() != null) {
                // Duyệt qua từng feature của role đó
                for (Feature feature : role.getFeatures()) {
                    System.out.println("Feature URL: " + feature.getUrl());
                    if (feature.getUrl() != null && feature.getUrl().equalsIgnoreCase(currentUrl)) {
                        System.out.println("Authorization successful for URL: " + currentUrl);
                        return true;
                    }
                }
            }
        }
        System.out.println("Authorization failed for URL: " + currentUrl);
        return false;
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
}
