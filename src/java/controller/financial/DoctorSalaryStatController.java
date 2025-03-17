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
        // Lấy các tham số filter, search, sort và phân trang
        String startParam = request.getParameter("startDate");
        String endParam = request.getParameter("endDate");
        String search = request.getParameter("search");
        String sortField = request.getParameter("sortField");
        String sortDir = request.getParameter("sortDir");
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        
        // Mặc định nếu tham số không có
        Date startDate = (startParam != null && !startParam.isEmpty())
                ? Date.valueOf(startParam)
                : Date.valueOf("2025-02-01");
        Date endDate = (endParam != null && !endParam.isEmpty())
                ? Date.valueOf(endParam)
                : new Date(System.currentTimeMillis());
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 10;
        
        // Tính offset
        int offset = (page - 1) * pageSize;
        
        // Lấy danh sách thống kê theo phân trang và filter
        List<DoctorSalaryStat> stats = dsDAO.getDoctorSalaryStats(startDate, endDate, search, sortField, sortDir, offset, pageSize);
        
        // Đếm tổng số bản ghi (số bác sĩ)
        int totalRecords = dsDAO.countDoctorSalaryStats(startDate, endDate, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Đưa các tham số ra JSP
        request.setAttribute("stats", stats);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
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
