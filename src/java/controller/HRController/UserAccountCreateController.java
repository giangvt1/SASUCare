package controller.HRController;

import controller.systemaccesscontrol.BaseRequiredAuthentication;
import dao.UserDBContext;
import dao.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.Role;
import model.system.User;
import java.io.IOException;
import java.util.ArrayList;

public class UserAccountCreateController extends BaseRequiredAuthentication {

    @Override
    protected void doAuthenGet(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException {
        RoleDBContext db = new RoleDBContext();
        req.setAttribute("role", db.list());
        req.getRequestDispatcher("../hr/HRCreate.jsp").forward(req, resp);
    }

    @Override
    protected void doAuthenPost(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException {
        // Lấy thông tin từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String displayname = req.getParameter("displayname");
        String gmail = req.getParameter("gmail");
        String phone = req.getParameter("phone");
        String[] roleIds = req.getParameterValues("roles");

        // Tạo đối tượng User từ thông tin form
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setDisplayname(displayname);
        newUser.setGmail(gmail);
        newUser.setPhone(phone);

        // Gán roles (nếu có)
        if (roleIds != null) {
            ArrayList<Role> roles = new ArrayList<>();
            for (String roleId : roleIds) {
                Role role = new Role();
                role.setId(Integer.parseInt(roleId));
                roles.add(role);
            }
            newUser.setRoles(roles);
        }

        // Thực hiện insert User (và tự động insert vào bảng Staff bên trong phương thức này)
        UserDBContext userDB = new UserDBContext();
        try {
            userDB.insert(newUser, logged); // Truyền logged vào làm createdBy
            req.setAttribute("successMessage", "Register a new account successful");
        } catch (Exception ex) {
            req.setAttribute("errorMessage", "Error, try again");
        }

        // Chuyển hướng lại trang HRCreate.jsp
        req.getRequestDispatcher("../hr/HRCreate.jsp").forward(req, resp);
    }
}
