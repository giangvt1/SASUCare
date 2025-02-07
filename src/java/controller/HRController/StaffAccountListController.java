/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import controller.systemaccesscontrol.BaseRequiredAuthentication;
import dao.UserDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.system.Staff;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class StaffAccountListController extends BaseRBACController {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String keyword = request.getParameter("search") == null ? "" : request.getParameter("search").trim();
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        UserDBContext userDB = new UserDBContext();

        if ("delete".equals(action) && username != null) {
            userDB.deleteUser(username);
            response.sendRedirect(request.getContextPath() + "/hr/accountlist");
            return;
        }

        int pageIndex = 1;
        try {
            pageIndex = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ex) {
            // Mặc định là trang 1 nếu không truyền tham số hoặc lỗi
        }

        ArrayList<User> listUser = userDB.searchAndPaginate(keyword, pageIndex, PAGE_SIZE);
        int totalRecords = userDB.getTotalUserCount(); // Đếm tất cả User
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("listUser", listUser);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", keyword);
        request.getRequestDispatcher("/hr/UserAccountList.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
