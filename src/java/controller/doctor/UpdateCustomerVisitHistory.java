///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller.doctor;
//
//import controller.systemaccesscontrol.BaseRBACController;
//import dao.CustomerDBContext;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.ArrayList;
//import model.Customer;
//import model.MedicalHistory;
//import model.VisitHistory;
//import model.system.User;
//
///**
// *
// * @author TRUNG
// */
//public class UpdateCustomerVisitHistory extends BaseRBACController {
//    @Override
//    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
//        String id = request.getParameter("id");
//        String cid = request.getParameter("cid");
//        String visitDate = request.getParameter("visitDate");
//        String reasonForVisit = request.getParameter("reasonForVisit");
//        String diagnoses = request.getParameter("diagnoses");
//        String treatmentPlan = request.getParameter("treatmentPlan");
//        String nextAppointment = request.getParameter("nextAppointment");
//        request.setAttribute("id", id);
//        request.setAttribute("cid", cid);
//        request.setAttribute("visitDate", visitDate);
//        request.setAttribute("reasonForVisit", reasonForVisit);
//        request.setAttribute("diagnoses", diagnoses);
//        request.setAttribute("treatmentPlan", treatmentPlan);
//        request.setAttribute("nextAppointment", nextAppointment);
//        request.getRequestDispatcher("UpdateCustomerVisitHistory.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
//        String id = request.getParameter("id");
//        String did = request.getParameter("did");
//        String cid = request.getParameter("cid");
//        String visitDateStr = request.getParameter("visitDate");
//        String reasonForVisit = request.getParameter("reasonForVisit");
//        String diagnoses = request.getParameter("diagnoses");
//        String treatmentPlan = request.getParameter("treatmentPlan");
//        String nextAppointmentStr = request.getParameter("nextAppointment");
//
//        java.sql.Date visitDate = java.sql.Date.valueOf(visitDateStr); // Chuyển đổi đúng cách sang java.sql.Date
//
//        java.sql.Date nextAppointment = null;
//        if (nextAppointmentStr != null && !nextAppointmentStr.isEmpty()) {
//            try {
//                nextAppointment = java.sql.Date.valueOf(nextAppointmentStr);
//            } catch (IllegalArgumentException e) {
//                nextAppointment = null;
//            }
//        }
//
//        VisitHistory visitHistory = new VisitHistory();
//        visitHistory.setId(Integer.parseInt(id));
//        visitHistory.setDid(Integer.parseInt(did));
//        visitHistory.setCid(Integer.parseInt(cid));
//        visitHistory.setVisitDate(visitDate);
//        visitHistory.setReasonForVisit(reasonForVisit);
//        visitHistory.setDiagnoses(diagnoses);
//        visitHistory.setTreatmentPlan(treatmentPlan);
//        visitHistory.setNextAppointment(nextAppointment);
//
//        CustomerDBContext customerDB = new CustomerDBContext();
//        boolean isCreated = customerDB.updateVisitHistory(visitHistory);
//
//        if (isCreated) {
//            request.setAttribute("message", "Medical history created successfully!");
//        } else {
//            request.setAttribute("message", "Failed to create medical history.");
//        }
//        response.sendRedirect("ShowCustomerMedicalDetail?cid=" + cid);
//    }
//
//}
