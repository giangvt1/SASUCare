/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.ApplicationDBContext;
import dao.DoctorDBContext;
import dao.GoogleDBContext;
import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Application;
import model.TypeApplication;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class SendApplication extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        ApplicationDBContext appDAO = new ApplicationDBContext();
        List<TypeApplication> typeList = appDAO.getAllTypes();
        request.setAttribute("typeList", typeList);
        request.getRequestDispatcher("SendApplication.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String staffName = request.getParameter("staffName");
        int typeId = Integer.parseInt(request.getParameter("typeId"));
        String reason = request.getParameter("reason");
        Application a = new Application();
        a.setStaffSendId(staffId);
        a.setTypeId(typeId);
        a.setReason(reason);
        ApplicationDBContext appDAO = new ApplicationDBContext();
        GoogleDBContext g = new GoogleDBContext();
        StaffDBContext s = new StaffDBContext();
        List<TypeApplication> typeList = appDAO.getAllTypes();
        int staffManagerId = appDAO.getStaffManagerIdByTypeApplicationId(typeId);
        String gmail = s.getUserGmailByStaffId(staffManagerId);
        boolean isCreated = appDAO.createApplicationForStaff(a);

        if (isCreated) {
            request.setAttribute("message", "Application sent successfully!");
            String title = "Bạn có đơn từ bác sỹ:" + staffName;
            String mess = "Lời nhắn: " + reason;
            g.send(gmail, title, mess);

        } else {
            request.setAttribute("message", "Failed to send application.");
        }

        request.setAttribute("typeList", typeList);
        request.getRequestDispatcher("SendApplication.jsp").forward(request, response);
    }

}
