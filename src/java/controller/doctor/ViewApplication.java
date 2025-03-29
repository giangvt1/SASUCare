/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.ApplicationDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Application;
import model.TypeApplication;
import model.system.Staff;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class ViewApplication extends BaseRBACController {

    private int getStaffIdFromSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");

        if (staff == null) {
            response.sendRedirect("/error404.jsp");
            return -1;
        }

        return staff.getId();
    }

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int staffId = getStaffIdFromSession(request, response);
        String typeName = request.getParameter("name");
        String dateSendStr = request.getParameter("dateSend");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");

        int page = parseInteger(pageStr, 1);
        int sizeOfEachTable = parseInteger(sizeStr, 10);
        String sort = (sortStr != null) ? sortStr : "default";
        java.sql.Date dateSend = parseDate(dateSendStr);

        ApplicationDBContext appDAO = new ApplicationDBContext();
        List<TypeApplication> typeList = appDAO.getAllTypes();
        int totalApplications = appDAO.getApplicationsCountByStaffID(typeName, dateSend, status, staffId);
        int totalPages = (int) Math.ceil((double) totalApplications / sizeOfEachTable);

        if (page <= 0 || page > totalPages) {
            page = 1;
        }
        List<Application> applications = appDAO.getApplicationsByStaffID(typeName, dateSend, status, staffId, page, sort, sizeOfEachTable);
        request.setAttribute("typeList", typeList);
        request.setAttribute("applications", applications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("ViewApplication.jsp").forward(request, response);
    }

    private int parseInteger(String value, int defaultValue) {
        if (value != null && !value.isEmpty()) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException ignored) {
            }
        }
        return defaultValue;
    }

    private java.sql.Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) {
            return null;
        }
        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            return new java.sql.Date(format.parse(dateStr).getTime());
        } catch (ParseException ignored) {
        }
        return null;
    }
}
