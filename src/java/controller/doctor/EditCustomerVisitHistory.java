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
import model.VisitHistory;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class EditCustomerVisitHistory extends BaseRBACController {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String did = request.getParameter("did");
        String cid = request.getParameter("cid");
        String visitDateStr = request.getParameter("visitDate");
        String reasonForVisit = request.getParameter("reasonForVisit");
        String diagnoses = request.getParameter("diagnoses");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String nextAppointmentStr = request.getParameter("nextAppointment");

        java.sql.Date visitDate = java.sql.Date.valueOf(visitDateStr);

        java.sql.Date nextAppointment = null;
        if (nextAppointmentStr != null && !nextAppointmentStr.isEmpty()) {
            try {
                nextAppointment = java.sql.Date.valueOf(nextAppointmentStr);
            } catch (IllegalArgumentException e) {
                nextAppointment = null;
            }
        }

        VisitHistory visitHistory = new VisitHistory();
        visitHistory.setDid(Integer.parseInt(did));
        visitHistory.setCid(Integer.parseInt(cid));
        visitHistory.setVisitDate(visitDate);
        visitHistory.setReasonForVisit(reasonForVisit);
        visitHistory.setDiagnoses(diagnoses);
        visitHistory.setTreatmentPlan(treatmentPlan);
        visitHistory.setNextAppointment(nextAppointment);

        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = false;
        if (id == null || id.isEmpty()) {
            isCreated = customerDB.createVisitHistory(visitHistory);
        } else {
            visitHistory.setId(Integer.parseInt(id));
            isCreated = customerDB.updateVisitHistory(visitHistory);
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
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
