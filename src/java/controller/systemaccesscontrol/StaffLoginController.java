package controller.systemaccesscontrol;

import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.Set;

import model.system.*;

/**
 *
 * @author acer giangvt
 */
public class StaffLoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("../admin/AdminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        StaffDBContext db = new StaffDBContext();
        Staff account = db.get(username, password);
        if (account != null) {
            request.getSession().setAttribute("account", account);
            ArrayList<Role> roles = db.getRoles(username);
            account.setRole(roles);
            ArrayList<Feature> features = new ArrayList<>();
            for (Role role : roles) {
                features.addAll(role.getFeatures());
            }
            request.getSession().setAttribute("allowedUrls", getAllowedUrls(features));
            request.getRequestDispatcher("../admin/Dashboard.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("../admin/AdminLogin.jsp").forward(request, response);
        }
    }

    private Set<String> getAllowedUrls(ArrayList<Feature> features) {
        Set<String> allowedUrls = new LinkedHashSet<>();
        for (Feature feature : features) {
            allowedUrls.add(feature.getUrl());
        }
        return allowedUrls;
    }
}
