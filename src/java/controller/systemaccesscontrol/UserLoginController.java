package controller.systemaccesscontrol;

import dao.StaffDBContext;
import dao.UserDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.Set;
import model.system.*;

/**
 *
 * @author acer giangvt
 */
public class UserLoginController extends HttpServlet {

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
        UserDBContext db = new UserDBContext();
        User account = db.login(username, password);

        // Kiểm tra account trước khi gọi getGmail()
        if (account == null) {
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("../admin/AdminLogin.jsp").forward(request, response);
            return;
        }

        System.out.println("account email: " + account.getGmail());
        StaffDBContext staffDao = new StaffDBContext();

        HttpSession session = request.getSession();
        session.setAttribute("account", account);
        ArrayList<Role> roles = db.getRoles(username);
        account.setRoles(roles);

        // Lấy đối tượng Staff từ cơ sở dữ liệu dựa vào username
        Staff staffObj = staffDao.getByUsername(username);
        session.setAttribute("staff", staffObj);

        // Collect role names for display
        StringBuilder roleNames = new StringBuilder();
        for (Role role : roles) {
            if (roleNames.length() > 0) {
                roleNames.append(", ");
            }
            roleNames.append(role.getName());
        }
        session.setAttribute("userRoles", roleNames.toString());
        System.out.println("userRoles: " + roleNames.toString());

        ArrayList<Feature> features = new ArrayList<>();
        for (Role role : roles) {
            features.addAll(role.getFeatures());
        }
        session.setAttribute("allowedUrls", getAllowedUrls(features));
        if (roles.get(0).getName().equalsIgnoreCase("Doctor")) {
            response.sendRedirect(request.getContextPath() + "/doctor/appointmentsmanagement");
            return;
        }
        if (roles.get(0).getName().equalsIgnoreCase("HR")) {
            response.sendRedirect(request.getContextPath() + "/hr/accountlist");
            return;
        }
         if (roles.get(0).getName().equalsIgnoreCase("Finance")) {
            response.sendRedirect(request.getContextPath() + "/finance/revenue");
            return;
        }
        request.getRequestDispatcher("../admin/Dashboard.jsp").forward(request, response);
    }

    private Set<String> getAllowedUrls(ArrayList<Feature> features) {
        Set<String> allowedUrls = new LinkedHashSet<>();
        for (Feature feature : features) {
            allowedUrls.add(feature.getUrl());
        }
        return allowedUrls;
    }
}
