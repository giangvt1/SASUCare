package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.UserDBContext;
import dao.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.Role;
import model.system.User;
import java.io.IOException;
import java.util.ArrayList;

public class UserAccountCreateController extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        RoleDBContext db = new RoleDBContext();
        request.setAttribute("role", db.list());
        request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String displayname = request.getParameter("displayname");
        String gmail = request.getParameter("gmail");
        String phone = request.getParameter("phone");
        String[] roleIds = request.getParameterValues("roles");
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setDisplayname(displayname);
        newUser.setGmail(gmail);
        newUser.setPhone(phone);
        if (roleIds != null) {
            ArrayList<Role> roles = new ArrayList<>();
            for (String roleId : roleIds) {
                Role role = new Role();
                role.setId(Integer.parseInt(roleId));
                roles.add(role);
            }
            newUser.setRoles(roles);
        }
        UserDBContext userDB = new UserDBContext();
        try {
            userDB.insert(newUser, logged);
            request.setAttribute("successMessage", "Register a new account successful");
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error, try again");
        }
        request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
    }
}
