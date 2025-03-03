package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.UserAccountDTO;
import java.io.IOException;
import java.util.ArrayList;
import model.system.User;

public class StaffAccountListController extends BaseRBACController {

    private static final int PAGE_SIZE = 10; // Số bản ghi trên 1 trang

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {

        try {
            String search = request.getParameter("search");
            if (search != null) {
                search = search.trim().replaceAll("\\s+", " ").replace(" ", "%");
            }

            String view = request.getParameter("view");
            if (view == null || view.trim().isEmpty()) {
                view = "extended";
            }

            int pageIndex = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    pageIndex = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException ex) {
                response.sendRedirect(request.getContextPath() + "/hr/accountlist"); // Redirect to first page
                return;
            }

            String action = request.getParameter("action");
            if ("delete".equals(action)) {
                String usernameToDelete = request.getParameter("username");
                if (usernameToDelete != null && !usernameToDelete.isEmpty()) {
                    UserDBContext dao = new UserDBContext();

                    try {
                        dao.deleteUser(usernameToDelete);
                        request.setAttribute("successMessage", "User deleted successfully!");
                    } catch (RuntimeException e) { // Catch and handle the exception
                        request.setAttribute("errorMessage", "Failed to delete user. " + e.getMessage());
                    }

                }
                response.sendRedirect(request.getContextPath() + "/hr/accountlist?page=" + pageIndex + "&search=" + (search == null ? "" : search.replace("%", " ")) + "&view=" + view); // Correct redirect URL
                return;
            }

            UserDBContext dao = new UserDBContext();
            ArrayList<UserAccountDTO> listUser = dao.listAccounts(search, pageIndex, PAGE_SIZE);
            int totalRecords = dao.getTotalUserCount(search);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

            request.setAttribute("listUser", listUser);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", search == null ? "" : search.replace("%", " "));
            request.setAttribute("view", view);

            request.getRequestDispatcher("../hr/UserAccountList.jsp").forward(request, response);

        } catch (ServletException | IOException e) {
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            request.getRequestDispatcher("../hr/UserAccountList.jsp").forward(request, response);

        }
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
