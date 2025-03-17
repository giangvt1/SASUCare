package controller.financial;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorScheduleDBContext;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DoctorSalaryStat;
import model.system.User;

public class DoctorSalaryChartController extends BaseRBACController {

    private DoctorScheduleDBContext dsDAO = new DoctorScheduleDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy tham số 'month' từ request (dạng "YYYY-MM")
        String monthParam = request.getParameter("month");
        
        // Nếu không có, sử dụng tháng hiện tại
        if (monthParam == null || monthParam.isEmpty()) {
            YearMonth currentYM = YearMonth.now();
            monthParam = currentYM.toString(); // ví dụ "2025-03"
        }
        
        // Chuyển đổi monthParam thành ngày đầu tháng và cuối tháng
        YearMonth ym = YearMonth.parse(monthParam);
        LocalDate firstDay = ym.atDay(1);
        LocalDate lastDay = ym.atEndOfMonth();
        Date startDate = Date.valueOf(firstDay);
        Date endDate = Date.valueOf(lastDay);
        
        // Lấy dữ liệu thống kê lương của bác sĩ trong khoảng tháng được chọn
        // Ở đây, không áp dụng phân trang (offset = 0, pageSize = Integer.MAX_VALUE)
        List<DoctorSalaryStat> stats = dsDAO.getDoctorSalaryStats(startDate, endDate, null, null, null, 0, Integer.MAX_VALUE);
        
        // Đưa các giá trị vào request attributes
        request.setAttribute("stats", stats);
        request.setAttribute("monthSelected", monthParam); // để form hiển thị lại giá trị đã chọn
        
        // Forward đến trang JSP hiển thị biểu đồ
        request.getRequestDispatcher("../finance/SalaryStatistic.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
