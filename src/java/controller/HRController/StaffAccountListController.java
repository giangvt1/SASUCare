package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.system.User;
import model.system.UserAccountDTO;

public class StaffAccountListController extends BaseRBACController {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {

        try {
            // Lấy thông tin tìm kiếm
            String search = request.getParameter("search");
            if (search != null) {
                search = search.trim().replaceAll("\\s+", " ");
            }

            // Chế độ xem
            String view = request.getParameter("view");
            if (view == null || view.trim().isEmpty()) {
                view = "extended";
            }

            // Xử lý phân trang
            int pageIndex = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    pageIndex = Integer.parseInt(pageParam.trim());
                }
            } catch (NumberFormatException ex) {
                pageIndex = 1;
            }
            if (pageIndex < 1) pageIndex = 1;

            // Xử lý pageSize
            int pageSize = DEFAULT_PAGE_SIZE;
            String pageSizeParam = request.getParameter("pageSize");
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam.trim());
                } catch (NumberFormatException ex) {
                    pageSize = DEFAULT_PAGE_SIZE;
                }
            }
            if (pageSize < 5) pageSize = 5;
            if (pageSize > 50) pageSize = 50;

            // Gọi DAO
            UserDBContext dao = new UserDBContext();
            ArrayList<UserAccountDTO> listUser = dao.listAccounts(search, pageIndex, pageSize);
            int totalRecords = dao.getTotalUserCount(search);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            if (totalPages == 0) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;

            // Gửi dữ liệu sang JSP
            request.setAttribute("listUser", listUser);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", search == null ? "" : search);
            request.setAttribute("view", view);
            request.setAttribute("pageSize", pageSize);

            request.getRequestDispatcher("../hr/UserAccountList.jsp").forward(request, response);

        } catch (ServletException | IOException e) {
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            request.getRequestDispatcher("../hr/UserAccountList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
