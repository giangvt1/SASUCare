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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Application;
import model.TypeApplication;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class ViewApplication extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String typeName = request.getParameter("name");
        String dateSendStr = request.getParameter("dateSend");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");
        String sort = "default";
        int sizeOfEachTable = 10;
        java.sql.Date dateSend = null;

        try {
            if (dateSendStr != null && !dateSendStr.isEmpty()) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = format.parse(dateSendStr);
                dateSend = new java.sql.Date(parsedDate.getTime());
            }
        } catch (ParseException ex) {
            System.out.println(ex);
        }

        int staffId = Integer.parseInt(request.getParameter("staffId"));
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);

            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        if (sortStr != null) {
            sort = sortStr;
        }
        if (sizeStr != null && !sizeStr.isEmpty()) {
            sizeOfEachTable = Integer.parseInt(sizeStr);
        }
        ApplicationDBContext appDAO = new ApplicationDBContext();
        List<TypeApplication> typeList = appDAO.getAllTypes();

        List<Application> applications = appDAO.getApplicationsByStaffID(typeName, dateSend, status, staffId, page, sort, sizeOfEachTable);

        int totalApplications = appDAO.getApplicationsCountByStaffID(typeName, dateSend, status, staffId);
        int totalPages = (int) Math.ceil((double) totalApplications / sizeOfEachTable);
        request.setAttribute("typeList", typeList);
        request.setAttribute("applications", applications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("ViewApplication.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
