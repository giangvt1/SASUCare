/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import dao.CertificateDBContext;
import dao.CustomerDBContext;
import dao.DoctorDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Certificate;

public class ManageCertificates extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DoctorDBContext doctorDB = new DoctorDBContext();
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        int doctorId = doctorDB.getDoctorIdByStaffId(staffId);
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");
        String sort = "default";
        int sizeOfEachTable = 10;
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
        CertificateDBContext certificateDB = new CertificateDBContext();
        List<Certificate> resultLists = certificateDB.getCertificatesByDoctorID(doctorId, page, sort, page);
        int totalCertificates = certificateDB.getCertificateCountByDoctorID(doctorId);
        int totalPages = (int) Math.ceil((double) totalCertificates / sizeOfEachTable);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("certificates", resultLists);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("ManageCertificates.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}
