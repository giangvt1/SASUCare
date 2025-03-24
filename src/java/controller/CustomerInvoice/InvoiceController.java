package controller.CustomerInvoice;

import dao.AppointmentDBContext;
import dao.InvoiceDBContext;
import dao.TransactionDBContext;
import model.Invoice;
import model.Transaction;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.google.gson.Gson;

import java.io.IOException;
import model.Appointment;

@WebServlet("/customer/invoice-details/*")
public class InvoiceController extends HttpServlet {

    private final InvoiceDBContext invoiceDB = new InvoiceDBContext();
    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();
    private final TransactionDBContext transactionDB = new TransactionDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the customer from session
        HttpSession session = request.getSession();
//        Customer customer = (Customer) session.getAttribute("currentCustomer");
//
//        if (customer == null) {
//            response.sendRedirect(request.getContextPath() + "/Home.jsp");
//            return;
//        }

        // Extract the invoice ID from the URL path
        String pathInfo = request.getPathInfo();
        String[] pathParts = pathInfo.split("/");
        int invoiceId = Integer.parseInt(pathParts[1]);

        // Fetch the invoice based on the ID
        Invoice invoice = invoiceDB.get(invoiceId);
        if (invoice == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
            return;
        }

        // Fetch the appointment and transaction details
        Appointment appointment = appointmentDB.get(String.valueOf(invoice.getAppointmentId()));
        Transaction transaction = transactionDB.getTransactionsByInvoiceId(invoiceId);

        // Prepare a response object with the data
        InvoiceDetailsResponse responseData = new InvoiceDetailsResponse(invoice, transaction, appointment);

        // Convert the response object to JSON using Gson
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);

        // Set content type and send JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
    }

    // Response DTO to structure the JSON response
    public static class InvoiceDetailsResponse {
        private Invoice invoice;
        private Transaction transaction;
        private Appointment appointment;

        public InvoiceDetailsResponse(Invoice invoice, Transaction transaction, Appointment appointment) {
            this.invoice = invoice;
            this.transaction = transaction;
            this.appointment = appointment;
        }

        public Invoice getInvoice() {
            return invoice;
        }

        public Transaction getTransaction() {
            return transaction;
        }

        public Appointment getAppointment() {
            return appointment;
        }
    }
}
