package controller.doctor;

import dao.CertificateDBContext;
import dao.DoctorDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Certificate;
import model.TypeCertificate;

/**
 *
 * @author TRUNG
 */
public class EditCertificate extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CertificateDBContext cerDAO = new CertificateDBContext();
        List<TypeCertificate> typeList = cerDAO.getAllTypes();
        request.setAttribute("typeList", typeList);
        request.getRequestDispatcher("EditCertificate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String certificateName = request.getParameter("certificateName");
        int typeId = Integer.parseInt(request.getParameter("typeId"));
        String issueDateStr = request.getParameter("issueDate");
        String documentPath = request.getParameter("documentPath");
        DoctorDBContext doctorDB = new DoctorDBContext();
        CertificateDBContext certificateDB = new CertificateDBContext();
        int doctorId = doctorDB.getDoctorIdByStaffId(staffId);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.sql.Date issueDate = null;
        java.sql.Date expirationDate = null;

        try {
            if (issueDateStr != null && !issueDateStr.isEmpty()) {
                issueDate = new java.sql.Date(sdf.parse(issueDateStr).getTime());
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Certificate c = new Certificate();
        c.setCertificateName(certificateName);
        c.setTypeId(typeId);
        c.setIssueDate(issueDate);
        c.setDocumentPath(documentPath);
        c.setDoctorId(doctorId);
        boolean isCreated;
        isCreated = certificateDB.createCertificate(c);
        String message = isCreated ? "Certificate created successfully!" : "Failed to create visit Certificate.";

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ManageCertificates?staffId=" + staffId + "';");
        out.println("</script>");
    }
}
