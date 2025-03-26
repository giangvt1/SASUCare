package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.DoctorDBContext;
import dao.VisitHistoryDBContext;
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
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String customerId = request.getParameter("customerId");
        String reasonForVisit = request.getParameter("reasonForVisit");
        String diagnoses = request.getParameter("diagnoses");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String note = request.getParameter("note");
        String appointmentId = request.getParameter("appointmentId");
        DoctorDBContext doctorDB = new DoctorDBContext();
        int doctorId = doctorDB.getDoctorIdByStaffId(staffId);
        String error = "";

        VisitHistory visitHistory = new VisitHistory();
        visitHistory.setDoctorId(doctorId);
        visitHistory.setCustomerId(Integer.parseInt(customerId));
        visitHistory.setReasonForVisit(reasonForVisit);
        visitHistory.setDiagnoses(diagnoses);
        visitHistory.setTreatmentPlan(treatmentPlan);
        visitHistory.setNote(note);
        visitHistory.setAppointmentId(Integer.parseInt(appointmentId));

        VisitHistoryDBContext visitHistoryDB = new VisitHistoryDBContext();
        boolean isCreated;
        if (id == null || id.isEmpty()) {
            isCreated = visitHistoryDB.createVisitHistory(visitHistory);
        } else {
            visitHistory.setId(Integer.parseInt(id));
            isCreated = visitHistoryDB.updateVisitHistory(visitHistory);
        }

        String message = isCreated ? "Visit history edited successfully!" : "Failed to edit visit history.";

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + error + "');");
        out.println("window.location.href='ShowCustomerMedicalDetail?customerId=" + customerId + "&appointmentId=" + appointmentId + "';");
        out.println("</script>");
    }
}
