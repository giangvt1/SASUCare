/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.AdminController;

import dao.ApplicationDBContext;
import dao.CertificateDBContext;
import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import model.TypeApplication;
import model.TypeCertificate;
import model.system.Staff;

/**
 *
 * @author TRUNG
 */
public class EditTypeCertificate extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String staffManage = request.getParameter("staffManage");
        StaffDBContext db = new StaffDBContext();
        List<Staff> staff = db.getStaffByRole(2);
        request.setAttribute("staff", staff);
        request.setAttribute("id", id);
        request.setAttribute("name", name);
        request.setAttribute("staffManage", staffManage);
        request.getRequestDispatcher("EditTypeCertificate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        int staffManageId = Integer.parseInt(request.getParameter("staffManage"));
        String message = "";
        TypeCertificate typeCer = new TypeCertificate();
        typeCer.setName(name);
        typeCer.setStaffManageId(staffManageId);
        CertificateDBContext dao = new CertificateDBContext();
        if (request.getParameter("id") != null && request.getParameter("id").length() != 0) {
            int id = Integer.parseInt(request.getParameter("id"));
            typeCer.setId(id);
            boolean updated = dao.updateTypeCertificate(typeCer);
            if (updated) {
                message = "Update success";
            } else {
                message = "Update fail";
            }
        } else {
            boolean created = dao.createTypeCertificate(typeCer);
            if (created) {
                message = "Create success";
            } else {
                message = "Create fail";
            }
        }
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ManageTypeCertificate';");
        out.println("</script>");
    }
}