package controller.doctor;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.User;

public class DeleteCustomerVisitHistory extends BaseRBACController {
    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String cid = request.getParameter("cid");
        String id = request.getParameter("id");

        // Tạo đối tượng DBContext để lưu MedicalHistory vào cơ sở dữ liệu
        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = customerDB.deleteVisitHistory(Integer.parseInt(id));

        // Thông báo kết quả
        if (isCreated) {
            request.setAttribute("message", "Medical history created successfully!");
        } else {
            request.setAttribute("message", "Failed to create medical history.");
        }
        response.sendRedirect("ShowCustomerMedicalDetail?cid=" + cid);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
    }

}
