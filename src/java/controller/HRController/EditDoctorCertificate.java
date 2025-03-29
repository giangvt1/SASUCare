package controller.HRController;

import dao.CertificateDBContext;
import dao.DoctorDBContext;
import dao.GoogleDBContext;
import dao.StaffDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Certificate;

/**
 *
 * @author TRUNG
 */
public class EditDoctorCertificate extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String certificateId = request.getParameter("certificateId");
        String status = request.getParameter("status");
        CertificateDBContext cerDAO = new CertificateDBContext();
        Certificate certificate = cerDAO.getCertificateById(Integer.parseInt(certificateId));
        request.setAttribute("certificate", certificate);
        request.setAttribute("status", status);
        request.getRequestDispatcher("EditDoctorCertificate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        int certificateId = Integer.parseInt(request.getParameter("certificateId"));
        String status = request.getParameter("status");
        String certificateName = request.getParameter("certificateName");
        String checkNote = request.getParameter("checkNote");
        String message = "";
        Certificate c = new Certificate();
        c.setCertificateId(certificateId);
        c.setStatus(status);
        c.setCheckNote(checkNote);
        c.setCheckedByStaffId(staffId);
        CertificateDBContext cerDAO = new CertificateDBContext();
        GoogleDBContext g = new GoogleDBContext();
        StaffDBContext s = new StaffDBContext();
        DoctorDBContext docDAO = new DoctorDBContext();
        int staffDoctorId = docDAO.getStaffIdByDoctorId(doctorId);
        String gmail = s.getUserGmailByStaffId(staffDoctorId);
        boolean isCreated = cerDAO.updateCertificateForDoctor(c);

        if (isCreated) {
            message = "Certificate edit successfully!";
            String title = "Chứng chỉ " + certificateName + " của bạn đã " + status;
            String mess = "Lý do:" + checkNote;
            g.sendMail(gmail, title, mess);

        } else {
            message = "Failed to edit certificate.";
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ManageDoctorCertificates?staffId=" + staffId + "';");
        out.println("</script>");
    }

}
