/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.doctor;

import dao.CertificateDBContext;
import dao.DoctorDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Certificate;
import model.TypeCertificate;

public class ManageCertificates extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String certificateNameStr = request.getParameter("certificateName");
        String certificateName = null;
        if (certificateNameStr != null) {
            certificateNameStr = certificateNameStr.trim().replaceAll("\\s+", " ");
            certificateNameStr = certificateNameStr.replace(" ", "%");
            certificateName = certificateNameStr;
        }
        String typeName = request.getParameter("typeName");
        String status = request.getParameter("status");
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
        List<TypeCertificate> typeList = certificateDB.getAllTypes();
        List<Certificate> resultLists = certificateDB.getCertificatesByDoctorID(certificateName, typeName, status, doctorId, page, sort, sizeOfEachTable);
        int totalCertificates = certificateDB.getCertificateCountByDoctorID(certificateName, typeName, status, doctorId);
        int totalPages = (int) Math.ceil((double) totalCertificates / sizeOfEachTable);
        request.setAttribute("typeList", typeList);
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
