/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import controller.systemaccesscontrol.BaseRequiredAuthentication;
import dao.UserDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class EditUserController extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String username = request.getParameter("username");
        if (username == null || username.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/hr/accountlist");
            return;
        }

        UserDBContext userDB = new UserDBContext();
        User user = userDB.getUserByUsername(username); // Lấy user theo username
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/hr/accountlist");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String username = request.getParameter("username");
        String displayname = request.getParameter("displayname");
        String gmail = request.getParameter("gmail");
        String phone = request.getParameter("phone");

        if (username == null || username.isEmpty()) {
            request.setAttribute("error", "Invalid user data");
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }

        UserDBContext userDB = new UserDBContext();
        User user = new User();
        user.setUsername(username);
        user.setDisplayname(displayname);
        user.setGmail(gmail);
        user.setPhone(phone);

        boolean success = userDB.updateUser(user);
        if (success) {
            request.setAttribute("success", "User updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update user.");
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
    }

}
