package controller.financial;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorScheduleDBContext;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import model.DoctorSalaryStat;
import model.system.User;

public class DoctorSalaryStatController extends BaseRBACController {

    private DoctorScheduleDBContext dsDAO = new DoctorScheduleDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        
        // Kiểm tra nếu export=csv
        String export = request.getParameter("export");
        if ("csv".equalsIgnoreCase(export)) {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"doctorSalaryStats.csv\"");
            PrintWriter out = response.getWriter();
            
            // Ghi tiêu đề CSV
            out.println("DoctorId,DoctorName,ShiftCount,SalaryRate,SalaryCoefficient,TotalSalary");
            
            // Lấy các tham số lọc (chỉ cần xuất toàn bộ dữ liệu, không cần phân trang nên đặt pageSize = Integer.MAX_VALUE)
            String startParam = request.getParameter("startDate");
            String endParam = request.getParameter("endDate");
            String search = request.getParameter("search");
            String sortField = request.getParameter("sortField");
            String sortDir = request.getParameter("sortDir");
            
            Date startDate = (startParam != null && !startParam.trim().isEmpty())
                    ? Date.valueOf(startParam.trim())
                    : Date.valueOf("2025-02-01");
            Date endDate = (endParam != null && !endParam.trim().isEmpty())
                    ? Date.valueOf(endParam.trim())
                    : new Date(System.currentTimeMillis());
            
            int offset = 0;
            int pageSize = Integer.MAX_VALUE; // Xuất toàn bộ dữ liệu
            
            List<DoctorSalaryStat> stats = dsDAO.getDoctorSalaryStats(startDate, endDate, search, sortField, sortDir, offset, pageSize);
            
            // Xuất dữ liệu CSV (escape dấu phẩy nếu cần)
            for (DoctorSalaryStat stat : stats) {
                String line = stat.getDoctorId() + ","
                        + "\"" + stat.getDoctorName().replace("\"", "\"\"") + "\"," 
                        + stat.getShiftCount() + ","
                        + stat.getSalaryRate() + ","
                        + stat.getSalaryCoefficient()+ ","
                        + stat.getTotalSalary();
                out.println(line);
            }
            out.flush();
            return; // Kết thúc xử lý nếu xuất CSV
        }
        
        // Nếu không xuất CSV, xử lý như bình thường để hiển thị giao diện
        String startParam = request.getParameter("startDate");
        String endParam = request.getParameter("endDate");
        String search = request.getParameter("search");
        String sortField = request.getParameter("sortField");
        String sortDir = request.getParameter("sortDir");
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        Date startDate = (startParam != null && !startParam.trim().isEmpty())
                ? Date.valueOf(startParam.trim())
                : Date.valueOf("2025-02-01");
        Date endDate = (endParam != null && !endParam.trim().isEmpty())
                ? Date.valueOf(endParam.trim())
                : new Date(System.currentTimeMillis());

        int page = (pageParam != null && !pageParam.trim().isEmpty()) ? Integer.parseInt(pageParam.trim()) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) ? Integer.parseInt(pageSizeParam.trim()) : 10;
        if (pageSize < 5) pageSize = 5;
        if (pageSize > 50) pageSize = 50;
        int offset = (page - 1) * pageSize;

        List<DoctorSalaryStat> stats = dsDAO.getDoctorSalaryStats(startDate, endDate, search, sortField, sortDir, offset, pageSize);
        int totalRecords = dsDAO.countDoctorSalaryStats(startDate, endDate, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

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