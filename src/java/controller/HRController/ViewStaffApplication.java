/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HRController;

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
 * @author TRUNG
 */
public class ViewStaffApplication extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String staffNameStr = request.getParameter("staffName");
        String staffName = null;
        if (staffNameStr != null) {
            staffNameStr = staffNameStr.trim().replaceAll("\\s+", " ");
            staffNameStr = staffNameStr.replace(" ", "%");
            staffName = staffNameStr;
        }
        String typeName = request.getParameter("typeName");
        String dateSendFromStr = request.getParameter("dateSendFrom");
        String dateSendToStr = request.getParameter("dateSendTo");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");
        String sort = "default";
        int sizeOfEachTable = 10;
        java.sql.Date dateSendFrom = null;
        java.sql.Date dateSendTo = null;
        try {
            if ((dateSendFromStr != null && !dateSendFromStr.isEmpty()) && (dateSendToStr != null && !dateSendToStr.isEmpty())) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = format.parse(dateSendFromStr);
                dateSendFrom = new java.sql.Date(parsedDate.getTime());
                parsedDate = format.parse(dateSendToStr);
                dateSendTo = new java.sql.Date(parsedDate.getTime());
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

        List<Application> applications = appDAO.getStaffApplicationsByStaffID(typeName, staffName, dateSendFrom, dateSendTo, status, staffId, page, sort, sizeOfEachTable);

        int totalApplications = appDAO.getStaffApplicationsCountByStaffID(typeName, staffName, dateSendFrom, dateSendTo, status, staffId);
        int totalPages = (int) Math.ceil((double) totalApplications / sizeOfEachTable);
        request.setAttribute("typeList", typeList);
        request.setAttribute("applications", applications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("ViewStaffApplication.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
