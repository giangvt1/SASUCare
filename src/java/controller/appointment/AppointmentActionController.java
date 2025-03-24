package controller.appointment;

import controller.systemaccesscontrol.BaseRBACController;
import dao.AppointmentDBContext;
import dao.CustomerDBContext;
import dao.DoctorScheduleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.Appointment;
import model.Customer;
import model.DoctorSchedule;

/**
 * Handles appointment approval and cancellation by doctors.
 */
public class AppointmentActionController extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final DoctorScheduleDBContext dsDB = new DoctorScheduleDBContext();
    private final CustomerDBContext cusDB = new CustomerDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String appointmentIdStr = request.getParameter("appointmentId");

        // Preserve filter parameters
        String name = request.getParameter("name");
        String date = request.getParameter("date");
        String status = request.getParameter("status");
        String pageIndex = request.getParameter("pageIndex");
        String pageSize = request.getParameter("pageSize");

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/hr/appointments?error=Invalid appointment ID");
            return;
        }

        Appointment appointment = appointmentDB.get(String.valueOf(appointmentId));
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/hr/appointments?error=Appointment not found");
            return;
        }

        Customer customer = cusDB.getCustomerById(appointment.getCustomer().getId());
        if (customer == null || customer.getGmail() == null || customer.getGmail().trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/hr/appointments?error=Customer email not found");
            return;
        }

        String customerEmail = customer.getGmail();
        String customerName = customer.getFullname();

        // Process action
        String subject, messageText;
        switch (action.toLowerCase()) {
            case "confirmed":
                appointment.setStatus("Confirmed");
                subject = "Appointment Confirmation";
                messageText = "Dear " + customerName + ",\n\nYour appointment on " + appointment.getDoctorSchedule().getScheduleDate()
                        + " has been confirmed.\n\nThank you!";
                break;

            case "canceled":
                appointment.setStatus("Canceled");
                subject = "Appointment Cancellation";
                messageText = "Dear " + customerName + ",\n\nYour appointment on " + appointment.getDoctorSchedule().getScheduleDate()
                        + " has been canceled.\n\nPlease contact us for assistance.";

                // Mark doctor schedule as available
                DoctorSchedule doctorSchedule = dsDB.get(String.valueOf(appointment.getDoctorSchedule().getId()));
                if (doctorSchedule != null) {
                    doctorSchedule.setAvailable(true);
                    dsDB.update(doctorSchedule);
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/hr/appointments?error=Invalid action");
                return;
        }

        boolean emailSent = sendEmail(customerEmail, messageText);
        if (!emailSent) {
            System.err.println("Failed to send email to " + customerEmail);
        }

        appointmentDB.update(appointment);

        // Redirect back while preserving filters
        if (name == null && date == null && status == null && pageSize == null && pageIndex == null) {
            response.sendRedirect(request.getContextPath() + "/hr/appointments");
        } else {
            response.sendRedirect(request.getContextPath() + "/hr/appointments?name=" + name + "&date=" + date
                    + "&status=" + status + "&pageIndex=" + pageIndex + "&pageSize=" + pageSize);
        }
    }

    /**
     * Sends an email using Gmail SMTP.
     */
    public boolean sendEmail(String recipientEmail, String messageText) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("Recipient email is null or empty.");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("giangvthe187264@fpt.edu.vn", "dgoalidwbptuooya");
            }
        });
        session.setDebug(true);

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("giangvthe187264@fpt.edu.vn"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Appointment Notification");
            message.setText(messageText);

            Transport.send(message);
            System.out.println("Email sent successfully to " + recipientEmail);
            return true;
        } catch (MessagingException e) {
            System.err.println("CANT SEND GMAIL");
            return false;
        }
    }
}
