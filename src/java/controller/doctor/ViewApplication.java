/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Application;
import model.system.User;

/**
 *
 * @author acer giangvt
 */
public class ViewApplication extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        int did = Integer.parseInt(request.getParameter("did"));
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        DoctorDBContext d = new DoctorDBContext();
        List<Application> applications = d.getApplicationsByDoctorID(did, page);

        // Kiểm tra xem có trang tiếp theo không
        List<Application> nextPageCheck = d.getApplicationsByDoctorID(did, page + 1);
        boolean hasNextPage = !nextPageCheck.isEmpty();

        request.setAttribute("applications", applications);
        request.setAttribute("currentPage", page);
        request.setAttribute("hasNextPage", hasNextPage);

        request.getRequestDispatcher("ViewApplication.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
