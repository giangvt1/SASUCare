/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MedicalHistory;
import model.VisitHistory;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class EditCustomerMedicalHistory extends BaseRBACController {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cid = Integer.parseInt(request.getParameter("cid"));
        String name = request.getParameter("name");
        String detail = request.getParameter("detail");
        String id = request.getParameter("id");

        MedicalHistory medicalH = new MedicalHistory();
        medicalH.setCid(cid);
        medicalH.setName(name);
        medicalH.setDetail(detail);
        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = false;
        if (id == null || id.isEmpty()) {
            isCreated = customerDB.createMedicalHistory(medicalH);
        } else {
            medicalH.setId(Integer.parseInt(id));
            isCreated = customerDB.updateMedicalHistory(medicalH);
        }
        if (isCreated) {
            request.setAttribute("message", "Medical history edit successfully!");
        } else {
            request.setAttribute("message", "Failed to edit medical history.");
        }
        response.sendRedirect("ShowCustomerMedicalDetail?cid=" + cid);
    }

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {

    }

}
