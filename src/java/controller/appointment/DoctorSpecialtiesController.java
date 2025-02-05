/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.appointment;


import dao.DoctorDBContext;
import model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;


public class DoctorSpecialtiesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String doctorIdParam = request.getParameter("doctorId");
        if (doctorIdParam == null) {
            response.sendRedirect("/appointment/doctor");
            return;
        }

        int doctorId = Integer.parseInt(doctorIdParam);
        DoctorDBContext doctorDB = new DoctorDBContext();
        ArrayList<String> specialties = doctorDB.getDoctorSpecialties(doctorId);
        
        request.setAttribute("doctorId", doctorId);
        request.setAttribute("specialties", specialties);
        request.getRequestDispatcher("doctor_specialties.jsp").forward(request, response);
    }
}
