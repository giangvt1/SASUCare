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

    private final DoctorScheduleDBContext dsDAO = new DoctorScheduleDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        String monthParam = request.getParameter("month");
        
        if (monthParam == null || monthParam.isEmpty()) {
            YearMonth currentYM = YearMonth.now();
            monthParam = currentYM.toString();
        }
        
        YearMonth ym = YearMonth.parse(monthParam);
        LocalDate firstDay = ym.atDay(1);
        LocalDate lastDay = ym.atEndOfMonth();
        Date startDate = Date.valueOf(firstDay);
        Date endDate = Date.valueOf(lastDay);
        
        List<DoctorSalaryStat> stats = dsDAO.getDoctorSalaryStats(startDate, endDate, null, null, null, 0, Integer.MAX_VALUE);
        request.setAttribute("stats", stats);
        request.setAttribute("monthSelected", monthParam);
        request.getRequestDispatcher("../finance/SalaryStatistic.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
