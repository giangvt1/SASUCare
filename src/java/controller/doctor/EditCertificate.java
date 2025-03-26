package controller.doctor;

import dao.CertificateDBContext;
import dao.DoctorDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Certificate;
import model.TypeCertificate;

@MultipartConfig
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
        Part filePart = request.getPart("file");
        DoctorDBContext doctorDB = new DoctorDBContext();
        CertificateDBContext certificateDB = new CertificateDBContext();
        int doctorId = doctorDB.getDoctorIdByStaffId(staffId);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.sql.Date issueDate = null;

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

        if (filePart != null && filePart.getSize() > 0) {
            if (filePart.getSize() > 3145728) {
                sendAlert(response, "File size too large. Maximum allowed size is 3 MB.", "EditCertificate");
                return;
            }

            String fileNameLower = filePart.getSubmittedFileName().toLowerCase();
            if (!fileNameLower.endsWith(".pdf")) {
                sendAlert(response, "Invalid file type. Only PDF files are allowed.", "EditCertificate");
                return;
            }

            String uploadPath = getUploadFolder(request);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Tạo tên file mới: doctorId + timestamp + .pdf
            String newFileName = doctorId + "_" + System.currentTimeMillis() + ".pdf";
            String filePath = uploadPath + File.separator + newFileName;

            filePart.write(filePath);

            c.setFile("pdfFile/" + newFileName);
        }

        boolean isCreated = certificateDB.createCertificate(c);
        String message = isCreated ? "Certificate created successfully!" : "Failed to create Certificate.";
        sendAlert(response, message, "ManageCertificates?staffId=" + staffId);
    }

    private String getUploadFolder(HttpServletRequest request) {
        // Lấy đường dẫn thư mục "build/web"
        String buildWebPath = request.getServletContext().getRealPath("/");

        // Chuyển thành File object để thao tác
        File buildWebDir = new File(buildWebPath);

        // Di chuyển lên thư mục gốc của dự án (Project)
        File projectDir = buildWebDir.getParentFile().getParentFile();

        // Trỏ đến thư mục "web/pdfFile"
        File uploadFolder = new File(projectDir, "web/pdfFile");

        // Tạo thư mục nếu chưa tồn tại
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        return uploadFolder.getAbsolutePath();
    }

    private void sendAlert(HttpServletResponse response, String message, String redirectUrl) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='" + redirectUrl + "';");
        out.println("</script>");
    }
}
