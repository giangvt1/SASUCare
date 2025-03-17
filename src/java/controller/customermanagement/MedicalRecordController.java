/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customermanagement;

import dao.MedicalRecordDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Customer;
import model.MedicalRecord;

/**
 *
 * @author ngoch
 */
public class MedicalRecordController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        MedicalRecordDBContext dao = new MedicalRecordDBContext();
        String recordIdStr = request.getParameter("recordId");
        HttpSession session = request.getSession();
        int record_id = Integer.parseInt(recordIdStr);
        
        if ("delete".equals(action)) {
            dao.deleteById(record_id);
            response.sendRedirect("./listrecord");
        } else if ("update".equals(action)) {
            MedicalRecord record = dao.getRecordById(record_id);
            request.setAttribute("action", action);
            session.setAttribute("record", record);

            request.getRequestDispatcher("./customer/createrecord.jsp").forward(request, response);

        }
    } 
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        MedicalRecordDBContext dao = new MedicalRecordDBContext();

        // Lấy các parameter từ form
        int customer_id = customer.getId();
        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String job = request.getParameter("job");
        String idNumber = request.getParameter("idNumber");
        String email = request.getParameter("email");
        String nation = request.getParameter("nation");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String addressDetail = request.getParameter("addressDetail");

        // Chuyển đổi chuỗi ngày sinh sang đối tượng Date
        Date dob = null;
        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            dob = format.parse(dobStr);
        } catch (ParseException e) {
            e.printStackTrace();
            // Có thể chuyển hướng về trang lỗi nếu cần
        }

        // Tạo đối tượng record
        MedicalRecord record = new MedicalRecord(customer_id, fullName, dob, phone, gender, job, idNumber, email, nation, province, district, ward, addressDetail);

        // Kiểm tra action
        String action = request.getParameter("action");
        if ("update".equalsIgnoreCase(action)) {
            // Nếu là update, lấy recordId và gọi phương thức update
            String recordIdStr = request.getParameter("recordId");
            if(recordIdStr != null) {
                try {
                    int recordId = Integer.parseInt(recordIdStr);
                    record.setRecord_id(recordId); // giả sử có setter này
                    dao.update(record);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    // Xử lý lỗi khi chuyển đổi recordId không thành công
                }
            }
        } else {
            // Nếu không phải update, thực hiện insert
            dao.insert(record);
        }

        response.sendRedirect("./listrecord");
    }

}
