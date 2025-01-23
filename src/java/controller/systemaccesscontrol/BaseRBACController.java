package controller.systemaccesscontrol;

import dao.StaffDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.system.*;

public abstract class BaseRBACController extends BaseRequiredAuthentication {

    private boolean isAuthorized(HttpServletRequest req, Staff logged) {
        StaffDBContext db = new StaffDBContext();
        ArrayList<Role> roles = db.getRoles(logged.getUsername());
        logged.setRole(roles);
        String c_url = req.getServletPath();
        
        System.out.println("Checking authorization for URL: " + c_url);
        for (Role role : roles) {
            System.out.println("Role: " + role.getName());
            for (Feature feature : role.getFeatures()) {
                System.out.println("Feature URL: " + feature.getUrl());
                if (feature.getUrl().equals(c_url)) {
                    System.out.println("Authorization successful for URL: " + c_url);
                    return true;
                }
            }
        }
        System.out.println("Authorization failed for URL: " + c_url);
        return false;
    }

    protected abstract void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, Staff logged) throws ServletException, IOException;

    protected abstract void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, Staff logged) throws ServletException, IOException;

    @Override
    protected void doAuthenGet(HttpServletRequest req, HttpServletResponse resp, Staff logged) throws ServletException, IOException {
        if (isAuthorized(req, logged)) {
            doAuthorizedGet(req, resp, logged);
        } else {
            resp.sendRedirect("../error403.jsp");
        }
    }

    @Override
    protected void doAuthenPost(HttpServletRequest req, HttpServletResponse resp, Staff logged) throws ServletException, IOException {
        if (isAuthorized(req, logged)) {
            doAuthorizedPost(req, resp, logged);
        } else {
            resp.sendRedirect("../error403.jsp");
        }
    }

}
