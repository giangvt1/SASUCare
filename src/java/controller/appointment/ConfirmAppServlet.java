package controller.appointment;

import dao.AppointmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;
import dao.CustomerDBContext;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;
import model.Appointment;
import model.Customer;

/**
 * Servlet to handle appointment confirmation actions (Completed or Not
 * Complete).
 */
@WebServlet("/doctor/confirmApp")
public class ConfirmAppServlet extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final CustomerDBContext cusDB = new CustomerDBContext();
    private static Map<String, Long> lastOTPSentTime = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Read the request body (JSON)
        String jsonRequest = request.getReader().lines()
                .reduce("", (accumulator, actual) -> accumulator + actual);

        // Parse the incoming request data
        Gson gson = new Gson();
        ConfirmAppointmentRequest confirmRequest = gson.fromJson(jsonRequest, ConfirmAppointmentRequest.class);

        // Get the appointment from the DB
        Appointment appointment = appointmentDB.get(String.valueOf(confirmRequest.appointmentId));

        if (appointment == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"success\": false, \"message\": \"Appointment not found.\"}");
            return;
        }
        Customer customer = cusDB.getCustomerById(appointment.getCustomer().getId());

        // Set the status based on the action
        appointment.setStatus(confirmRequest.action);

        // You can add an email subject and body based on the action
        String subject = "";
        String messageText = "";
        if ("Done".equalsIgnoreCase(confirmRequest.action)) {
            subject = "Appointment Done";
            messageText = "Dear " + customer.getFullname() + ",\n\nYour appointment on "
                    + appointment.getDoctorSchedule().getScheduleDate() + " has been marked as Done.\n\n"
                    + "Appointment Summary: " + confirmRequest.summary + "\n"
                    + "Notes: " + confirmRequest.notes + "\n\n"
                    + "Thank you for using our service!";
        } else if ("Not Complete".equalsIgnoreCase(confirmRequest.action)) {
            subject = "Appointment Not Completed";
            messageText = "Dear " + customer.getFullname() + ",\n\nYour appointment on "
                    + appointment.getDoctorSchedule().getScheduleDate() + " was marked as 'Not Complete'.\n\n"
                    + "Appointment Summary: " + confirmRequest.summary + "\n"
                    + "Notes: " + confirmRequest.notes + "\n\n"
                    + "Please contact us for further assistance.";
        }

        // Send the email
        boolean emailSent = sendEmail(customer.getGmail(), messageText);
        if (!emailSent) {
            System.err.println("Failed to send email to " + appointment.getCustomer().getGmail());
        }

        // Update appointment status in the database
        appointmentDB.update(appointment);

        // Respond with success
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"message\": \"Appointment updated and email sent successfully.\"}");
    }

    // Inner class to capture request data
    private static class ConfirmAppointmentRequest {

        private int appointmentId;
        private String action;  // "Confirmed" or "Not Complete"
        private String summary;  // Not needed for DB, used for email
        private String notes;    // Not needed for DB, used for email
    }

    /**
     * Sends an email using Gmail SMTP.
     */
    public boolean sendEmail(String recipientEmail, String messageText) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("Recipient email is null or empty.");
            return false;
        }
        long currentTime = System.currentTimeMillis();
        Long lastSentTime = lastOTPSentTime.get(recipientEmail);
        if (lastSentTime != null && (currentTime - lastSentTime) < 300_000) {
            System.err.println("Please wait at least 5 minutes before requesting another OTP.");
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
