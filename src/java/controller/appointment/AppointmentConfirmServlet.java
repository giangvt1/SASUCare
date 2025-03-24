package controller.appointment;

import com.vnpay.common.Config;
import dao.AppointmentDBContext;
import dao.CustomerDBContext;
import dao.DoctorDBContext;
import dao.DoctorScheduleDBContext;
import dao.InvoiceDBContext; // New import for invoice handling
import model.Appointment;
import model.Customer;
import model.Doctor;
import model.DoctorSchedule;
import model.Invoice; // Invoice model

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

//@WebServlet("/appointment/confirm")
public class AppointmentConfirmServlet extends HttpServlet {

    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final CustomerDBContext customerDB = new CustomerDBContext();
    private final DoctorDBContext doctorDB = new DoctorDBContext();
    private final DoctorScheduleDBContext doctorScheduleDB = new DoctorScheduleDBContext();
    private final InvoiceDBContext invoiceDB = new InvoiceDBContext();  // New invoice DB context

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("currentCustomer") == null) {
            response.setContentType("text/html");
            response.getWriter().println("<script>"
                    + "alert('The user is not logged in. Please login.');"
                    + "window.history.back();"
                    + "</script>");
            return;
        }

        PrintWriter out = response.getWriter();
        try {
            Customer customer = (Customer) session.getAttribute("currentCustomer");

            String doctorId = request.getParameter("doctor");
            String scheduleId = request.getParameter("schedule");
            String action = request.getParameter("action"); // New action parameter for Create Invoice

            Doctor doctor = doctorDB.get(doctorId);
            DoctorSchedule doctorSchedule = doctorScheduleDB.get(scheduleId);

            if (doctor == null || doctorSchedule == null || customer == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"status\":\"error\", \"message\":\"Invalid appointment details.\"}");
                return;
            }

            if (!doctorSchedule.isAvailable()) {
                response.sendRedirect(request.getContextPath() + "/appointment/doctor?date=" + doctorSchedule.getScheduleDate());
                return;
            }

            // Create appointment object
            Appointment appointment = new Appointment();
            appointment.setCustomer(customer);
            appointment.setDoctor(doctor);
            appointment.setDoctorSchedule(doctorSchedule);
            appointment.setStatus("Pending");  // Set initial status to "Pending"

            // Mark doctor schedule as booked
            doctorSchedule.setAvailable(false);
            doctorScheduleDB.update(doctorSchedule);
            appointmentDB.insert(appointment); // Insert appointment into the database
            // Handle invoice creation based on the action parameter
            if ("createInvoice".equals(action)) {
                // Create the invoice after booking
                Invoice invoice = createInvoice(appointment); // Reuse the invoice creation logic

                // Redirect to the invoice list or payment page
                response.sendRedirect(request.getContextPath() + "/appointment/list");  // Redirect to invoice list page
//out.write("{\"status\":\"error\", \"message\":\"Invalid input format.\"}" + invoice);

            } else {
                // If no invoice, just confirm the appointment (pay at hospital)
                response.sendRedirect(request.getContextPath() + "/appointment/list");  // Redirect to appointment list
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"status\":\"error\", \"message\":\"Invalid input format.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\":\"error\", \"message\":\"An error occurred while booking.\"}");
        }
    }

    private Invoice createInvoice(Appointment appointment) {
       
        Invoice invoice = new Invoice();
        invoice.setAmount(Float.parseFloat(appointment.getDoctor().getPrice()));  // Example amount (adjust as per your logic)
        invoice.setOrderInfo("Payment for appointment with Doctor " + appointment.getDoctor().getName());
        invoice.setOrderType("Appointment");
        
        Customer customer = customerDB.getCustomerById(appointment.getCustomer().getId());
        
        invoice.setCustomer(customer);
        invoice.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
        invoice.setExpireDate(new java.sql.Date(System.currentTimeMillis() + (1000 * 60 * 60 * 24))); // Example expiration of 1 day
        invoice.setTxnRef(Config.getRandomNumber(8));  // Generate a random txnRef for VNPAY
        invoice.setStatus("Pending");
        // Set the generated appointmentId to link the invoice to the appointment
        invoice.setAppointmentId(appointment.getId());

        // Save the invoice in the database
        invoiceDB.insert(invoice);

        return invoice;
    }

}
