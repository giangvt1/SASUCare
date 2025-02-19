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
        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }

        // Xử lý view (mặc định là extended)
        String view = request.getParameter("view");
        if (view == null || view.trim().isEmpty()) {
            view = "extended";
        }

        // Xử lý số trang, mặc định là 1
        int pageIndex = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                pageIndex = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ex) {
            pageIndex = 1;
        }

        // Gọi DAO để lấy danh sách tài khoản
        UserDBContext dao = new UserDBContext();
        ArrayList<UserAccountDTO> listUser = dao.listAccounts(search, pageIndex, PAGE_SIZE);
        int totalRecords = dao.getTotalUserCount(search);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        // Gán dữ liệu vào request
        request.setAttribute("listUser", listUser);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("view", view);

        // Chuyển tiếp đến JSP hiển thị danh sách tài khoản
        request.getRequestDispatcher("../hr/UserAccountList.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
