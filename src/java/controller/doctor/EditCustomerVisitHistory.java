
package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.VisitHistory;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class EditCustomerVisitHistory extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String id = request.getParameter("id");
        String did = request.getParameter("did");
        String cid = request.getParameter("cid");
        String visitDateStr = request.getParameter("visitDate");
        String reasonForVisit = request.getParameter("reasonForVisit");
        String diagnoses = request.getParameter("diagnoses");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String nextAppointmentStr = request.getParameter("nextAppointment");

        java.sql.Date visitDate = java.sql.Date.valueOf(visitDateStr);

        java.sql.Date nextAppointment = null;
        if (nextAppointmentStr != null && !nextAppointmentStr.isEmpty()) {
            try {
                nextAppointment = java.sql.Date.valueOf(nextAppointmentStr);
            } catch (IllegalArgumentException e) {
                nextAppointment = null;
            }
        }

        VisitHistory visitHistory = new VisitHistory();
        visitHistory.setDid(Integer.parseInt(did));
        visitHistory.setCid(Integer.parseInt(cid));
        visitHistory.setVisitDate(visitDate);
        visitHistory.setReasonForVisit(reasonForVisit);
        visitHistory.setDiagnoses(diagnoses);
        visitHistory.setTreatmentPlan(treatmentPlan);
        visitHistory.setNextAppointment(nextAppointment);

        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated = false;
        if (id == null || id.isEmpty()) {
            isCreated = customerDB.createVisitHistory(visitHistory);
        } else {
            visitHistory.setId(Integer.parseInt(id));
            isCreated = customerDB.updateVisitHistory(visitHistory);
        }

        String message = isCreated ? "Visit history edited successfully!" : "Failed to edit visit history.";

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ShowCustomerMedicalDetail?cid=" + cid + "';");
        out.println("</script>");
    }

}
