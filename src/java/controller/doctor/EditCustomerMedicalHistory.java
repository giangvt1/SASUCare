package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MedicalHistory;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class EditCustomerMedicalHistory extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String name = request.getParameter("name");
        String detail = request.getParameter("detail");
        String id = request.getParameter("id");
        String appointmentId = request.getParameter("appointmentId");
        MedicalHistory medicalH = new MedicalHistory();
        medicalH.setCustomerId(customerId);
        medicalH.setName(name);
        medicalH.setDetail(detail);
        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = false;

        if (id == null || id.isEmpty()) {
            isCreated = customerDB.createMedicalHistory(medicalH);
        } else {
            medicalH.setId(Integer.parseInt(id));
//            isCreated = customerDB.updateMedicalHistory(medicalH);
        }

        String message = isCreated ? "Medical history edited successfully!" : "Failed to edit medical history.";

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ShowCustomerMedicalDetail?customerId=" + customerId + "&appointmentId=" + appointmentId + "';");
        out.println("</script>");
    }

}
