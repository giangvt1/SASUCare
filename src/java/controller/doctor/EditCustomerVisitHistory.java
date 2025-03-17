package controller.doctor;

import controller.systemaccesscontrol.BaseRBACController;
import dao.CustomerDBContext;
import dao.DoctorRatingDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
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
        request.setCharacterEncoding("UTF-8"); // Đảm bảo encoding đúng

        String id = request.getParameter("id");
        int staffId = Integer.parseInt(request.getParameter("sId"));
        String customerId = request.getParameter("cId");
        String visitDateStr = request.getParameter("visitDate");
        String reasonForVisit = request.getParameter("reasonForVisit");
        String diagnoses = request.getParameter("diagnoses");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String nextAppointmentStr = request.getParameter("nextAppointment");

        System.out.println("Received visitDateStr: " + visitDateStr);
        System.out.println("Received nextAppointmentStr: " + nextAppointmentStr);

        DoctorRatingDBContext doctorDB = new DoctorRatingDBContext();
        int doctorId = doctorDB.getDoctorIdByStaffId(staffId);
        Timestamp visitDate = null;
        Timestamp nextAppointment = null;
        String error = "";

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        try {
            if (visitDateStr != null && !visitDateStr.isEmpty()) {
                visitDate = new Timestamp(format.parse(visitDateStr).getTime());
            }
            if (nextAppointmentStr != null && !nextAppointmentStr.isEmpty()) {
                nextAppointment = new Timestamp(format.parse(nextAppointmentStr).getTime());
            }
        } catch (ParseException ex) {
            ex.printStackTrace();
            error = "Date format is incorrect.";
        }

        VisitHistory visitHistory = new VisitHistory();
        visitHistory.setDoctorId(doctorId);
        visitHistory.setCustomerId(Integer.parseInt(customerId));
        visitHistory.setVisitDate(visitDate);
        visitHistory.setReasonForVisit(reasonForVisit);
        visitHistory.setDiagnoses(diagnoses);
        visitHistory.setTreatmentPlan(treatmentPlan);
        visitHistory.setNextAppointment(nextAppointment);

        CustomerDBContext customerDB = new CustomerDBContext();
        boolean isCreated;
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
        out.println("alert('" + message + error + "');");
        out.println("window.location.href='ShowCustomerMedicalDetail?cId=" + customerId + "';");
        out.println("</script>");
    }
}
