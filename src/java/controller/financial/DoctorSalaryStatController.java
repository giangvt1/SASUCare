package controller.financial;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorScheduleDBContext;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DoctorSalaryStat;
import model.system.User;

@WebServlet("/DoctorSalaryStat")
public class DoctorSalaryStatController extends BaseRBACController {

    private DoctorScheduleDBContext dsDAO = new DoctorScheduleDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy các tham số filter, search, sort, phân trang từ request
        String startParam = request.getParameter("startDate");
        String endParam = request.getParameter("endDate");
        String search = request.getParameter("search");
        String sortField = request.getParameter("sortField");
        String sortDir = request.getParameter("sortDir");
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        // Xử lý giá trị mặc định cho ngày lọc
        Date startDate = (startParam != null && !startParam.trim().isEmpty())
                ? Date.valueOf(startParam.trim())
                : Date.valueOf("2025-02-01");
        Date endDate = (endParam != null && !endParam.trim().isEmpty())
                ? Date.valueOf(endParam.trim())
                : new Date(System.currentTimeMillis());

        // Xử lý phân trang
        int page = (pageParam != null && !pageParam.trim().isEmpty()) ? Integer.parseInt(pageParam.trim()) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) ? Integer.parseInt(pageSizeParam.trim()) : 10;
        // Giới hạn pageSize: tối thiểu 5, tối đa 50
        if (pageSize < 5) pageSize = 5;
        if (pageSize > 50) pageSize = 50;
        int offset = (page - 1) * pageSize;

        // Lấy danh sách thống kê lương bác sĩ
        List<DoctorSalaryStat> stats = dsDAO.getDoctorSalaryStats(startDate, endDate, search, sortField, sortDir, offset, pageSize);
        int totalRecords = dsDAO.countDoctorSalaryStats(startDate, endDate, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        // Đưa các tham số ra JSP
        request.setAttribute("stats", stats);
        request.setAttribute("startDate", startParam != null ? startParam.trim() : startDate.toString());
        request.setAttribute("endDate", endParam != null ? endParam.trim() : endDate.toString());
        request.setAttribute("search", search);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("../finance/doctorSalaryStat.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
