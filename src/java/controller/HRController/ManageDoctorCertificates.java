/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.HRController;

import dao.CertificateDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Certificate;
import model.TypeCertificate;

/**
 *
 * @author TRUNG
 */
public class ManageDoctorCertificates extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String doctorNameStr = request.getParameter("doctorName");
        String doctorName = null;
        if (doctorNameStr != null) {
            doctorNameStr = doctorNameStr.trim().replaceAll("\\s+", " ");
            doctorNameStr = doctorNameStr.replace(" ", "%");
            doctorName = doctorNameStr;
        }
        String certificateNameStr = request.getParameter("certificateName");
        String certificateName = null;
        if (certificateNameStr != null) {
            certificateNameStr = certificateNameStr.trim().replaceAll("\\s+", " ");
            certificateNameStr = certificateNameStr.replace(" ", "%");
            certificateName = certificateNameStr;
        }
        String typeName = request.getParameter("typeName");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        String sortStr = request.getParameter("sort");
        String sizeStr = request.getParameter("size");
        String sort = "default";
        int sizeOfEachTable = 10;
        int staffId = Integer.parseInt(request.getParameter("staffId"));
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
        if (sizeStr != null && !sizeStr.isEmpty()) {
            sizeOfEachTable = Integer.parseInt(sizeStr);
        }
        CertificateDBContext cerDAO = new CertificateDBContext();
        List<TypeCertificate> typeList = cerDAO.getAllTypes();

        List<Certificate> certificates = cerDAO.getCertificatesByStaffManageID(certificateName, doctorName, typeName, status, staffId, page, sort, sizeOfEachTable);

        int totalApplications = cerDAO.getCertificateCountByStaffManageID(certificateName, doctorName, typeName, status, staffId);
        int totalPages = (int) Math.ceil((double) totalApplications / sizeOfEachTable);
        request.setAttribute("typeList", typeList);
        request.setAttribute("certificates", certificates);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("ManageDoctorCertificates.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
