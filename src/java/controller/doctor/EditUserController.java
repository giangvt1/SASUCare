/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HRController;

import controller.systemaccesscontrol.BaseRequiredAuthentication;
import dao.UserDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class EditUserController extends BaseRequiredAuthentication {

    @Override
    protected void doAuthenGet(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException {
        String username = req.getParameter("username");
        if (username == null || username.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/hr/accountlist");
            return;
        }

        UserDBContext userDB = new UserDBContext();
        User user = userDB.getUserByUsername(username); // Lấy user theo username
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/hr/accountlist");
            return;
        }

        req.setAttribute("user", user);
        req.getRequestDispatcher("/hr/EditUser.jsp").forward(req, resp);
    }

    @Override
    protected void doAuthenPost(HttpServletRequest req, HttpServletResponse resp, User logged) throws ServletException, IOException {
        String username = req.getParameter("username");
        String displayname = req.getParameter("displayname");
        String gmail = req.getParameter("gmail");
        String phone = req.getParameter("phone");

        if (username == null || username.isEmpty()) {
            req.setAttribute("error", "Invalid user data");
            req.getRequestDispatcher("/hr/EditUser.jsp").forward(req, resp);
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
            req.setAttribute("success", "User updated successfully!");
        } else {
            req.setAttribute("error", "Failed to update user.");
        }

        req.setAttribute("user", user);
        req.getRequestDispatcher("/hr/EditUser.jsp").forward(req, resp);
    }

}
