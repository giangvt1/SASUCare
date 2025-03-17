package controller.AdminController;

import dao.CertificateDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.TypeCertificate;

/**
 *
 * @author TRUNG
 */
public class ManageTypeCertificate extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CertificateDBContext cerDAO = new CertificateDBContext();
        List<TypeCertificate> typeList = cerDAO.getAllTypes();
        request.setAttribute("typeList", typeList);
        request.getRequestDispatcher("ManageTypeCertificate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}