/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import dao.GoogleDBContext;
import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Application;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class SendApplication extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        int did = Integer.parseInt(request.getParameter("did"));
        String name = request.getParameter("name");
        String reason = request.getParameter("reason");
        int hrId = Integer.parseInt(request.getParameter("hrid"));
        java.util.Date utilDate = new java.util.Date();

        java.sql.Date date = new java.sql.Date(utilDate.getTime());

        Application a = new Application();
        a.setDid(did);
        a.setName(name);
        a.setReason(reason);
        a.setDate(date);

        DoctorDBContext d = new DoctorDBContext();
        GoogleDBContext g = new GoogleDBContext();
        StaffDBContext s = new StaffDBContext();
        String gmail = s.getUserGmailByStaffId(hrId);
        boolean isCreated = d.createApplicationForDid(a);

        if (isCreated) {
            request.setAttribute("message", "Application sent successfully!");
            String mess = "You have an Application from Doctor have id:" + did;
            g.send(gmail, "Notification", mess);

        } else {
            request.setAttribute("message", "Failed to send application.");
        }

        request.getRequestDispatcher("SendApplication.jsp").forward(request, response);
    }

}