package controller.AdminController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import model.Doctor;
import model.system.User;

public class SearchDoctor extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String doctorNameStr = request.getParameter("doctorName");
        String doctorName = null;
        if (doctorNameStr != null) {
            doctorNameStr = doctorNameStr.trim().replaceAll("\\s+", " ");
            doctorNameStr = doctorNameStr.replace(" ", "%");
            doctorName = doctorNameStr;
        }
        String doctorDateStr = request.getParameter("doctorDate");
        String doctorGenderStr = request.getParameter("doctorGender");
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");
        String sort = "default";
        int sizeOfEachTable = 10;
        Date doctorDate = null;
        if (doctorDateStr != null && !doctorDateStr.isEmpty()) {
            try {
                doctorDate = java.sql.Date.valueOf(doctorDateStr);
            } catch (IllegalArgumentException e) {
                doctorDate = null;
            }
        }

        Boolean doctorGender = null;
        if (doctorGenderStr != null && !doctorGenderStr.isEmpty()) {
            doctorGender = doctorGenderStr.equalsIgnoreCase("male") ? true : false;
        }

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
        if (sizeStr != null) {
            sizeOfEachTable = Integer.parseInt(sizeStr);
        }
        DoctorDBContext doctorDB = new DoctorDBContext();
        ArrayList<Doctor> resultLists = doctorDB.searchDoctor(doctorName, (java.sql.Date) doctorDate, doctorGender, page, sort, sizeOfEachTable);
        int totaldoctors = doctorDB.countSearchDoctor(doctorName, (java.sql.Date) doctorDate, doctorGender);
        int totalPages = (int) Math.ceil((double) totaldoctors / sizeOfEachTable);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("doctors", resultLists);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("SearchDoctor.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
